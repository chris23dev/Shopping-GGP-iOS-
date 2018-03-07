//
//  GGPRibbonNavigationViewCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPRibbonNavigationViewCell.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

NSString *const GGPRibbonNavigationViewCellReuseIdentifier = @"GGPRibbonNavigationViewCellReuseIdentifier";
CGFloat const GGPRibbonNavigationViewCellHeight = 43;

@interface GGPRibbonNavigationViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedBar;

@end

@implementation GGPRibbonNavigationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureWithTitle:(NSString *)title andIsSelected:(BOOL)isSelected {
    self.titleLabel.text = title;
    self.selected = isSelected;
}

- (void)configureControls {
    self.titleLabel.font = [UIFont ggp_boldWithSize:13];
    self.selectedBar.backgroundColor = [UIColor ggp_blue];
    self.selectedBar.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        [self styleAsSelected];
    } else {
        [self styleAsUnselected];
    }
}

- (void)styleAsSelected {
    self.titleLabel.textColor = [UIColor ggp_blue];
    self.selectedBar.hidden = NO;
}

- (void)styleAsUnselected {
    self.titleLabel.textColor = [UIColor ggp_mediumGray];
    self.selectedBar.hidden = YES;
}

@end
