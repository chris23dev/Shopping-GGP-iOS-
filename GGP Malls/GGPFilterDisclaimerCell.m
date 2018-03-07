//
//  GGPFilterDisclaimerCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFilterDisclaimerCell.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

NSString *const GGPFilterDisclaimerCellReuseIdentifier = @"GGPFilterDisclaimerCellReuseIdentifier";

@interface GGPFilterDisclaimerCell ()

@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;

@end

@implementation GGPFilterDisclaimerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.backgroundColor = [UIColor ggp_disclaimerBackground];
    self.disclaimerLabel.numberOfLines = 0;
    self.disclaimerLabel.textAlignment = NSTextAlignmentCenter;
    self.disclaimerLabel.font = [UIFont ggp_lightItalicWithSize:14];
    self.disclaimerLabel.text = [@"PRODUCT_FILTER_DISCLAIMER" ggp_toLocalized];
    self.userInteractionEnabled = NO;
    [self.disclaimerLabel sizeToFit];
}

@end
