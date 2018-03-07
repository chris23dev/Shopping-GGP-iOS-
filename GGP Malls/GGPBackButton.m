//
//  GGPBackButton.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 4/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBackButton.h"

@interface GGPBackButton ()

@property (copy, nonatomic) void (^onTapHandler)();

@end

@implementation GGPBackButton

- (instancetype)initWithTapHandler:(void(^)())onTap {
    UIImage *backButtonImage = [UIImage imageNamed:@"ggp_back_button"];
    self.imageInsets = UIEdgeInsetsMake(0, -8, -3, 8);
    self = [super initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:nil action:@selector(onTap)];
    if (self) {
        self.onTapHandler = onTap;
    }
    return self;
}

- (void)onTap {
    if (self.onTapHandler) {
        self.onTapHandler();
    }
}

@end
