//
//  GGPLogoImageView.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPLogoImageView : UIImageView

- (void)setImageWithURL:(NSURL *)url defaultName:(NSString *)defaultName;
- (void)setImageWithURL:(NSURL *)url defaultName:(NSString *)defaultName andFont:(UIFont *)font;
- (void)setImageWithURL:(NSURL *)url width:(CGFloat)Width defaultName:(NSString *)defaultName andFont:(UIFont *)font;
- (void)setImageWithURL:(NSURL *)url defaultName:(NSString *)defaultName font:(UIFont *)font andCompletion:(void (^)(UIImage *image))completion;

@end
