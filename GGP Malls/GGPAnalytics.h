//
//  GGPAnalytics.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPAnalyticsConstants.h"

@interface GGPAnalytics : NSObject

+ (instancetype)shared;
+ (void)start;

- (void)trackScreen:(NSString *)screen;
- (void)trackScreen:(NSString *)screen withTenant:(NSString *)tenant;

- (void)trackAction:(NSString *)action withData:(NSDictionary *)data;
- (void)trackAction:(NSString *)action withData:(NSDictionary *)data andTenant:(NSString *)tenant;

+ (NSString *)socialNetworkForActivityType:(NSString *)activityType;

@end
