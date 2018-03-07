//
//  GGPTenantDetailViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 2/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPTenant;

@interface GGPTenantDetailViewController : UIViewController

- (instancetype)initWithTenantDetails:(GGPTenant *)tenant;

@end
