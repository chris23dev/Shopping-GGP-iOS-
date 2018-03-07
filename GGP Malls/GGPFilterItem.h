//
//  GGPFilterItem.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/23/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPFilterType.h"

@protocol GGPFilterItem <NSObject>

@property (assign, nonatomic) GGPFilterType type;
@property (strong, nonatomic) NSString *code;
@property (assign, nonatomic) NSInteger filterId;
@property (assign, nonatomic) NSInteger parentId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *filterText;

@property (strong, nonatomic) NSArray *childFilters;
@property (strong, nonatomic) NSArray *filteredItems;
@property (assign, nonatomic) NSInteger count;

@property (assign, nonatomic) BOOL isParentFilter;
@property (assign, nonatomic) BOOL isAllFilter;

@end
