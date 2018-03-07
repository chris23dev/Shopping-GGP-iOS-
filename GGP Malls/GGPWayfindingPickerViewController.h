//
//  GGPWayfindingPickerViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPWayfindingPickerDelegate.h"
#import <UIKit/UIKit.h>
@class GGPTenant;

@interface GGPWayfindingPickerViewController : UIViewController

- (instancetype)initWithTenant:(GGPTenant *)tenant;

@property (weak, nonatomic) id<GGPWayfindingPickerDelegate> wayfindingPickerDelegate;

@end
