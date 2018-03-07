//
//  GGPAppConfig.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/9/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPAppConfig.h"

@implementation GGPAppConfig

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"minIosVersion": @"minIosVersion",
              @"iosFeedbackActionCount": @"iosFeedbackActionCount" };
}

@end
