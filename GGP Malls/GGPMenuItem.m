//
//  GGPMenuItem.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMenuItem.h"

@implementation GGPMenuItem

- (instancetype)initWithTitle:(NSString *)title andTapHandler:(void (^)())tapHandler {
    return [self initWithTitle:title icon:nil andTapHandler:tapHandler];
}

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon andTapHandler:(void (^)())tapHandler {
    self = [super init];
    if (self) {
        self.title = title;
        self.icon = icon;
        self.tapHandler = tapHandler;
    }
    return self;
}

@end
