//
//  GGPButton.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPButton.h"

@implementation GGPButton

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.frame.size.width, self.titleLabel.frame.size.height);
}

@end
