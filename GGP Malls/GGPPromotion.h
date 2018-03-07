//
//  GGPPromotion.h
//  GGP Malls
//
//  Created by Janet Lin on 2/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "GGPTenant.h"

@interface GGPPromotion : MTLModel <MTLJSONSerializing>

// Mapped properties
@property (strong, nonatomic) GGPTenant *tenant;
@property (assign, nonatomic, readonly) NSInteger promotionId;
@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSDate *startDateTime;
@property (strong, nonatomic, readonly) NSDate *endDateTime;
@property (strong, nonatomic, readonly) NSURL *imageUrl;
@property (strong, nonatomic, readonly) NSString *location;

// Calculated properties
@property (strong, nonatomic, readonly) NSString *promotionDates;
@property (assign, nonatomic, readonly) BOOL isForFavorite;

- (void)trackSocialShareForNetwork:(NSString *)network;

@end
