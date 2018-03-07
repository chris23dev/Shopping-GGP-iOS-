//
//  GGPShoppingRefineTenantSortHeaderCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCellData.h"
#import "GGPShoppingRefineTenantSortHeaderCell.h"
#import "UIButton+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

NSString *const GGPShoppingRefineTenantSortHeaderCellReuseIdentifier = @"GGPShoppingRefineTenantSortHeaderCellReuseIdentifier";

@interface GGPShoppingRefineTenantSortHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *clearAllButton;

@property (strong, nonatomic) GGPCellData *cellData;

@end

@implementation GGPShoppingRefineTenantSortHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.label.font = [UIFont ggp_regularWithSize:12];
    self.label.textColor = [UIColor ggp_gray];
    
    [self.clearAllButton ggp_styleAsLinkButton];
    [self.clearAllButton setTitle:[@"SHOPPING_REFINE_STORE_FILTER_CLEAR_ALL" ggp_toLocalized]
                         forState:UIControlStateNormal];
}

- (void)configureWithCellData:(GGPCellData *)cellData {
    self.cellData = cellData;
    self.label.text = cellData.title;
}

- (IBAction)clearAllTapped:(id)sender {
    if (self.cellData.tapHandler) {
        self.cellData.tapHandler();
    }
}

@end
