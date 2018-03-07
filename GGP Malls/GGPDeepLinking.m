//
//  GGPDeepLinking.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 4/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPDeepLinking.h"
#import <Branch/Branch.h>
#import "GGPMallRepository.h"
#import "GGPMallManager.h"
#import "GGPAppContainerViewController.h"

static NSString *const kMallIdKey = @"mallId";

@implementation GGPDeepLinking

+ (void)startWithLaunchOptions:(NSDictionary *)launchOptions andAppController:(GGPAppContainerViewController *)appController {
    [[self branchInstance] accountForFacebookSDKPreventingAppLaunch];
    
    [[self branchInstance] initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        
        // Only deep link to a mall if the user has gone through onboarding
        BOOL handleDeepLinkedMall = [GGPMallManager shared].selectedMall &&
            [params.allKeys containsObject:kMallIdKey];
        
        if (handleDeepLinkedMall) {
            NSInteger mallId = [params[kMallIdKey] integerValue];
            if ([GGPMallManager shared].selectedMall.mallId != mallId) {
                [appController handleDeeplinkedMallId:mallId];
            }
        }
    }];
}

+ (BOOL)handleDeepLinkUrl:(NSURL *)url {
    return [[self branchInstance] handleDeepLink:url];
}

+ (BOOL)continueUserActivity:(NSUserActivity *)userActivity {
    return [[self branchInstance] continueUserActivity:userActivity];
}

+ (Branch *)branchInstance {
#ifdef PROD
    return [Branch getInstance];
#else
    return [Branch getTestInstance];
#endif
}

@end
