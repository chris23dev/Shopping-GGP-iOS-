//
//  GGPFadedLabel.m
//  GGP Malls
//
//  Created by Janet Lin on 2/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFadedLabel.h"

static const CGFloat kFadeHeightMultiplier = 0.5;

@interface GGPFadedLabel ()
@property (strong, nonatomic) CAGradientLayer* descriptionGradientLayer;
@end

@implementation GGPFadedLabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    [self addGestureRecognizer:gestureRecognizer];
}

- (void)addWhiteFadeAtBottomYOffset:(NSInteger)bottomOffset {
    self.descriptionGradientLayer = [CAGradientLayer layer];
    CGFloat fadeHeight = bottomOffset*kFadeHeightMultiplier;
    self.descriptionGradientLayer.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + bottomOffset - fadeHeight, self.frame.size.width, fadeHeight);
    self.descriptionGradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0 alpha:0.0] CGColor], (id)[[UIColor whiteColor] CGColor]];
    [self.layer insertSublayer:self.descriptionGradientLayer atIndex:0];
}

-(void)labelTapped:(UITapGestureRecognizer *)recognizer {
    [self.descriptionGradientLayer removeFromSuperlayer];
    [self.labelDelegate fadedLabelTapped:self];
}

@end
