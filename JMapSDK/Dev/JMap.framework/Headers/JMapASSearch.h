//
//  JMapASSearch.h
//  JMap
//
//  Created by Bryan Hayes on 2015-09-01.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

@class JMapASGrid;
@class JMapASNode;

@interface JMapASSearch : NSObject
{
    CFBinaryHeapRef openStartHeap;
}

@property NSString *TAG;
@property JMapASGrid *grid;

-(NSMutableArray *)search:(int)from to:(int)to accessLevel:(int)accessLevel;
//CFComparisonResult compare (const void *ptr1,const void *ptr2,void *info);

@end