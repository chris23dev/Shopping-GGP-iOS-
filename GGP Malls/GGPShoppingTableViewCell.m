//
//  GGPSalesTableCellTableViewCell.m
//  GGP Malls
//
//  Created by Janet Lin on 1/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPShoppingTableViewCell.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "GGPLogoImageView.h"

NSString* const GGPShoppingTableViewCellReuseIdentifier = @"GGPShoppingTableViewCellReuseIdentifier";
static CGFloat const kImageWidth = 110;

@interface GGPShoppingTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *tenantLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet GGPLogoImageView *logoImageView;
@end

@implementation GGPShoppingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupTextStyling];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.separatorInset = UIEdgeInsetsZero;
}

- (void)configureCellWithSale:(GGPSale *)sale {
    self.logoImageView.image = nil;
    [self.logoImageView cancelImageRequestOperation];
    
    self.titleLabel.text = sale.title;
    self.tenantLabel.text = sale.tenantName;
    [self.logoImageView setImageWithURL:sale.imageUrl width:kImageWidth defaultName:sale.tenant.name andFont:[UIFont ggp_mediumWithSize:10]];
    self.dateLabel.text = sale.promotionDates;
}

- (void)setupTextStyling {
    self.tenantLabel.font = [UIFont ggp_regularWithSize:13];
    self.tenantLabel.textColor = [UIColor ggp_darkGray];
    self.tenantLabel.numberOfLines = 1;
    
    self.titleLabel.font =[UIFont ggp_regularWithSize:13];
    self.titleLabel.textColor = [UIColor ggp_darkGray];
    self.titleLabel.numberOfLines = 2;
    
    self.dateLabel.font = [UIFont ggp_regularWithSize:13];
    self.dateLabel.textColor = [UIColor ggp_manateeGray];
}

@end
