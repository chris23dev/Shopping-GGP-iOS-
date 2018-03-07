//
//  GGPMallRepository.h
//  GGP Malls
//
//  Created by Janet Lin on 1/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGPMall;
@class GGPMovieTheater;
@class GGPParkingSite;
@class GGPSweepstakes;
@class GGPMallMovie;

@interface GGPMallRepository : NSObject

+ (void)fetchAlertsWithCompletion:(void (^)(NSArray *alerts))onComplete;
+ (void)fetchTenantCategoriesWithCompletion:(void(^)(NSArray *categories))onComplete;
+ (void)fetchSaleCategoriesWithCompletion:(void(^)(NSArray *categories))onComplete;
+ (void)fetchDateRangesWithCompletion:(void (^)(NSArray *dateRanges))onComplete;
+ (void)fetchEventsWithCompletion:(void(^)(NSArray *events))onComplete;
+ (void)fetchHeroesWithCompletion:(void (^)(NSArray *heroes))onComplete;
+ (void)fetchMallById:(NSInteger)mallId onComplete:(void (^)(GGPMall *mall))onComplete;
+ (void)fetchMinimalMallsWithCompletion:(void(^)(NSArray *malls))onComplete;
+ (void)fetchMovieTheatersWithCompletion:(void(^)(NSArray *movieTheaters))onComplete;
+ (void)fetchParkingSiteWithCompletion:(void(^)(GGPParkingSite *site))onComplete;
+ (void)fetchSalesWithCompletion:(void(^)(NSArray *sales))onComplete;
+ (void)fetchSalesWithTenants:(NSArray *)allTenants andCompletion:(void(^)(NSArray *sales))onComplete;
+ (void)fetchSalesForTenantId:(NSInteger)tenantId withCompletion:(void(^)(NSArray *sales))onComplete;
+ (void)fetchTenantsWithCompletion:(void(^)(NSArray *tenants))onComplete;
+ (void)fetchSweepstakesWithCompletion:(void (^)(GGPSweepstakes *sweepstakes))onComplete;
+ (void)fetchMallMoviesWithCompletion:(void (^)(NSArray *theaters, NSArray *mallMovies))onComplete;

@end
