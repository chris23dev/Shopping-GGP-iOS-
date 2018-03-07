//
//  GGPLog.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPLog.h"

@implementation GGPLog

+ (void)configureLoggers {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

@end
