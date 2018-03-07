//
//  GGPAttribution.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 5/3/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAttribution.h"
#import <Kochava/TrackAndAd.h>

#ifdef PROD
    static NSString *const kKochavaId = @"koggp-malls----ios----prod5722373da8d22";
#else
    static NSString *const kKochavaId = @"koggp-malls----ios----dev5722368801c0d";
#endif

@interface GGPAttribution()

@property (strong, nonatomic) KochavaTracker *kochavaTracker;

@end

@implementation GGPAttribution

+ (instancetype)shared {
    static GGPAttribution *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [GGPAttribution new];
    });
    
    return instance;
}

- (void)start {
    NSDictionary *params = @{ @"kochavaAppId" : kKochavaId };
    
    self.kochavaTracker = [[KochavaTracker alloc] initKochavaWithParams:params];
}

@end
