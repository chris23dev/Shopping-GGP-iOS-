//
//  AppDelegate.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 12/7/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "AppDelegate.h"
#import "GGPAccount.h"
#import "GGPAppContainerViewController.h"
#import "GGPAttribution.h"
#import "GGPClient.h"
#import "GGPDeepLinking.h"
#import "GGPFeedbackManager.h"
#import "GGPJMapManager.h"
#import "GGPMallManager.h"
#import "GGPMapController.h"
#import "GGPQuickActions.h"
#import "GGPURLCache.h"
#import "GGPVersionController.h"
#import "NSProcessInfo+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "GGPOnboardingNavigationController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@property (strong, nonatomic) GGPAppContainerViewController *appController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[GGPClient sharedInstance] start];
    self.appController = [GGPAppContainerViewController new];
    [self configureApplication:application andLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.appController;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureQuickActions) name:GGPMallManagerMallChangedNotification object:nil];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [GGPAccount applicationDidBecomeActive];
    [self.appController appDidBecomeActive];
    [self configureQuickActions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = [GGPDeepLinking handleDeepLinkUrl:url];
    
    if (!handled) {
        handled = [GGPAccount application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return handled;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    return [GGPDeepLinking continueUserActivity:userActivity];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    completionHandler([self.appController handleQuickActionType:shortcutItem.type]);
}

- (void)configureApplication:(UIApplication *)application andLaunchOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class]]];
    [GGPAccount initWithApplication:application andLaunchOptions:launchOptions];
    [GGPLog configureLoggers];
    [GGPAnalytics start];
    [[GGPAttribution shared] start];
    [GGPDeepLinking startWithLaunchOptions:launchOptions andAppController:self.appController];
    [GGPMapController initializeApiKey];
    
    [self configureAppearance];
    [self configureUrlCache];
    [self configureJMap];
    [self configureCrashReporting];
    [self configureFeedbackManager];
}

- (void)configureAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor ggp_navigationBar]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                           NSFontAttributeName:[UIFont ggp_boldWithSize:15]}];
    
    [[UITabBar appearance] setBarTintColor:[UIColor ggp_extraLightGray]];
    [[UIActivityIndicatorView appearance] setColor:[UIColor blackColor]];
    
    [[UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[GGPOnboardingNavigationController.class]] setColor:[UIColor whiteColor]];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[UISearchBar.class]] setTitleTextAttributes:@{ NSFontAttributeName: [UIFont ggp_regularWithSize:14] } forState:UIControlStateNormal];
}

- (void)configureUrlCache {
    [NSURLCache setSharedURLCache:[GGPURLCache shared]];
}

- (void)configureJMap {
    [[GGPJMapManager shared] loadMapData];
}

- (void)configureCrashReporting {
    if (![NSProcessInfo ggp_isRunningUnitTests]) {
        [[GGPCrashReporting shared] start];
    }
}

- (void)configureFeedbackManager {
    [GGPFeedbackManager configureWithPresenter:self.appController];
    
    if ([GGPVersionController hasUpdatedSincePreviousLaunch]) {
        [GGPFeedbackManager resetActionCount];
    }
}

- (void)configureQuickActions {
    [GGPQuickActions configureQuickActions];
}

@end

