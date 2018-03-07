//
//  GGPShoppingCategoryViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPShoppingCategoryDelegate.h"

@interface GGPShoppingCategoryViewController : UIViewController

@property (weak, nonatomic) id<GGPShoppingCategoryDelegate> categoryDelegate;

- (instancetype)initWithCategory:(GGPCategory *)category;
- (void)expandCategory;
- (void)collapseCategory;

@end
