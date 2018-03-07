//
//  GGPOverlayImageController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 5/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPOverlayImageController.h"
#import "GGPMallManager.h"

static CGFloat const kFadeOutDuration = 0.5;

@interface GGPOverlayImageController()

@property (strong, nonatomic) UIImageView *overlayImageView;

@end

@implementation GGPOverlayImageController

- (instancetype)initWithOverlayImageView:(UIImageView *)overlayImageView {
    self = [super init];
    if (self) {
        self.overlayImageView = overlayImageView;
    }
    return self;
}

- (void)hideOverlayImage {
    [UIView animateWithDuration:kFadeOutDuration animations:^{
        self.overlayImageView.alpha = 0;
    } completion:^(BOOL finished) {
        self.overlayImageView.hidden = YES;
    }];
}

- (void)displayLaunchOverlayImage {
    [self displayOverlayImage:[UIImage imageNamed:@"ggp_onboarding_background"]];
}

- (void)displayLoadingOverlayImage {
    [self displayOverlayImage:[GGPMallManager shared].selectedMall.loadingImage];
}

- (void)displayOverlayImage:(UIImage *)image {
    self.overlayImageView.alpha = 1;
    self.overlayImageView.image = image;
    self.overlayImageView.hidden = NO;
}

@end
