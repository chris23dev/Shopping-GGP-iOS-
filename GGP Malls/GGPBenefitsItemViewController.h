//
//  GGPBenefitsItemViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPBenefitsItemViewController : UIViewController

@property (assign, nonatomic, readonly) NSInteger position;

- (instancetype)initWithTitle:(NSString *)title description:(NSString *)description background:(UIImage *)background icon:(UIImage *)icon andPosition:(NSInteger)position;

@end
