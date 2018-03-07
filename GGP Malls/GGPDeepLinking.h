//
//  GGPDeepLinking.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 4/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPDeepLinking : NSObject

+ (void)startWithLaunchOptions:(NSDictionary *)launchOptions andAppController:(UIViewController *)controller;
+ (BOOL)handleDeepLinkUrl:(NSURL *)url;
+ (BOOL)continueUserActivity:(NSUserActivity *)userActivity;

@end
