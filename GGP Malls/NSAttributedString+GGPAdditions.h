//
//  NSAttributedString+GGPAdditions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (GGPAdditions)

+ (NSAttributedString *)ggp_generateEmailSupportAttributedStringWithColor:(UIColor *)textColor;
+ (NSAttributedString *)ggp_generateTermsAttributedStringWithColor:(UIColor *)textColor;
+ (NSAttributedString *)ggp_generateSweepstakesAttributedStringWithColor:(UIColor *)textColor;

@end
