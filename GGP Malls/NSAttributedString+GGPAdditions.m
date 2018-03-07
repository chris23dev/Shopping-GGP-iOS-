//
//  NSAttributedString+GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "NSAttributedString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

@implementation NSAttributedString (GGPAdditions)

+ (NSAttributedString *)ggp_generateEmailSupportAttributedStringWithColor:(UIColor *)textColor {
    NSString *displayString = [NSString stringWithFormat:@"%@ %@.", [@"EMAIL_SUPPORT_DESCRIPTION" ggp_toLocalized], [@"EMAIL_SUPPORT_ADDRESS" ggp_toLocalized]];
    return [self ggp_attributedLinkStringWithDisplayString:displayString linkString:[@"EMAIL_SUPPORT_ADDRESS" ggp_toLocalized] textColor:textColor andFont:[UIFont ggp_mediumWithSize:14]];
}

+ (NSAttributedString *)ggp_generateTermsAttributedStringWithColor:(UIColor *)textColor {
    return [self ggp_attributedLinkStringWithDisplayString:[@"REGISTER_CONSENT" ggp_toLocalized] linkString:[@"REGISTER_PRIVACY_POLICY" ggp_toLocalized] textColor:textColor andFont:[UIFont ggp_regularWithSize:14]];
}

+ (NSAttributedString *)ggp_generateSweepstakesAttributedStringWithColor:(UIColor *)textColor {
    return [self ggp_attributedLinkStringWithDisplayString:[@"REGISTER_SWEEPSTAKES_ENTER" ggp_toLocalized] linkString:[@"REGISTER_SWEEPSTAKES_TERMS" ggp_toLocalized] textColor:textColor andFont:[UIFont ggp_regularWithSize:14]];
}

+ (NSAttributedString *)ggp_attributedLinkStringWithDisplayString:(NSString *)displayString linkString:(NSString *)linkString textColor:(UIColor *)textColor andFont:(UIFont *)font {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]
                                             initWithString:displayString
                                             attributes:@{ NSFontAttributeName: font,
                                                           NSForegroundColorAttributeName: textColor }];
    
    [attrString addAttribute:NSLinkAttributeName
                       value:NSLinkAttributeName
                       range:[attrString.string rangeOfString:linkString]];
    
    return attrString;
}

@end
