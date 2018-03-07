//
//  GGPShoppingRefineActionCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/4/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCellData.h"
#import "GGPShoppingRefineActionCell.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

NSString *const GGPShoppingRefineActionReusueIdentifier = @"GGPShoppingRefineActionReusueIdentifier";

@interface GGPShoppingRefineActionCell ()

@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;

@end

@implementation GGPShoppingRefineActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.actionLabel.font = [UIFont ggp_mediumWithSize:14];
    self.secondaryLabel.font = [UIFont ggp_regularWithSize:12];
    self.secondaryLabel.textColor = [UIColor grayColor];
}

- (void)configureWithCellData:(GGPCellData *)cellData {
    [self configureWithCellData:cellData isClearAllCell:NO];
}

- (void)configureWithCellData:(GGPCellData *)cellData isClearAllCell:(BOOL)isClearAllCell {
    self.actionLabel.text = cellData.title;
    
    self.secondaryLabel.text = cellData.subTitle ?
        [NSString stringWithFormat:@"(%@)", cellData.subTitle] :
        nil;
    
    self.actionLabel.textColor = isClearAllCell ?
        [UIColor ggp_blue] :
        [UIColor ggp_darkGray];
    
    self.selectionStyle = cellData.tapHandler ?
        UITableViewCellSelectionStyleDefault :
        UITableViewCellSelectionStyleNone;
    
    self.accessoryType = cellData.tapHandler && !isClearAllCell ?
        UITableViewCellAccessoryDisclosureIndicator :
        UITableViewCellAccessoryNone;
}

@end
