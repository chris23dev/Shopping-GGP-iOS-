//
//  GGPMapPlaceMarker.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMapPlaceMarker.h"
#import "UIFont+GGPAdditions.h"

@implementation GGPMapPlaceMarker

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.font = [UIFont ggp_mediumWithSize:8];
        self.text = title;
        [self sizeToFit];
    }
    return self;
}

@end
