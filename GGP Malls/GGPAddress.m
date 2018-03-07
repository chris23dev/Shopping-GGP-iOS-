//
//  GGPAddress.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/9/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPAddress.h"

@implementation GGPAddress

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"line1": @"line1",
             @"line2": @"line2",
             @"line3": @"line3",
             @"city": @"city",
             @"state": @"state",
             @"zip": @"zip"
             };
}


- (NSString *)fullAddress {
    return [NSString stringWithFormat:@"%@\n%@,\u00a0%@\u00a0%@", [self formattedAddressLines], self.city, self.state, self.zip];
}

- (NSString *)formattedAddressLines {
    NSString *lines = self.line1;
    
    if (self.line2) {
        lines = [lines stringByAppendingString:[NSString stringWithFormat:@" %@", self.line2]];
    }
    
    if (self.line3) {
        lines = [lines stringByAppendingString:[NSString stringWithFormat:@" %@", self.line3]];
    }
    
    return lines;
}

@end
