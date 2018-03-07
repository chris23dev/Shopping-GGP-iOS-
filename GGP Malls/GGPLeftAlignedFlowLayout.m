//
//  GGPLeftAlignedFlowLayout.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPLeftAlignedFlowLayout.h"

@interface GGPLeftAlignedFlowLayout ()

@property (assign, nonatomic) NSInteger maxInteritemSpacing;

@end

@implementation GGPLeftAlignedFlowLayout

- (instancetype)initWithMaximumInteritemSpacing:(NSInteger)maxInteritemSpacing {
    self = [super init];
    if (self) {
        self.maxInteritemSpacing = maxInteritemSpacing;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    for(int i = 1; i < attributes.count; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        if([self cellFitsOnCurrentLineWithOrigin:origin andAttributes:currentLayoutAttributes]) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + self.maxInteritemSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return attributes;
}

- (BOOL)cellFitsOnCurrentLineWithOrigin:(NSInteger)origin andAttributes:(UICollectionViewLayoutAttributes *)attributes {
    return origin + self.maxInteritemSpacing + attributes.frame.size.width < self.collectionViewContentSize.width;
}

@end
