//
//  GGPMoreTableViewCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMoreTableViewCell.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

NSString *const GGPMoreTableViewCellReuseIdentifier = @"GGPMoreTableViewCellReuseIdentifier";

@implementation GGPMoreTableViewCell

- (void)configureWithTitle:(NSString *)title {
    self.layoutMargins = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.indentationLevel = 1;
    self.indentationWidth = 25;
    
    self.textLabel.font = [UIFont ggp_regularWithSize:16];
    self.textLabel.textColor = [UIColor ggp_darkGray];
    self.textLabel.text = title;
}

@end
