//
//  GGPOverlayImageController.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 5/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GGPOverlayImageController : NSObject

- (instancetype)initWithOverlayImageView:(UIImageView *)overlayImageView;
- (void)hideOverlayImage;
- (void)displayLaunchOverlayImage;
- (void)displayLoadingOverlayImage;

@end
