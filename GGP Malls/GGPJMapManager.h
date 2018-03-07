//
//  GGPJMapManager.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGPJMapViewController.h"

@interface GGPJMapManager : NSObject

@property (strong, nonatomic) GGPJMapViewController *mapViewController;

+ (GGPJMapManager *)shared;
- (BOOL)wayfindingAvailableForTenant:(GGPTenant *)tenant;
- (BOOL)mapDestinationAvailableForTenant:(GGPTenant *)tenant;
- (void)loadMapData;

@end
