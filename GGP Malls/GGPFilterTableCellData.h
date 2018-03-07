//
//  GGPFilterTableCellData.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCellData.h"
#import "GGPFilterItem.h"

@class GGPProduct;

@interface GGPFilterTableCellData : GGPCellData

@property (strong, nonatomic, readonly) id<GGPFilterItem> filterItem;
@property (assign, nonatomic, readonly) BOOL hasChildItems;

- (instancetype)initWithTitle:(NSString *)title hasChildItems:(BOOL)hasChildItems filterItem:(id<GGPFilterItem>)filterItem andTapHandler:(void (^)())tapHandler;

@end
