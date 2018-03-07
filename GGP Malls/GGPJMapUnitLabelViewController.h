//
//  GGPJMapUnitLabelViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPJMapUnitLabelViewController : UIViewController

@property (assign, nonatomic) BOOL shouldShow;

- (instancetype)initWithUnitName:(NSString *)unitName;
- (void)contentScaleFactorChanged:(NSNumber *)newScale;

@end
