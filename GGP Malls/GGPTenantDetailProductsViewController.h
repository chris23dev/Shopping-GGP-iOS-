//
//  GGPTenantDetailProductsViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantDetailProductsDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPTenantDetailProductsViewController : UIViewController

@property id <GGPTenantDetailProductsDelegate> productsDelegate;
- (instancetype)initWithProducts:(NSArray *)products;

@end
