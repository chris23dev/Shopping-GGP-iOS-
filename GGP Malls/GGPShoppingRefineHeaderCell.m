//
//  GGPShoppingRefineHeaderCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/4/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPShoppingRefineHeaderCell.h"
#import "UIFont+GGPAdditions.h"
#import "GGPCellData.h"
#import "UIColor+GGPAdditions.h"

NSString *const GGPShoppingRefineHeaderReusueIdentifier = @"GGPShoppingRefineHeaderReusueIdentifier";

@interface GGPShoppingRefineHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end

@implementation GGPShoppingRefineHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.userInteractionEnabled = NO;
    self.headerLabel.font = [UIFont ggp_regularWithSize:12];
    self.headerLabel.textColor = [UIColor ggp_gray];
}

- (void)configureWithTitle:(NSString *)title {
    self.headerLabel.text = title;
}

@end
