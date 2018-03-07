//
//  GGPTenantDetailRibbonCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantDetailRibbonCell.h"
#import "GGPTenantDetailRibbonCellData.h"
#import "UIFont+GGPAdditions.h"

NSString *const GGPTenantDetailRibbonCellReuseIdentifier = @"GGPTenantDetailRibbonCellReuseIdentifier";
CGFloat const GGPTenantDetailRibbonCellHeight = 60;

@interface GGPTenantDetailRibbonCell ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *rightBorder;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GGPTenantDetailRibbonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureCell];
}

- (void)configureCell {
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont ggp_mediumWithSize:10];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.rightBorder.backgroundColor = [UIColor grayColor];
}

- (void)configureCellWithCellData:(GGPTenantDetailRibbonCellData *)cellData isLastCell:(BOOL)isLastCell {
    self.textLabel.text = cellData.title;
    self.imageView.image = cellData.image;
    self.rightBorder.hidden = isLastCell;
}

@end
