//
//  GGPAmenity.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAmenity.h"

@implementation GGPAmenity

- (instancetype)initWithName:(NSString *)name jmapType:(NSString *)type defaultImage:(UIImage *)defaultImage selectedImage:(UIImage *)selectedImage andMapImage:(UIImage *)mapImage {
    self = [super init];
    if (self) {
        self.name = name;
        self.jmapType = type;
        self.defaultImage = defaultImage;
        self.selectedImage = selectedImage;
        self.mapImage = mapImage;
    }
    return self;
}

@end
