//
//  UILabel+GGPAdditions.m
//  GGP Malls
//
//  Created by Janet Lin on 2/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "UILabel+GGPAdditions.h"

@implementation UILabel (GGPAdditions)

- (NSInteger)ggp_contentHeight {
    NSInteger originalNumberOfLines = self.numberOfLines;
    
    self.numberOfLines = 0;
    [self sizeToFit];
    NSInteger contentHeight = self.bounds.size.height;
    
    self.numberOfLines = originalNumberOfLines;
    return contentHeight;
}

- (NSInteger)ggp_lineCount {
    CGFloat charSize = self.font.lineHeight;
    return ceil([self ggp_contentHeight]/charSize);
}

@end
