//
//  GGPAccountItemTableViewCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccountItemTableViewCell.h"
#import "UIFont+GGPAdditions.h"

NSString* const GGPAccountItemTableViewCellReuseIdentifier = @"GGPAccountItemTableViewCellReuseIdentifier";
CGFloat const GGPAccountItemTableViewCellHeight = 50;

@implementation GGPAccountItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.font = [UIFont ggp_regularWithSize:16];
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureWithText:(NSString *)text {
    self.textLabel.text = text;
}

@end
