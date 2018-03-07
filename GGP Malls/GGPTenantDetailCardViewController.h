//
//  MapTenantDetailCardViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 2/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantDetailCardDelegate.h"
#import <UIKit/UIKit.h>
@class GGPTenant;

@interface GGPTenantDetailCardViewController : UIViewController

@property (weak, nonatomic) id<GGPTenantDetailCardDelegate> tenantDetailCardDelegate;

- (instancetype)initWithTenant:(GGPTenant *)tenant;
- (void)updateWithTenant:(GGPTenant *)tenant;
- (void)updateLayout;

@end
