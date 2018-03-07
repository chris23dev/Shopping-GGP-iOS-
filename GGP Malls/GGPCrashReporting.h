//
//  GGPCrashReporting.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NewRelicAgent/NewRelic.h>

@interface GGPCrashReporting : NSObject

+ (instancetype)shared;
- (void)start;
- (void)trackTenant:(NSString *)tenant;

@end
