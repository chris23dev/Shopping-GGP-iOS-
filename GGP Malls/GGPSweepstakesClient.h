//
//  GGPSweepstakesClient.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class GGPUser;

@interface GGPSweepstakesClient : AFHTTPSessionManager

+ (GGPSweepstakesClient *)sharedInstance;

- (void)postSweepstakesEntryForUser:(GGPUser *)user withCompletion:(void(^)(NSError *error))completion;

@end
