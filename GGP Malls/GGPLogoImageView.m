//
//  GGPLogoImageView.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPLogoImageView.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIImage+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface GGPLogoImageView ()

@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation GGPLogoImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureNameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setImageWithURL:(NSURL *)url defaultName:(NSString *)defaultName {
    [self setImageWithURL:url defaultName:defaultName andFont:[UIFont ggp_regularWithSize:22]];
}

- (void)setImageWithURL:(NSURL *)url defaultName:(NSString *)defaultName andFont:(UIFont *)font {
    __weak typeof(self) weakSelf = self;
    [self setImageWithURL:url defaultName:defaultName font:font andCompletion:^(UIImage *image) {
        weakSelf.image = image;
        weakSelf.nameLabel.text = nil;
    }];
}

- (void)setImageWithURL:(NSURL *)url width:(CGFloat)width defaultName:(NSString *)defaultName andFont:(UIFont *)font {
    __weak typeof(self) weakSelf = self;
    [self setImageWithURL:url defaultName:defaultName font:font andCompletion:^(UIImage *image) {
        CGFloat imageRatio = image.size.width / image.size.height;
        CGFloat fullHeight = width / imageRatio;
        UIImage *resizedImage = [UIImage ggp_imageWithImage:image scaledToSize:CGSizeMake(width, fullHeight)];
        
        weakSelf.image = resizedImage;
        weakSelf.nameLabel.text = nil;
    }];
}

- (void)setImageWithURL:(NSURL *)url defaultName:(NSString *)defaultName font:(UIFont *)font andCompletion:(void (^)(UIImage *image))completion {
    self.image = nil;
    self.nameLabel.text = nil;
    
    if (url) {
        __weak typeof(self) weakSelf = self;
        [self setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            if (completion) {
                completion(image);
            }
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            [weakSelf configureWithName:defaultName andFont:font];
        }];
    } else {
        [self configureWithName:defaultName andFont:font];
    }
}

- (void)configureWithName:(NSString *)name andFont:(UIFont *)font {
    self.nameLabel.text = [name uppercaseString];
    self.nameLabel.font = font;
}

- (void)configureNameLabel {
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [UIColor ggp_darkGray];
    [self addSubview:self.nameLabel];
}

@end
