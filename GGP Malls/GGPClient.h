//
//  GGPClient.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/9/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Overcoat/OVCHTTPSessionManager.h>

@class GGPAppConfig;
@class GGPMall;
@class GGPParkingSite;

extern NSString *const GGPClientReachabilityChanged;

@interface GGPClient : OVCHTTPSessionManager

+ (GGPClient *)sharedInstance;
- (void)start;
- (void)authenticateWithCompletion:(void(^)(BOOL isAuthenticated))onCompletion;

/**
 *  Track etags for each response. NSURLCache hides the details of 304 responses and they always show up as 200s. Because of this, we will keep a lookup of requests/etags
 *
 *  @param response the response containing the request url and the etag
 *
 *  @return YES if a response etag exists and is different than the current etag. The current etag may or may not be nil. Otherwise, return NO.
 */
- (BOOL)handleEtagForResponse:(NSHTTPURLResponse *)response;

- (void)fetchAlertsForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *alerts, NSError *error))completion;

- (void)fetchAppConfigWithCompletion:(void (^)(GGPAppConfig *appConfig, NSError *error))completion;

- (void)fetchCategoriesWithCompletion:(void (^)(NSArray *categories, NSError *error))completion;

- (void)fetchCampaignsWithCompletion:(void (^)(NSArray *campaigns, NSError *error))completion;

- (void)fetchDateRangesForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *dateRanges, NSError *error))completion;

- (void)fetchEventsForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *events, NSError *error))completion;

- (void)fetchHeroesForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *heroes, NSError *error))completion;

- (void)fetchMinimalMallsWithCompletion:(void (^)(NSArray *malls, NSError *error))completion;

- (void)fetchMallFromMallId:(NSInteger)mallId withCompletion:(void (^)(GGPMall *mall, NSError *error))fetchMallComplete;

- (void)fetchMallsFromLatitude:(double)latitude andLongitude:(double)longitude withCompletion:(void (^)(NSArray *malls, NSError *error))fetchMallsComplete;

- (void)fetchMovieTheatersForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *theaters, NSError *error))fetchMoviesComplete;

- (void)fetchParkingSiteForMallId:(NSInteger)mallId withCompletion:(void (^)(GGPParkingSite *parkingSite))completion;

- (void)fetchSalesForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *sales, NSError *error))completion;

- (void)fetchTenantsForMallId:(NSInteger)mallId withCompletion:(void (^)(NSArray *tenants, NSError *error))completion;

- (void)fetchSweepstakeswithCompletion:(void (^)(NSArray *sweepstakes, NSError *error))completion;

@property (assign, nonatomic, readonly) BOOL isOffline;

@end
