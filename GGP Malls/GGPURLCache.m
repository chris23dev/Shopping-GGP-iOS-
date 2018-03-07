//
//  GGPURLCache.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAlert.h"
#import "GGPClient.h"
#import "GGPEvent.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMovie.h"
#import "GGPMovieTheater.h"
#import "GGPSale.h"
#import "GGPTenantDetailViewController.h"
#import "GGPTenantTableCell.h"
#import "GGPURLCache.h"
#import "NSProcessInfo+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

static NSInteger const kMemoryCapacityMB = 10;
static NSInteger const kDiskCapacityMB = 100;

@implementation GGPURLCache

+ (instancetype)shared {
    static GGPURLCache *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[GGPURLCache alloc] initWithMemoryCapacity:1024 * 1024 * kMemoryCapacityMB
                                                  diskCapacity:1024 * 1024 * kDiskCapacityMB
                                                      diskPath:nil];
    });
    
    return instance;
}

- (void)cacheAppData {
    if ([NSProcessInfo ggp_isRunningUnitTests]) {
        return;
    }
    
    [[GGPClient sharedInstance] authenticateWithCompletion:^(BOOL isAuthenticated) {
        if (isAuthenticated) {
            [[GGPURLCache shared] cacheMallData];
        }
    }];

    [[GGPURLCache shared] cacheUserData];
}

- (void)cacheMallData {
    if ([GGPMallManager shared].selectedMall) {
        GGPLogDebug(@"Caching mall data for %@", [GGPMallManager shared].selectedMall.name);
        
        NSInteger mallId = [GGPMallManager shared].selectedMall.mallId;
                
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [[GGPClient sharedInstance] fetchMallFromMallId:mallId withCompletion:nil];
            [[GGPClient sharedInstance] fetchTenantsForMallId:mallId withCompletion:nil];
            [[GGPClient sharedInstance] fetchSalesForMallId:mallId withCompletion:nil];
            [[GGPClient sharedInstance] fetchEventsForMallId:mallId withCompletion:nil];
            [[GGPClient sharedInstance] fetchHeroesForMallId:mallId withCompletion:nil];
            [[GGPClient sharedInstance] fetchMovieTheatersForMallId:mallId withCompletion:nil];
            [[GGPClient sharedInstance] fetchAlertsForMallId:mallId withCompletion:nil];
        });
    }
}

- (void)cacheUserData {
    if ([GGPAccount isLoggedIn]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [GGPAccount fetchUserDataWithCompletion:nil];
        });
    }
}

@end
