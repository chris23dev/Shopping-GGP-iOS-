//
//  GGPAnalytics.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAnalytics.h"
#import "ADBMobile.h"
#import "GGPMallManager.h"
#import "GGPMall.h"
#import "GGPCrashReporting.h"
#import "GGPAccount.h"

static NSString *const kScreenName = @"screen.name";
static NSString *const kPreviousScreenName = @"screen.previous";
static NSString *const kMallName = @"mall.name";
static NSString *const kTenantName = @"tenant.name";

#ifdef PROD
    static NSString *const kConfigFilename = @"ADBMobileConfig";
#else
    static NSString *const kConfigFilename = @"ADBMobileConfigDev";
#endif

@interface GGPAnalytics()

@property (strong, nonatomic) NSString *previousScreen;

@end

@implementation GGPAnalytics

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static GGPAnalytics *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [GGPAnalytics new];
    });
    return instance;
}

+ (void)start {
    [self setupConfigurationPath];
    [ADBMobile collectLifecycleData];
}

+ (void)setupConfigurationPath {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:kConfigFilename ofType:@"json"];
    [ADBMobile overrideConfigPath:filePath];
}

#pragma mark Track Screen

- (void)trackScreen:(NSString *)screen {
    [self trackScreen:screen withTenant:nil];
}

- (void)trackScreen:(NSString *)screen withTenant:(NSString *)tenant {
    NSMutableDictionary *contextData = [NSMutableDictionary dictionary];
    
    [contextData setObject:screen forKey:kScreenName];
    [self safeSetValue:tenant forKey:kTenantName toDictionary:contextData];
    [self safeSetValue:[GGPMallManager shared].selectedMall.name forKey:kMallName toDictionary:contextData];
    [self safeSetValue:self.previousScreen forKey:kPreviousScreenName toDictionary:contextData];
    
    [self addAuthStatusAndUserIdToContextData:contextData];
    
    [self setLowercaseValuesForContextData:contextData];
    [ADBMobile trackState:screen data:contextData];
    
    self.previousScreen = screen;
    
    [[GGPCrashReporting shared] trackTenant:tenant];
}

#pragma mark Track Action

- (void)trackAction:(NSString *)action withData:(NSDictionary *)data {
    [self trackAction:action withData:data andTenant:nil];
}

- (void)trackAction:(NSString *)action withData:(NSDictionary *)data andTenant:(NSString *)tenant {
    NSMutableDictionary *contextData = data ? [data mutableCopy] : [NSMutableDictionary dictionary];
    
    [self safeSetValue:self.previousScreen forKey:kScreenName toDictionary:contextData];
    [self safeSetValue:tenant forKey:kTenantName toDictionary:contextData];
    [self safeSetValue:[GGPMallManager shared].selectedMall.name forKey:kMallName toDictionary:contextData];
    
    [self addAuthStatusAndUserIdToContextData:contextData];
    
    [self setLowercaseValuesForContextData:contextData];
    [ADBMobile trackAction:action data:contextData];
}

#pragma mark Helper methods

- (void)safeSetValue:(NSString *)value forKey:(NSString *)key toDictionary:(NSMutableDictionary *)dictionary {
    if (value.length > 0) {
        [dictionary setObject:value forKey:key];
    }
}

- (void)setLowercaseValuesForContextData:(NSMutableDictionary *)contextData {
    for (NSString *key in contextData.allKeys) {
        if ([contextData[key] isKindOfClass:[NSString class]]) {
            contextData[key] = [contextData[key] lowercaseString];
        }
    }
}

- (void)addAuthStatusAndUserIdToContextData:(NSMutableDictionary *)contextData {
    NSString *authStatus = [GGPAccount isLoggedIn] ? GGPAnalyticsContextDataAuthStatusTypeAuthenticated : GGPAnalyticsContextDataAuthStatusTypeNotAuthenticated;
    [self safeSetValue:authStatus forKey:GGPAnalyticsContextDataAccountAuthStatus toDictionary:contextData];
    
    NSString *userId = [GGPAccount retrieveUserId];
    if (!userId) {
        userId = GGPAnalyticsContextDataUserIdTypeGuest;
    }
    [self safeSetValue:userId forKey:GGPAnalyticsContextDataAccountUserId toDictionary:contextData];
}

+ (NSString *)socialNetworkForActivityType:(NSString *)activityType {
    if (activityType == UIActivityTypePostToTwitter) {
        return GGPAnalyticsContextDataSocialNetworkTypeTwitter;
    } else if (activityType == UIActivityTypePostToFacebook) {
        return GGPAnalyticsContextDataSocialNetworkTypeFacebook;
    } else if (activityType == UIActivityTypeMail) {
        return GGPAnalyticsContextDataSocialNetworkTypeEmail;
    } else if (activityType == UIActivityTypeMessage) {
        return GGPAnalyticsContextDataSocialNetworkTypeText;
    } else {
        return nil;
    }
}

@end
