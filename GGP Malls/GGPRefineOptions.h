//
//  GGPRefineOptions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPRefineSortType.h"
#import <Foundation/Foundation.h>

@interface GGPRefineOptions : NSObject

@property (strong, nonatomic) NSArray *tenants;
@property (assign, nonatomic) BOOL includeFavorites;
@property (assign, nonatomic) GGPRefineSortType sortType;

+ (NSString *)sortStringFromSortType:(GGPRefineSortType)sortType;

@end
