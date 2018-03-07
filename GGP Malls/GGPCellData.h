//
//  GGPCellData.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGPCellData : NSObject

- (instancetype)initWithTitle:(NSString *)title andTapHandler:(void (^)())tapHandler;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle andTapHandler:(void (^)())tapHandler;

- (instancetype)initWithTitle:(NSString *)title activeImage:(UIImage *)activeImage inactiveImage:(UIImage *)inactiveImage andTapHandler:(void (^)())tapHandler;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle activeImage:(UIImage *)activeImage inactiveImage:(UIImage *)inactiveImage andTapHandler:(void (^)())tapHandler;

@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *subTitle;
@property (strong, nonatomic, readonly) UIImage *inactiveImage;
@property (strong, nonatomic, readonly) UIImage *activeImage;
@property (copy, nonatomic, readonly) void (^tapHandler)();

@end
