//
//  GGPWayfindingPickerDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGPTenant;

@protocol GGPWayfindingPickerDelegate <NSObject>

- (void)didSelectFromTenant:(GGPTenant *)fromTenant andToTenant:(GGPTenant *)toTenant;
- (void)didUpdateLevelSelection;

@end
