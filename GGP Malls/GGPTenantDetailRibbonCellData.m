//
//  GGPTenantDetailRibbonCellData.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantDetailRibbonCellData.h"

@interface GGPTenantDetailRibbonCellData ()

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) void (^tapHandler)();

@end

@implementation GGPTenantDetailRibbonCellData

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image andTapHandler:(void (^)())tapHandler {
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tapHandler = tapHandler;
    }
    return self;
}

@end
