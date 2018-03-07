//
//  GGPVersionController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 5/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAppConfig.h"
#import "GGPClient.h"
#import "GGPVersionController.h"

static NSString *const kAppVersionKey = @"CFBundleShortVersionString";
static NSString *const kPreviousAppLaunchVersionKey = @"GGPPreviousAppLaunchVersionKey";

@implementation GGPVersionController

+ (void)checkAppVersionWithCompletion:(void(^)(BOOL requiresUpdate))completion {
    [[GGPClient sharedInstance] fetchAppConfigWithCompletion:^(GGPAppConfig *appConfig, NSError *error) {
        BOOL requiresUpdate = !error && [self isAppUpdateRequiredForMinVersion:appConfig.minIosVersion];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(requiresUpdate);
        });
    }];
}

+ (BOOL)isAppUpdateRequiredForMinVersion:(NSString *)minVersion {
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:kAppVersionKey];
    return [minVersion compare:appVersion options:NSNumericSearch] == NSOrderedDescending;
}

+ (BOOL)hasUpdatedSincePreviousLaunch {
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:kAppVersionKey];
    NSString *previousVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kPreviousAppLaunchVersionKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:kPreviousAppLaunchVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return previousVersion == nil || ![previousVersion isEqualToString:currentVersion];
}

@end
