//
//  GGPShoppingCategoryDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/7/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGPShoppingCategoryViewController;

@protocol GGPShoppingCategoryDelegate <NSObject>

- (void)didExpandCategoryViewController:(GGPShoppingCategoryViewController *)expandedViewController;

@end
