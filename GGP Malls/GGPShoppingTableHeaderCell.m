//
//  GGPShoppingTableHeaderCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPShoppingTableHeaderCell.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

NSString *const GGPShoppingTableHeaderCellReuseIdentifier = @"GGPShoppingTableHeaderCellReuseIdentifier";

@interface GGPShoppingTableHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation GGPShoppingTableHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.label.font = [UIFont ggp_regularWithSize:12];
    self.label.textColor = [UIColor ggp_manateeGray];
}

- (void)configureWithCategoryName:(NSString *)name tenantCount:(NSInteger)tenantCount andCount:(NSInteger)count {
    NSString *labelWithTenants = tenantCount == 1 ?
        [NSString stringWithFormat:[@"SHOPPING_RESULTS_HEADER_WITH_TENANT" ggp_toLocalized], (long)count, tenantCount] :
        [NSString stringWithFormat:[@"SHOPPING_RESULTS_HEADER_WITH_TENANTS" ggp_toLocalized], (long)count, tenantCount];
    
    NSString *label = tenantCount > 0 ?
        labelWithTenants :
        [NSString stringWithFormat:[@"SHOPPING_RESULTS_HEADER" ggp_toLocalized], (long)count, name];
    
    self.label.text = label;
}

@end
