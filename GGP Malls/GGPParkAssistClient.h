//
//  GGPParkAssistClient.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingSite.h"
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface GGPParkAssistClient : AFHTTPSessionManager

+ (instancetype)shared;

- (void)retrieveZonesForSite:(GGPParkingSite *)site andCompletion:(void(^)(NSArray *zones))completion;

- (void)retrieveCarLocationsForPlate:(NSString *)plate site:(GGPParkingSite *)site andCompletion:(void(^)(NSArray *carLocations))completion;

- (NSURL *)retrieveThumbnailURLForUUID:(NSString *)uuid andSite:(GGPParkingSite *)site;

- (NSURL *)retrieveMapURLForMapName:(NSString *)mapName andSite:(GGPParkingSite *)site;

@end
