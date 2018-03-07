//
//  NSArray+GGPAdditions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (GGPAdditions)

- (NSArray *)ggp_sortListAscendingForKey:(NSString *)sortKey;
- (NSArray *)ggp_sortListDescendingForKey:(NSString *)sortKey;
- (NSArray *)ggp_sortListForKey:(NSString *)sortKey ascending:(BOOL)ascending;
- (NSArray *)ggp_sortListForPrimarySortKey:(NSString *)primarySortKey primaryAscending:(BOOL)primaryAscending secondarySortkey:(NSString *)secondarySortKey secondaryAscending:(BOOL)secondaryAscending;
- (NSArray *)ggp_removeDuplicates;
- (NSArray *)ggp_arrayWithFilter:(BOOL(^)(id object))filter;
- (BOOL)ggp_anyWithFilter:(BOOL(^)(id object))filter;
- (id)ggp_firstWithFilter:(BOOL(^)(id object))filter;
- (NSArray *)ggp_arrayWithMap:(id(^)(id evaluatedObject))map;

@end
