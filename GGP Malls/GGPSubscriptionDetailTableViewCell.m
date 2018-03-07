//
//  GGPSubscriptionDetailTableViewCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPSubscriptionDetailTableViewCell.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

NSString* const GGPSubscriptionDetailTableViewCellReuseIdentifier = @"GGPSubscriptionDetailTableViewCellReuseIdentifier";

@implementation GGPSubscriptionDetailTableViewCell

- (void)configureWithMall:(GGPMall *)mall {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.text = mall.name;
    self.textLabel.font = [UIFont ggp_mediumWithSize:14];
    self.textLabel.textColor = [UIColor grayColor];
}

@end
