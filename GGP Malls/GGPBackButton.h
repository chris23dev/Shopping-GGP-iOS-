//
//  GGPBackButton.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 4/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPBackButton : UIBarButtonItem

- (instancetype)initWithTapHandler:(void(^)())onTap;

@end
