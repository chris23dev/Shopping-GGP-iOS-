//
//  GGPFixedSpaceFlowLayout.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFixedSpaceFlowLayout.h"

@implementation GGPFixedSpaceFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat interItemSpacing = (rect.size.width - [self totalCellWidthForAttributes:attributes]) / (attributes.count + 1);
    
    for(int i = 0; i < attributes.count; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        NSInteger origin = 0;
        
        if (i != 0) {
            UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
            origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        }
        
        [self adjustFrameForAttributes:currentLayoutAttributes withOrigin:origin andSpacing:interItemSpacing];
    }
    
    return attributes;
}

- (CGFloat)totalCellWidthForAttributes:(NSArray *)attributes {
    CGFloat totalCellWidth = 0;
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        totalCellWidth += attribute.frame.size.width;
    }
    
    return totalCellWidth;
}

- (void)adjustFrameForAttributes:(UICollectionViewLayoutAttributes *)attributes withOrigin:(CGFloat)origin andSpacing:(CGFloat)spacing {
    CGRect frame = attributes.frame;
    frame.origin.x = origin + spacing;
    attributes.frame = frame;
}

@end
