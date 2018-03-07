//
//  GGPSweepstakesClient.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMallManager.h"
#import "GGPSweepstakesClient.h"
#import "GGPUser.h"
#import "GGPSystemConfiguartion.h"

#ifdef PROD
static NSString *const kBaseURL = @"https://ggp.promo.eprize.com/v1/mallappsweeps/";
#else
static NSString *const kBaseURL = @"https://ggp.review.eprize.com/v1/mallappsweeps/";
#endif

static NSString *const kProfileEndpoint = @"profiles";
static NSString *const kAuthorizationHeader = @"Authorization";
static NSString *const kContentTypeHeader = @"Content-Type";
static NSString *const kContentTypeJson = @"application/json";
static NSString *const kAcceptHeader = @"Accept";
static NSString *const kIPHeader = @"True-Client-IP";
static NSString *const kUsername = @"dustin-duclo";
static NSString *const kPassword = @"ggpsweeps";

@implementation GGPSweepstakesClient

+ (GGPSweepstakesClient *)sharedInstance {
    static GGPSweepstakesClient *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[GGPSweepstakesClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    
    return instance;
}

- (void)postSweepstakesEntryForUser:(GGPUser *)user withCompletion:(void(^)(NSError *error))completion {
    GGPMall *selectedMall = [GGPMallManager shared].selectedMall;
    
    if (![self isValidUser:user andMallName:selectedMall.name]) {
        return;
    }
    
    NSDictionary *params = [self paramsForUser:user andMall:selectedMall];
    
    [self POST:kProfileEndpoint parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (completion) {
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (BOOL)isValidUser:(GGPUser *)user andMallName:(NSString *)mallName {
    return user.firstName && user.lastName && user.email && mallName;
}

- (NSDictionary *)paramsForUser:(GGPUser *)user andMall:(GGPMall *)mall {
    GGPMall *selectedMall = [GGPMallManager shared].selectedMall;
    return @{ @"first_name": user.firstName,
              @"last_name": user.lastName,
              @"email": user.email,
              @"mall_name":  selectedMall.name };
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {
    NSMutableURLRequest *modifiedRequest = request.mutableCopy;
    
    [modifiedRequest addValue:kContentTypeJson forHTTPHeaderField:kContentTypeHeader];
    [modifiedRequest addValue:kContentTypeJson forHTTPHeaderField:kAcceptHeader];
    [modifiedRequest addValue:[GGPSystemConfiguartion ipAddress] forHTTPHeaderField:kIPHeader];
    
#ifndef PROD
    NSData *userData = [[NSString stringWithFormat:@"%@:%@", kUsername, kPassword] dataUsingEncoding:NSUTF8StringEncoding];
    [modifiedRequest addValue:[NSString stringWithFormat:@"Basic %@", [userData base64EncodedStringWithOptions:0]] forHTTPHeaderField:kAuthorizationHeader];
#endif
    
    return [super dataTaskWithRequest:modifiedRequest completionHandler:completionHandler];
}

@end
