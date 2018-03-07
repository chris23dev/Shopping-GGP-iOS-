//
//  GGPTenantSearchTableViewCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantSearchTableViewCell.h"
#import "UIFont+GGPAdditions.h"

NSString *const GGPTenantSearchTableViewCellReuseIdentifier = @"GGPTenantSearchTableViewCellReuseIdentifier";

@interface GGPTenantSearchTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation GGPTenantSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.font = [UIFont ggp_regularWithSize:15];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
}

- (void)configureWithTenantName:(NSString *)name {
    self.nameLabel.text = name;
}

@end
