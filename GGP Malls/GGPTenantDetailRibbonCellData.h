//
//  GGPTenantDetailRibbonCellData.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGPTenantDetailRibbonCellData : NSObject

@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readwrite) UIImage *image;
@property (strong, nonatomic, readonly) void (^tapHandler)();

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image andTapHandler:(void (^)())tapHandler;

@end
