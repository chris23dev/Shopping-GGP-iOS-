//
//  NSProcessInfo+GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "NSProcessInfo+GGPAdditions.h"

@implementation NSProcessInfo (GGPAdditions)

+ (BOOL)ggp_isRunningUnitTests {
    return [self processInfo].environment[@"UNIT_TESTING"].boolValue;
}

@end
