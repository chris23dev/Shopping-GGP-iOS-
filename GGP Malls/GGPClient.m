//
//  GGPClient.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/9/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPAlert.h"
#import "GGPAppConfig.h"
#import "GGPCategory.h"
#import "GGPClient.h"
#import "GGPDateRange.h"
#import "GGPEvent.h"
#import "GGPHero.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMallResponse.h"
#import "GGPMovieTheater.h"
#import "GGPParkingSite.h"
#import "GGPSale.h"
#import "GGPTenant.h"
#import "GGPSweepstakes.h"
#import <AFOAuth2Manager/AFOAuth2Manager.h>
#import <Overcoat/Overcoat.h>

NSString *const GGPClientReachabilityChanged = @"GGPClientReachabilityChanged";
static NSString *const kUsername = @"ios_read";
static NSString *const kPassword = @"XWjvrpMfykcW8A5L";
static NSString *const kCredentialId = @"credentialId";
static NSString *const kAuthorization = @"Authorization";
static NSString *const kBearer = @"Bearer";
static NSString *const kEtag = @"Etag";

#ifdef DEBUG
    static NSString *const kBaseURL = @"https://digitalservices-qa.ggp.com/mall-api/";
#elif QA
    static NSString *const kBaseURL = @"https://digitalservices-qa.ggp.com/mall-api/";
#elif PROD
    static NSString *const kBaseURL = @"https://digitalservices.ggp.com/mall-api/";
#else
    static NSString *const kBaseURL = @"";
#endif

@interface GGPClient ()

@property (strong, nonatomic) AFOAuthCredential *authenticationCredential;
@property (strong, nonatomic) AFOAuth2Manager *oAuth2Manager;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSMutableDictionary *etagLookup;

@end

@implementation GGPClient

+ (GGPClient *)sharedInstance {
    static GGPClient *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[GGPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
        instance.oAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL] clientID:kUsername secret:kPassword];
        instance.dateFormatter = [NSDateFormatter new];
        instance.dateFormatter.dateFormat = @"yyyy-MM-dd";
        instance.etagLookup = [NSMutableDictionary dictionary];
        [self startReachabilityMonitoring];
    });
    
    return instance;
}

#pragma mark Configuration

- (void)start {
    [GGPClient startReachabilityMonitoring];
    [self authenticateWithCompletion:nil];
}

+ (void)startReachabilityMonitoring {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GGPClientReachabilityChanged object:nil];
    }];
}

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"mobile-app/config": [GGPAppConfig class],
             @"malls": [GGPMallResponse class],
             @"malls/#": [GGPMall class],
             @"malls/#/date-ranges": [GGPDateRange class],
             @"malls/#/movie-theaters": [GGPMovieTheater class],
             @"malls/#/stores": [GGPTenant class],
             @"malls/#/sales":[GGPSale class],
             @"stores/#/sales": [GGPSale class],
             @"malls/#/events": [GGPEvent class],
             @"malls/#/alerts": [GGPAlert class],
             @"malls/search/searchByLatLong": [GGPMall class],
             @"malls/search/searchByName": [GGPMall class],
             @"malls/#/heroes": [GGPHero class],
             @"config/sweepstakes": [GGPSweepstakes class],
             @"categories": [GGPCategory class],
             @"campaigns": [GGPCategory class],
	     @"malls/#/park-assist": [GGPParkingSite class],
             };
}

- (AFOAuthCredential *)authenticationCredential {
    return [AFOAuthCredential retrieveCredentialWithIdentifier:kCredentialId];
}

- (void)setAuthenticationCredential:(AFOAuthCredential *)authenticationCredential {
    [AFOAuthCredential storeCredential:authenticationCredential withIdentifier:kCredentialId];
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {
    NSMutableURLRequest *modifiedRequest = request.mutableCopy;
    
    [self configureCachePolicyForRequest:modifiedRequest];
    
    if ([request.URL.absoluteString containsString:kBaseURL]) {
        [self addAuthorizationHeaderToRequest:modifiedRequest];
    }
    
    void (^authFailBlock)(NSURLResponse *, id, NSError *) = ^(NSURLResponse *response, id responseObject, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if([httpResponse statusCode] == 401) {
            [self retryAfterAuthenicatingRequest:modifiedRequest withCompletion:completionHandler];
        } else {
            completionHandler(response, responseObject, error);
        }
    };
    
    return [super dataTaskWithRequest:modifiedRequest completionHandler:authFailBlock];
}

- (void)retryAfterAuthenicatingRequest:(NSMutableURLRequest *)request withCompletion:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable))onCompletion {
    GGPLogWarn(@"Unauthorized request. Attempting to authenticate");
    
    // We were running into the scenario where a saved auth token was not expired, yet caused 401s. So we need to clear it out to allow a new one to save
    [self removeExistingAuthToken];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self authenticateWithCompletion:^(BOOL isAuthenticated) {
            [self addAuthorizationHeaderToRequest:request];
            NSURLSessionDataTask *originalTask = [super dataTaskWithRequest:request completionHandler:onCompletion];
            [originalTask resume];
        }];
    });
}

- (void)configureCachePolicyForRequest:(NSMutableURLRequest *)request {
    if ([self isOffline]) {
        request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        GGPLogWarn(@"OFFLINE: force use cached response if avaiable");
    } else {
        request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
}

- (BOOL)isOffline {
    return self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable;
}

- (void)addAuthorizationHeaderToRequest:(NSMutableURLRequest *)request {
    if ([self isValidCredential:self.authenticationCredential]) {
        NSString *authValue = [NSString stringWithFormat:@"%@ %@", kBearer, self.authenticationCredential.accessToken];
        [request setValue:authValue forHTTPHeaderField:kAuthorization];
    }
}

- (BOOL)isValidCredential:(AFOAuthCredential *)credential {
    return credential && !credential.isExpired;
}

- (void)authenticateWithCompletion:(void(^)(BOOL isAuthenticated))onCompletion {
    if ([self isValidCredential:self.authenticationCredential]) {
        GGPLogInfo(@"Already authenticated");
        if (onCompletion) {
            onCompletion(YES);
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [self.oAuth2Manager authenticateUsingOAuthWithURLString:@"oauth/token" parameters:@{@"grant_type": kAFOAuthClientCredentialsGrantType} success:^(AFOAuthCredential *credential) {
            GGPLogInfo(@"Successfully authenticated");
            weakSelf.authenticationCredential = credential;
            if (onCompletion) {
                onCompletion(YES);
            }
        } failure:^(NSError *error) {
            GGPLogError(@"Error authenticating: %@", error.localizedDescription);
            if (onCompletion) {
                onCompletion(NO);
            }
        }];
    }
}

- (NSString *)dateParamForRequest {
    return [self.dateFormatter stringFromDate:[NSDate date]];
}

- (void)removeExistingAuthToken {
    GGPLogInfo(@"Removing existing auth token if exists");
    [AFOAuthCredential deleteCredentialWithIdentifier:kCredentialId];
}

- (BOOL)handleEtagForResponse:(NSHTTPURLResponse *)response {
    NSString *lookupKey = response.URL.absoluteString;
    NSString *responseEtag = [response.allHeaderFields objectForKey:kEtag];
    
    if (!responseEtag) {
        if (lookupKey) {
            [self.etagLookup removeObjectForKey:lookupKey];
        }
        return NO;
    }
    
    NSString *currentEtag = [self.etagLookup objectForKey:lookupKey];
    self.etagLookup[lookupKey] = responseEtag;
    
    return currentEtag && ![currentEtag isEqualToString:responseEtag];
}

#pragma mark App Config

- (void)fetchAppConfigWithCompletion:(void (^)(GGPAppConfig *, NSError *))completion {
    [self GET:@"mobile-app/config" parameters:nil completion:^(OVCResponse *response, NSError *error) {
        if (completion) {
            completion(response.result, error);
        }
    }];
}

#pragma mark Alerts

- (void)fetchAlertsForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *alerts, NSError *error))completion {
    NSString *requestString = [NSString stringWithFormat:@"malls/%ld/alerts", (long)mallId];
    [self GET:requestString parameters:@{ @"date": [[GGPClient sharedInstance] dateParamForRequest]} completion:^(OVCResponse *response, NSError *error) {
        if (!error && [self handleEtagForResponse:response.HTTPResponse]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGPClientAlertsUpdatedNotification object:nil];
        } else if (error) {
            GGPLogError(@"Error fetching alerts: %@", error.localizedDescription);
        }
        if (completion) {
            completion(error ? nil : response.result, error);
        }
    }];
}

#pragma mark Categories

- (void)fetchCategoriesWithCompletion:(void (^)(NSArray *categories, NSError *error))completion {
    [self GET:@"categories" parameters:nil completion:^(OVCResponse *response, NSError *error) {
        if (!error && [self handleEtagForResponse:response.HTTPResponse]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGPClientTenantsUpdatedNotification object:nil];
        } else if (error) {
            GGPLogError(@"Error fetching categories: %@", error.localizedDescription);
        }
        if (completion) {
            completion(error ? nil : response.result, error);
        }
    }];
}

- (void)fetchCampaignsWithCompletion:(void (^)(NSArray *campaigns, NSError *error))completion {
    [self GET:@"campaigns" parameters:nil completion:^(OVCResponse *response, NSError *error) {
        if (!error && [self handleEtagForResponse:response.HTTPResponse]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGPClientTenantsUpdatedNotification object:nil];
        } else if (error) {
            GGPLogError(@"Error fetching campaigns: %@", error.localizedDescription);
        }
        if (completion) {
            completion(error ? nil : response.result, error);
        }
    }];
}

#pragma mark Date Ranges

- (void)fetchDateRangesForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *dateRanges, NSError *error))completion {
    NSString *requestString = [NSString stringWithFormat:@"malls/%ld/date-ranges", (long)mallId];
    [self GET:requestString parameters:nil completion:^(OVCResponse *response, NSError *error) {
        if (!error && [self handleEtagForResponse:response.HTTPResponse]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGPMallManagerMallUpdatedNotification object:nil];
        } else if (error) {
            GGPLogError(@"Error fetching date ranges: %@", error.localizedDescription);
        }
        
        if (completion) {
            completion(error ? nil : response.result, error);
        }
    }];
}

#pragma mark Events

- (void)fetchEventsForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *events, NSError *error))completion {
    NSString *requestString = [NSString stringWithFormat:@"malls/%ld/events", (long)mallId];
    [self GET:requestString parameters:@{ @"date": [[GGPClient sharedInstance] dateParamForRequest]} completion:^(OVCResponse *response, NSError *error) {
        if (!error && [self handleEtagForResponse:response.HTTPResponse]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGPClientEventsUpdatedNotification object:nil];
        } else if (error) {
            GGPLogError(@"Error fetching events: %@", error.localizedDescription);
        }
        if (completion) {
            completion(error ? nil : response.result, error);
        }
    }];
}

#pragma mark Heroes

- (void)fetchHeroesForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *heroes, NSError *error))completion {
    NSString *requestString = [NSString stringWithFormat:@"malls/%ld/heroes", (long)mallId];
    [self GET:requestString parameters:nil completion:^(OVCResponse *response, NSError *error) {
        if (!error && [self handleEtagForResponse:response.HTTPResponse]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGPClientHeroesUpdatedNotification object:nil];
        } else if (error) {
            GGPLogError(@"Error fetching heroes: %@", error.localizedDescription);
        }
        if (completion) {
            completion(error ? nil : response.result, error);
        }
    }];
}

#pragma mark Malls

- (void)fetchMinimalMallsWithCompletion:(void (^)(NSArray *malls, NSError *error))completion {
    [self GET:@"malls?minimalView&size=300" parameters:nil completion:^(OVCResponse *response, NSError *error) {
        if (error) {
            GGPLogError(@"Error fetching minimal malls: %@", error.localizedDescription);
        }
        if (completion) {
            completion(error ? nil : ((GGPMallResponse *)response.result).malls, error);
        }
    }];
}

- (void)fetchMallFromMallId:(NSInteger)mallId withCompletion:(void (^)(GGPMall *mall, NSError *error))fetchMallComplete {
    NSString *requestString = [NSString stringWithFormat:@"malls/%ld", (long)mallId];
    [self GET:requestString parameters:nil completion:^(OVCResponse *response, NSError *error) {
        if (!error && [self handleEtagForResponse:response.HTTPResponse]) {
            [GGPMallManager shared].selectedMall = response.result;
        } else if (error) {
            GGPLogError(@"Error fetching mall: %@", error.localizedDescription);
        }
        if (fetchMallComplete) {
            fetchMallComplete(error ? nil : response.result, error);
        }
    }];
}

- (void)fetchMallsFromLatitude:(double)latitude andLongitude:(double)longitude withCompletion:(void (^)(NSArray *malls, NSError *error))fetchMallsComplete {
    NSString *requestString = @"malls/search/searchByLatLong/";
    NSDictionary *latlong = @{ @"lat": [NSString stringWithFormat:@"%f", latitude],
                               @"long": [NSString stringWithFormat:@"%f", longitude] };
    [self GET:requestString parameters:latlong completion:^(OVCResponse *response, NSError *error) {
        if (fetchMallsComplete) {
            fetchMallsComplete(response.result,error);
        }
    }];
}

#pragma mark Movies

- (void)fetchMovieTheatersForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *theaters, NSError *error))fetchMoviesComplete {
    NSString *requestString = [NSString stringWithFormat:@"malls/%ld/movie-theaters", (long)mallId];
    [self GET:requestString parameters:nil completion:^(OVCResponse *response, NSError *error) {
        if (!error && [self handleEtagForResponse:response.HTTPResponse]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGPClientMovieTheatersUpdatedNotification object:nil];
        } else if (error) {
            GGPLogError(@"Error fetching movie theaters: %@", error.localizedDescription);
        }
        if (fetchMoviesComplete) {
            fetchMoviesComplete(error ? nil : response.result, error);
        }
    }];
}

#pragma mark Park Assist

- (void)fetchParkingSiteForMallId:(NSInteger)mallId withCompletion:(void (^)(GGPParkingSite *parkingSite))completion {
    NSString *requestString = [NSString stringWithFormat:@"malls/%ld/park-assist", (long)mallId];
    [self GET:requestString parameters:nil completion:^(OVCResponse *response, NSError *error) {
        if (!error && [self handleEtagForResponse:response.HTTPResponse]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGPClientParkAssistUpdatedNotification object:nil];
        } else if (error) {
            GGPLogError(@"Error fetching Park Assist site: %@", error.localizedDescription);
        }
        if (completion) {
            completion(error ? nil : response.result);
        }
    }];
}

#pragma mark Sales

- (void)fetchSalesForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *sales, NSError *error))completion {
    NSString *requestString = [NSString stringWithFormat:@"malls/%ld/sales", (long)mallId];
    [self GET:requestString parameters:@{ @"date": [[GGPClient sharedInstance] dateParamForRequest]} completion:^(OVCResponse *response, NSError *error) {
        if (!error && [self handleEtagForResponse:response.HTTPResponse]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGPClientSalesUpdatedNotification object:nil];
        } else if (error) {
            GGPLogError(@"Error fetching sales: %@", error.localizedDescription);
        }
        if (completion) {
            completion(error ? nil : response.result, error);
        }
    }];
}

#pragma mark Tenants

- (void)fetchTenantsForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *tenants, NSError *error))completion {
    NSString *requestString = [NSString stringWithFormat:@"malls/%ld/stores", (long)mallId];
    [self GET:requestString parameters:nil completion:^(OVCResponse *response, NSError *error) {
        if (!error && [self handleEtagForResponse:response.HTTPResponse]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GGPClientTenantsUpdatedNotification object:nil];
        } else if (error) {
            GGPLogError(@"Error fetching stores: %@", error.localizedDescription);
        }
        if (completion) {
            completion(error ? nil : response.result, error);
        }
    }];
}

#pragma mark Sweepstakes

- (void)fetchSweepstakeswithCompletion:(void (^)(NSArray *sweepstakes, NSError *error))completion {
    [self GET:@"config/sweepstakes" parameters:nil completion:^(OVCResponse *response, NSError *error) {
        if (error) {
            GGPLogError(@"Error fetching sweepstakes: %@", error.localizedDescription);
        }
        if (completion) {
            completion(error ? nil : response.result, error);
        }
    }];
}

@end
