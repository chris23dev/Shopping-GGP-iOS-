//
//  GGPRefineOptions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenant.h"
#import "GGPRefineOptions.h"
#import "NSString+GGPAdditions.h"

@implementation GGPRefineOptions

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tenants = @[];
    }
    return self;
}

+ (NSString *)sortStringFromSortType:(GGPRefineSortType)sortType {
    switch (sortType) {
        case GGPRefineSortByEndDate:
            return [@"SHOPPING_REFINE_SORT_BY_ENDING_SOONEST" ggp_toLocalized];
            break;
        case GGPRefineSortByAlpha:
            return [@"SHOPPING_REFINE_SORT_BY_ALPHABETICAL" ggp_toLocalized];
            break;
        case GGPRefineSortByReverseAlpha:
            return [@"SHOPPING_REFINE_SORT_BY_REVERSE_ALPHABETICAL" ggp_toLocalized];
            break;
    }
}

@end
