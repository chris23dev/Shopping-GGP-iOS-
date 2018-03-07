//
//  GGPSale.h
//  GGP Malls
//
//  Created by Janet Lin on 1/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPPromotion.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GGPBrand;

@interface GGPSale : GGPPromotion <UIActivityItemSource>

// Mapped properties
@property (strong, nonatomic, readonly) NSString *type;
@property (strong, nonatomic, readonly) NSDate *displayDateTime;
@property (strong, nonatomic, readonly) NSString *saleDescription;
@property (strong, nonatomic, readonly) NSString *tenantName;
@property (strong, nonatomic, readonly) NSArray *categories;
@property (strong, nonatomic, readonly) NSArray *campaignCategories;
@property (strong, nonatomic, readonly) NSString *saleSortName;
@property (assign, nonatomic, readonly) BOOL isFeatured;
@property (assign, nonatomic, readonly) BOOL isTopRetailer;

+ (NSArray *)tenantsFromSales:(NSArray *)sales;

@end
