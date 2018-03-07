//
//  GGPShoppingRefineSortByCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCellData.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "GGPShoppingRefineCell.h"

NSString *const GGPShoppingRefineCellReuseIdentifier = @"GGPShoppingRefineCellReuseIdentifier";

@interface GGPShoppingRefineCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;

@end

@implementation GGPShoppingRefineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.label.font = [UIFont ggp_regularWithSize:14];
    self.label.textColor = [UIColor ggp_darkGray];
    
    self.secondaryLabel.font = [UIFont ggp_regularWithSize:14];
    self.secondaryLabel.textColor = [UIColor grayColor];
}

- (void)configureWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle {
    self.label.text = title;
    
    NSString *secondaryLabel = subtitle ? [NSString stringWithFormat:@"(%@)", subtitle] : nil;
    self.secondaryLabel.text = secondaryLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

@end
