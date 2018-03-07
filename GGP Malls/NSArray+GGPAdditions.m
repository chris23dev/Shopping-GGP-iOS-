//
//  NSArray+GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "NSArray+GGPAdditions.h"

@implementation NSArray (GGPAdditions)

- (NSArray *)ggp_sortListAscendingForKey:(NSString *)sortKey {
    return [self ggp_sortListForKey:sortKey ascending:YES];
}

- (NSArray *)ggp_sortListDescendingForKey:(NSString *)sortKey {
    return [self ggp_sortListForKey:sortKey ascending:NO];
}

- (NSArray *)ggp_sortListForKey:(NSString *)sortKey ascending:(BOOL)ascending {
    return [self ggp_sortListForPrimarySortKey:sortKey primaryAscending:ascending secondarySortkey:nil secondaryAscending:NO];
}

- (NSArray *)ggp_sortListForPrimarySortKey:(NSString *)primarySortKey primaryAscending:(BOOL)primaryAscending secondarySortkey:(NSString *)secondarySortKey secondaryAscending:(BOOL)secondaryAscending {
    NSMutableArray *descriptors = [NSMutableArray new];
    
    NSSortDescriptor *primaryDescriptor = [NSSortDescriptor sortDescriptorWithKey:primarySortKey ascending:primaryAscending];
    [descriptors addObject:primaryDescriptor];
    
    if (secondarySortKey) {
        NSSortDescriptor *secondarySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:secondarySortKey ascending:secondaryAscending];
        [descriptors addObject:secondarySortDescriptor];
    }
    
    return [self sortedArrayUsingDescriptors:descriptors];
}

- (NSArray *)ggp_removeDuplicates {
    return [[NSOrderedSet orderedSetWithArray:self] array];
}

- (NSArray *)ggp_arrayWithFilter:(BOOL(^)(id object))filter {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return filter ? filter(evaluatedObject) : YES;
    }];
    return [self filteredArrayUsingPredicate:predicate];
}

- (id)ggp_firstWithFilter:(BOOL(^)(id object))filter {
    return [self ggp_arrayWithFilter:filter].firstObject;
}

- (BOOL)ggp_anyWithFilter:(BOOL(^)(id object))filter {
    return [self ggp_arrayWithFilter:filter].count > 0;
}

- (NSArray *)ggp_arrayWithMap:(id(^)(id evaluatedObject))map {
    NSMutableArray *array = [NSMutableArray new];
    for (NSObject *object in self) {
        id mappedObject = map ? map(object) : nil;
        if (mappedObject) {
            [array addObject:mappedObject];
        }
    }
    return array;
}

@end
