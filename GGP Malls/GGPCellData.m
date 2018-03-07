//
//  GGPCellData.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCellData.h"

@interface GGPCellData ()

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) UIImage *inactiveImage;
@property (strong, nonatomic) UIImage *activeImage;
@property (copy, nonatomic) void (^tapHandler)();

@end

@implementation GGPCellData

- (instancetype)initWithTitle:(NSString *)title andTapHandler:(void (^)())tapHandler {
    return [self initWithTitle:title subTitle:nil activeImage:nil inactiveImage:nil andTapHandler:tapHandler];
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle andTapHandler:(void (^)())tapHandler {
    return [self initWithTitle:title subTitle:subTitle activeImage:nil inactiveImage:nil andTapHandler:tapHandler];
}

- (instancetype)initWithTitle:(NSString *)title activeImage:(UIImage *)activeImage inactiveImage:(UIImage *)inactiveImage andTapHandler:(void (^)())tapHandler {
    return [self initWithTitle:title subTitle:nil activeImage:activeImage inactiveImage:inactiveImage andTapHandler:tapHandler];
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle activeImage:(UIImage *)activeImage inactiveImage:(UIImage *)inactiveImage andTapHandler:(void (^)())tapHandler {
    self = [super init];
    if (self) {
        self.title = title;
        self.subTitle = subTitle;
        self.inactiveImage = inactiveImage;
        self.activeImage = activeImage;
        self.tapHandler = tapHandler;
    }
    return self;
}

@end
