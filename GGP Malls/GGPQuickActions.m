//
//  GGPQuickActions.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPQuickActions.h"
#import "NSString+GGPAdditions.h"
#import "GGPMallManager.h"
#import <UIKit/UIKit.h>

NSString *const GGPQuickActionTypeHome = @"GGPQuickActionTypeHome";
NSString *const GGPQuickActionTypeDirectory = @"GGPQuickActionTypeDirectory";
NSString *const GGPQuickActionTypeShopping = @"GGPQuickActionTypeShopping";
NSString *const GGPQuickActionTypeParking = @"GGPQuickActionTypeParking";

@implementation GGPQuickActions

+ (void)configureQuickActions {
    if (![self deviceSupportsQuickActions]) {
        return;
    }
    
    NSArray *items;
    
    if ([GGPMallManager shared].selectedMall) {
        UIApplicationShortcutItem *home = [self shortcutItemWithType:GGPQuickActionTypeHome];
        UIApplicationShortcutItem *directory = [self shortcutItemWithType:GGPQuickActionTypeDirectory];
        UIApplicationShortcutItem *shopping = [self shortcutItemWithType:GGPQuickActionTypeShopping];
        UIApplicationShortcutItem *parking = [self shortcutItemWithType:GGPQuickActionTypeParking];
        
        if (home && directory && shopping && parking) {
            items = @[home, directory, shopping, parking];
        }
    }
    [UIApplication sharedApplication].shortcutItems = items;
}

+ (BOOL)deviceSupportsQuickActions {
    return UIApplicationShortcutItem.class != nil;
}

+ (UIApplicationShortcutItem *)shortcutItemWithType:(NSString *)type {
    UIApplicationShortcutIcon *icon = [self iconForType:type];
    NSString *title = [self titleForType:type];
    
    return [[UIApplicationShortcutItem alloc] initWithType:type localizedTitle:title localizedSubtitle:nil icon:icon userInfo:nil];
}

+ (UIApplicationShortcutIcon *)iconForType:(NSString *)type {
    NSString *iconName;
    
    if ([type isEqualToString:GGPQuickActionTypeHome]) {
        iconName = @"ggp_icon_nav_home";
    } else if ([type isEqualToString:GGPQuickActionTypeDirectory]) {
        iconName = @"ggp_icon_nav_directory";
    } else if ([type isEqualToString:GGPQuickActionTypeShopping]) {
        iconName = @"ggp_icon_nav_shopping";
    } else if ([type isEqualToString:GGPQuickActionTypeParking]) {
        iconName = @"ggp_icon_nav_parking_unset";
    }
    
    return iconName ? [UIApplicationShortcutIcon iconWithTemplateImageName:iconName] : nil;
}

+ (NSString *)titleForType:(NSString *)type {
    if ([type isEqualToString:GGPQuickActionTypeHome]) {
        return [@"TOOLBAR_HOME" ggp_toLocalized];
    } else if ([type isEqualToString:GGPQuickActionTypeDirectory]) {
        return [@"TOOLBAR_DIRECTORY" ggp_toLocalized];
    } else if ([type isEqualToString:GGPQuickActionTypeShopping]) {
        return [@"TOOLBAR_SHOPPING" ggp_toLocalized];
    } else if ([type isEqualToString:GGPQuickActionTypeParking]) {
        return [@"TOOLBAR_PARKING" ggp_toLocalized];
    }
    return nil;
}

@end
