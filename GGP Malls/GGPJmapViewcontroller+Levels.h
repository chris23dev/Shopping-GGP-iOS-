//
//  GGPJmapViewcontroller+Levels.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewController.h"

@class JMapFloor;

@interface GGPJMapViewController (Levels)

@property (assign, nonatomic) BOOL showLevelButtons;

- (void)configureLevels;
- (void)reloadLevelSelectorData;
- (void)moveToFloor:(JMapFloor *)tenantFloor;
- (void)updateLevelWithSelectedFloor:(JMapFloor *)floor;
- (void)updateLevelSelectorForParking;
- (void)removeAllParkingFloor;

- (JMapFloor *)defaultFloorForTenant:(GGPTenant *)tenant;
- (NSArray *)floorsForTenant:(GGPTenant *)tenant;
- (NSString *)filterTextForFloor:(JMapFloor *)floor;

@end
