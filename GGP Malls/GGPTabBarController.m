//
//  GGPTabBarController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAuthenticationController.h"
#import "GGPCategory.h"
#import "GGPDirectoryViewController.h"
#import "GGPHomeViewController.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController+Parking.h"
#import "GGPMallRepository.h"
#import "GGPMoreViewController.h"
#import "GGPNavigationController.h"
#import "GGPParkingReminder.h"
#import "GGPParkingViewController.h"
#import "GGPQuickActions.h"
#import "GGPShoppingViewController.h"
#import "GGPShoppingTableViewController.h"
#import "GGPTabBarController.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPTabBarController () <UITabBarControllerDelegate>

@property (strong, nonatomic) UINavigationController *homeNavController;
@property (strong, nonatomic) UINavigationController *shoppingNavController;
@property (strong, nonatomic) UINavigationController *directoryNavController;
@property (strong, nonatomic) UINavigationController *parkingNavController;
@property (strong, nonatomic) UINavigationController *moreNavController;

@property (strong, nonatomic) UITabBarItem *parkingUnsetTab;
@property (strong, nonatomic) UITabBarItem *parkingSetTab;
@property (assign, nonatomic) BOOL ignoreHeroCampaignNotification;

@end

@implementation GGPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self configureViewControllers];
    [self configureParkingTabs];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parkingReminderUpdated:) name:GGPParkingReminderUpdatedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayParking) name:GGPHeroParkingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayDirectory) name:GGPHeroDirectoryNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayShoppingList:) name:GGPHeroCampaignNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GGPParkingReminderUpdatedNotification object:nil];
}

- (void)dismissModalView {
    [((UINavigationController *)self.selectedViewController).topViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)handleMallChanged {
    [self reloadControllers];
}

- (BOOL)handleQuickActionType:(NSString *)type {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    BOOL handled = YES;
    
    if ([type isEqualToString:GGPQuickActionTypeHome]) {
        [self selectNavController:self.homeNavController];
    } else if ([type isEqualToString:GGPQuickActionTypeDirectory]) {
        [self selectNavController:self.directoryNavController];
    } else if ([type isEqualToString:GGPQuickActionTypeShopping]) {
        [self selectNavController:self.shoppingNavController];
    } else if ([type isEqualToString:GGPQuickActionTypeParking]) {
        [self selectNavController:self.parkingNavController];
    } else {
        handled = NO;
    }
    
    return handled;
}

- (void)displayParking {
    [self selectNavController:self.parkingNavController];
}

- (void)displayDirectory {
    [self selectNavController:self.directoryNavController];
}

- (void)displayShoppingList:(NSNotification *)notification {
    if (self.ignoreHeroCampaignNotification) {
        return;
    }
    self.ignoreHeroCampaignNotification = YES;
    NSString *campaignCode = notification.userInfo[GGPHeroCampaignCodeKey];
    [GGPMallRepository fetchSaleCategoriesWithCompletion:^(NSArray *categories) {
        GGPCategory *campaignCategory = [categories ggp_firstWithFilter:^BOOL(GGPCategory *category) {
            return [category.code isEqualToString:campaignCode];
        }];
        
        if (campaignCategory) {
            GGPShoppingTableViewController *shoppingTableViewController = [[GGPShoppingTableViewController alloc] initWithCategory:campaignCategory];
            [self.homeNavController pushViewController:shoppingTableViewController animated:YES];
        }
        self.ignoreHeroCampaignNotification = NO;
    }];
}

- (void)selectNavController:(UINavigationController *)navController {
    [self.homeNavController dismissViewControllerAnimated:NO completion:nil];
    [self.homeNavController popToRootViewControllerAnimated:NO];
    
    [self.directoryNavController popToRootViewControllerAnimated:NO];
    [self.directoryNavController dismissViewControllerAnimated:NO completion:nil];
    
    [self.shoppingNavController popToRootViewControllerAnimated:NO];
    [self.shoppingNavController dismissViewControllerAnimated:NO completion:nil];
    
    [self.parkingNavController popToRootViewControllerAnimated:NO];
    [self.parkingNavController dismissViewControllerAnimated:NO completion:nil];
    
    self.tabBar.hidden = NO;
    self.selectedViewController = navController;
}

- (void)reloadControllers {
    [self configureViewControllers];
    self.selectedViewController = self.homeNavController;
    self.tabBar.hidden = NO;
}

- (void)configureViewControllers {
    self.homeNavController = [self controllerForTabBarWithRootViewController:[GGPHomeViewController new] title:[@"TOOLBAR_HOME" ggp_toLocalized] image:[UIImage imageNamed:@"ggp_icon_nav_home"] selectedImage:[UIImage imageNamed:@"ggp_icon_nav_home_active"] andSelectedColor:[UIColor ggp_homeTab]];
    
    self.directoryNavController = [self controllerForTabBarWithRootViewController:[GGPDirectoryViewController new] title:[@"TOOLBAR_DIRECTORY" ggp_toLocalized] image:[UIImage imageNamed:@"ggp_icon_nav_directory"] selectedImage:[UIImage imageNamed:@"ggp_icon_nav_directory_active"] andSelectedColor:[UIColor ggp_directoryTab]];
    
    self.shoppingNavController = [self controllerForTabBarWithRootViewController:[GGPShoppingViewController new] title:[@"TOOLBAR_SHOPPING" ggp_toLocalized] image:[UIImage imageNamed:@"ggp_icon_nav_shopping"] selectedImage:[UIImage imageNamed:@"ggp_icon_nav_shopping_active"] andSelectedColor:[UIColor ggp_shoppingTab]];
    
    self.parkingNavController = [self controllerForTabBarWithRootViewController:[GGPParkingViewController new] title:[@"TOOLBAR_PARKING" ggp_toLocalized] image:[UIImage imageNamed:@"ggp_icon_nav_parking_unset"] selectedImage:[UIImage imageNamed:@"ggp_icon_nav_parking_unset_active"] andSelectedColor:[UIColor ggp_parkingTab]];
    
    self.moreNavController = [self controllerForTabBarWithRootViewController:[GGPMoreViewController new] title:[@"TOOLBAR_MORE" ggp_toLocalized] image:[UIImage imageNamed:@"ggp_icon_nav_more"] selectedImage:[UIImage imageNamed:@"ggp_icon_nav_more_active"] andSelectedColor:[UIColor ggp_moreTab]];
   
    self.viewControllers = @[ self.homeNavController,
                              self.directoryNavController,
                              self.shoppingNavController,
                              self.parkingNavController,
                              self.moreNavController, ];
    
    self.tabBar.translucent = NO;
}

- (GGPNavigationController *)controllerForTabBarWithRootViewController:(UIViewController *)rootViewController title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage andSelectedColor:(UIColor *)color {
    rootViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [rootViewController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : color} forState:UIControlStateSelected];
    return [[GGPNavigationController alloc] initWithRootViewController:rootViewController];
}

- (void)configureParkingTabs {
    self.parkingUnsetTab = [[UITabBarItem alloc] initWithTitle:[@"TOOLBAR_PARKING" ggp_toLocalized] image:[[UIImage imageNamed:@"ggp_icon_nav_parking_unset"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ggp_icon_nav_parking_unset_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.parkingSetTab = [[UITabBarItem alloc] initWithTitle:[@"TOOLBAR_PARKING" ggp_toLocalized] image:[[UIImage imageNamed:@"ggp_icon_nav_parking_set"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ggp_icon_nav_parking_set_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.parkingUnsetTab setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor ggp_parkingTab]} forState:UIControlStateSelected];
    [self.parkingSetTab setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor ggp_parkingTab]} forState:UIControlStateSelected];
    
    self.parkingNavController.tabBarItem = [self hasSavedParkingReminder] ? self.parkingSetTab : self.parkingUnsetTab;
}

- (void)parkingReminderUpdated:(NSNotification *)notification {
    BOOL hasSavedReminder = [notification.userInfo[GGPParkingReminderNotificationHasSavedReminderKey] boolValue];
    self.parkingNavController.tabBarItem = hasSavedReminder ? self.parkingSetTab : self.parkingUnsetTab;
}

- (BOOL)hasSavedParkingReminder {
    GGPParkingReminder *reminder = [GGPParkingReminder retrieveSavedReminder];
    return reminder && reminder.isValid;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (self.selectedViewController != self.parkingNavController) {
        [[GGPJMapManager shared].mapViewController hideParkingLayer];
    }
}

@end
