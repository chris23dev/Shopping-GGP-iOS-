//
//  GGPFadedImageView.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPFadedImageView : UIImageView

- (void)configureWithImageUrl:(NSURL *)url;
- (void)configureWithImageUrl:(NSURL *)url andOnFailure:(void (^)())onFailure;

@end
