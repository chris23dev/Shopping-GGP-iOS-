//
//  GGPJMapManager.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPMallManager.h"

@interface GGPJMapManager ()

@property (strong, nonatomic) UIView *loadingView;

@end

@implementation GGPJMapManager

+ (GGPJMapManager *)shared {
    static GGPJMapManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [GGPJMapManager new];
        instance.mapViewController = [GGPJMapViewController new];
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(loadMapData) name:GGPMallManagerMallChangedNotification object:nil];
    });
    
    return instance;
}

- (BOOL)wayfindingAvailableForTenant:(GGPTenant *)tenant {
    return !tenant.temporarilyClosed &&
        [GGPMallManager shared].selectedMall.hasWayFinding &&
        [self mapDestinationAvailableForTenant:tenant];
}

- (BOOL)mapDestinationAvailableForTenant:(GGPTenant *)tenant {
    return [self.mapViewController retrieveDestinationFromLeaseId:tenant.leaseId] != nil;
}

- (void)loadMapData {
    [self.mapViewController loadMapData];
}

@end
