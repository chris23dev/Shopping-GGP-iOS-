//
//  GGPBrandFooterView.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBrandFooterView.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

NSString* const GGPBrandFooterViewReuseIdentifier = @"GGPBrandFooterViewReuseIdentifier";

@interface GGPBrandFooterView ()

@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;

@end

@implementation GGPBrandFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.borderView.backgroundColor = [UIColor ggp_lightGray];
    
    self.disclaimerLabel.numberOfLines = 0;
    self.disclaimerLabel.font = [UIFont ggp_regularWithSize:16];
    self.disclaimerLabel.text = [@"FILTER_BRANDS_RESULTS_DISCLAIMER" ggp_toLocalized];
    [self.disclaimerLabel sizeToFit];
}

@end
