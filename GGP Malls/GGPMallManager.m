//
//  GGPMallManager.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 7/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCrashReporting.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPNotificationConstants.h"
#import "GGPURLCache.h"

static NSString *const kRecentMallListKey = @"kRecentMallListKey";
static NSInteger const kMaxNumberOfRecentMalls = 5;

@implementation GGPMallManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static GGPMallManager *instance = nil;
    
    dispatch_once(&onceToken, ^{
        instance = [GGPMallManager new];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedMall = self.recentMalls.firstObject;
    }
    return self;
}

#pragma mark selectedMall property

- (void)setSelectedMall:(GGPMall *)selectedMall {
    if (selectedMall.isInactive) {
        [self handleInactiveMall:selectedMall];
        return;
    }
    
    self.recentMalls = [self recentMallsWithSelectedMall:selectedMall];
    
    BOOL isInitialMallSelection = _selectedMall == nil;
    NSInteger previousMallId = _selectedMall.mallId;
    _selectedMall = selectedMall;
    
    if (previousMallId != selectedMall.mallId) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GGPMallManagerMallChangedNotification object:nil userInfo:@{ GGPIsInitialMallSelectionUserInfoKey: @(isInitialMallSelection) }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:GGPMallManagerMallUpdatedNotification object:nil];
    }
}

#pragma mark recentMalls property

- (NSArray *)recentMalls {
    NSData *savedRecentMalls = [[NSUserDefaults standardUserDefaults] objectForKey:kRecentMallListKey];
    return savedRecentMalls ? [NSKeyedUnarchiver unarchiveObjectWithData:savedRecentMalls] : @[];
}

- (void)setRecentMalls:(NSArray *)recentMalls {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:recentMalls] forKey:kRecentMallListKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Helper methods

- (NSArray *)recentMallsWithSelectedMall:(GGPMall *)selectedMall {
    NSMutableArray *recentMalls = [self.recentMalls mutableCopy];
    
    [recentMalls removeObject:selectedMall];
    
    if (recentMalls.count == kMaxNumberOfRecentMalls) {
        [recentMalls removeLastObject];
    }
    
    if (selectedMall) {
        [recentMalls insertObject:selectedMall atIndex:0];
    }
    
    return recentMalls;
}

- (void)handleInactiveMall:(GGPMall *)inactiveMall {
    NSMutableArray *recentMalls = [self.recentMalls mutableCopy];
    [recentMalls removeObject:inactiveMall];
    self.recentMalls = recentMalls;
    
    // Set backing field to avoid running custom setter logic
    _selectedMall = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GGPMallManagerMallInactiveNotification object:nil];
}

@end
