//
//  GGPNowOpenViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPPresenterDelegate.h"

@interface GGPNowOpenViewController : UIViewController

- (instancetype)initWithTenants:(NSArray *)tenants;

@property (weak, nonatomic) id<GGPPresenterDelegate> presenterDelegate;

@end
