//
//  GGPFilterTableCellData.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFilterTableCellData.h"

@interface GGPFilterTableCellData ()

@property (strong, nonatomic) id<GGPFilterItem> filterItem;
@property (assign, nonatomic) BOOL hasChildItems;

@end

@implementation GGPFilterTableCellData

- (instancetype)initWithTitle:(NSString *)title hasChildItems:(BOOL)hasChildItems filterItem:(id<GGPFilterItem>)filterItem andTapHandler:(void (^)())tapHandler {
    self = [super initWithTitle:title andTapHandler:tapHandler];
    if (self) {
        self.filterItem = filterItem;
        self.hasChildItems = hasChildItems;
    }
    return self;
}

@end
