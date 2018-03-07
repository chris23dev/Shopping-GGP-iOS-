//
//  GGPAmenity.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGPAmenity : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *jmapType;
@property (strong, nonatomic) UIImage *mapImage;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImage *defaultImage;

- (instancetype)initWithName:(NSString *)name jmapType:(NSString *)type defaultImage:(UIImage *)defaultImage selectedImage:(UIImage *)selectedImage andMapImage:(UIImage *)mapImage;

@end
