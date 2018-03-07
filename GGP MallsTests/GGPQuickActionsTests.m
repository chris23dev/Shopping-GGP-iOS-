//
//  GGPQuickActionsTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPQuickActions.h"

@interface GGPQuickActions (Testing)
+ (UIApplicationShortcutItem *)shortcutItemWithType:(NSString *)type;
@end

@interface GGPQuickActionsTests : XCTestCase

@end

@implementation GGPQuickActionsTests

- (void)testShortcutItemWithType {
    UIApplicationShortcutItem *homeItem = [GGPQuickActions shortcutItemWithType:GGPQuickActionTypeHome];
    UIApplicationShortcutItem *directoryItem = [GGPQuickActions shortcutItemWithType:GGPQuickActionTypeDirectory];
    UIApplicationShortcutItem *shoppingItem = [GGPQuickActions shortcutItemWithType:GGPQuickActionTypeShopping];
    UIApplicationShortcutItem *parkingItem = [GGPQuickActions shortcutItemWithType:GGPQuickActionTypeParking];
    UIApplicationShortcutItem *invalidItem = [GGPQuickActions shortcutItemWithType:@"invalid"];
    
    UIApplicationShortcutIcon *expectedHomeIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"ggp_icon_nav_home"];
    UIApplicationShortcutIcon *expectedDirectoryIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"ggp_icon_nav_directory"];
    UIApplicationShortcutIcon *expectedShoppingIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"ggp_icon_nav_shopping"];
    UIApplicationShortcutIcon *expectedParkingIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"ggp_icon_nav_parking_unset"];
    
    XCTAssertEqualObjects(homeItem.type, @"GGPQuickActionTypeHome");
    XCTAssertEqualObjects(homeItem.localizedTitle, @"Home");
    XCTAssertEqualObjects(homeItem.icon, expectedHomeIcon);
    
    XCTAssertEqualObjects(directoryItem.type, @"GGPQuickActionTypeDirectory");
    XCTAssertEqualObjects(directoryItem.localizedTitle, @"Directory");
    XCTAssertEqualObjects(directoryItem.icon, expectedDirectoryIcon);
    
    XCTAssertEqualObjects(shoppingItem.type, @"GGPQuickActionTypeShopping");
    XCTAssertEqualObjects(shoppingItem.localizedTitle, @"Shopping");
    XCTAssertEqualObjects(shoppingItem.icon, expectedShoppingIcon);
    
    XCTAssertEqualObjects(parkingItem.type, @"GGPQuickActionTypeParking");
    XCTAssertEqualObjects(parkingItem.localizedTitle, @"Parking");
    XCTAssertEqualObjects(parkingItem.icon, expectedParkingIcon);
    
    XCTAssertEqualObjects(invalidItem.type, @"invalid");
    XCTAssertNil(invalidItem.localizedTitle);
    XCTAssertNil(invalidItem.icon);
}

@end
