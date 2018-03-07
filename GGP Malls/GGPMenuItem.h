//
//  GGPMenuItem.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGPMenuItem : NSObject

@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSString *title;
@property (nonatomic, copy) void (^tapHandler)();

- (instancetype)initWithTitle:(NSString *)title andTapHandler:(void (^)())tapHandler;
- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon andTapHandler:(void (^)())tapHandler;

@end
