//
//  GGPWayfindingToast.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPWayfindingToast.h"
#import "UIColor+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

static CGFloat const kFadeDuration = 0.5;
static CGFloat const kToastDuration = 2;

@interface GGPWayfindingToast ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *toastLabel;

@end

@implementation GGPWayfindingToast

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:@"GGPWayfindingToast" owner:self options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.backgroundColor  = [UIColor clearColor];
    self.containerView.backgroundColor = [UIColor ggp_colorFromHexString:@"000000" andAlpha:0.4];
    [self.containerView ggp_addBorderRadius:20];
    
    self.toastLabel.textColor = [UIColor whiteColor];
    self.toastLabel.font = [UIFont ggp_lightWithSize:30];
    self.toastLabel.backgroundColor = [UIColor clearColor];
    
    self.alpha = 0;
    self.hidden = YES;
}

- (void)showWithText:(NSString *)text {
    [self.layer removeAllAnimations];
    self.toastLabel.text = text;
    [self fadeIn];
}

- (void)fadeIn {
    self.hidden = NO;
    [UIView animateWithDuration:kFadeDuration animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [self fadeOut];
        }
    }];
}

- (void)fadeOut {
    [UIView animateWithDuration:kFadeDuration delay:kToastDuration options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}

@end
