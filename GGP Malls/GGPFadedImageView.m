//
//  GGPFadedImageView.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFadedImageView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImage+GGPAdditions.h"
#import "UIView+GGPAdditions.h"

static CGFloat const kGradientHeight = 100;

@interface GGPFadedImageView ()

@property (strong, nonatomic) CAGradientLayer *imageGradientLayer;
@property (strong, nonatomic) UIImage *fullSizeImage;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;
@property (assign, nonatomic) BOOL layoutSubviewsCalled;

@end

@implementation GGPFadedImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    [self addGestureRecognizer:gestureRecognizer];
    self.contentMode = UIViewContentModeTop;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layoutSubviewsCalled = YES;
    
    if (!self.fullSizeImage && self.originalImage) {
        [self adjustImageSize];
    }
}

- (void)configureWithImageUrl:(NSURL *)url {
    [self configureWithImageUrl:url andOnFailure:nil];
}

- (void)configureWithImageUrl:(NSURL *)url andOnFailure:(void (^)())onFailure {
    __weak typeof(self) weakSelf = self;
    [self setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        weakSelf.originalImage = image;
        if (weakSelf.layoutSubviewsCalled) {
            [weakSelf adjustImageSize];
        }

    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        if (onFailure) {
            onFailure();
        }
    }];
}

- (BOOL)shouldShowGradientForImage:(UIImage *)image {
    return image.size.height > self.frame.size.height;
}

- (void)imageTapped {
    if (self.imageGradientLayer) {
        [self.imageGradientLayer removeFromSuperlayer];
        self.imageGradientLayer = nil;
    
        [UIView animateWithDuration:0.3 animations:^{
            self.heightConstraint.constant = self.fullSizeImage.size.height;
            [self.superview layoutIfNeeded];
        }];
    }
}

- (void)adjustImageSize {
    BOOL hasZeroSize = self.originalImage.size.width == 0 || self.originalImage.size.height == 0;
    CGFloat imageRatio = hasZeroSize ? 0 : self.originalImage.size.width / self.originalImage.size.height;
    CGFloat fullHeight = imageRatio == 0 ? 0 : self.frame.size.width / imageRatio;
    
    self.fullSizeImage = [UIImage ggp_imageWithImage:self.originalImage scaledToSize:CGSizeMake(self.frame.size.width, fullHeight)];
    self.image = self.fullSizeImage;
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.frame.size.height];
    [self addConstraint:self.heightConstraint];
    
    if ([self shouldShowGradientForImage:self.fullSizeImage]) {
        self.imageGradientLayer = [self ggp_addBottomGradientWithHeight:kGradientHeight andColor:[UIColor whiteColor]];
    } else {
        self.heightConstraint.constant = self.fullSizeImage.size.height;
    }
}

@end
