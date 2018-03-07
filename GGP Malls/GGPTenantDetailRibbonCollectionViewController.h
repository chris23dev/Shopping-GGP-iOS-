//
//  GGPTenantDetailRibbonCollectionViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

@class GGPTenant;
#import <UIKit/UIKit.h>

@interface GGPTenantDetailRibbonCollectionViewController : UICollectionViewController

- (instancetype)initWithTenant:(GGPTenant *)tenant;

@end
