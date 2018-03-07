//
//  GGPQuickActions.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const GGPQuickActionTypeHome;
extern NSString *const GGPQuickActionTypeDirectory;
extern NSString *const GGPQuickActionTypeShopping;
extern NSString *const GGPQuickActionTypeParking;

@class UIApplicationShortcutItem;

@interface GGPQuickActions : NSObject

+ (void)configureQuickActions;

@end
