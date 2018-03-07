//
//  GGPHeroViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPHero;

@interface GGPHeroViewController : UIViewController

- (instancetype)initWithHero:(GGPHero *)hero andImage:(UIImage *)image;

@end
