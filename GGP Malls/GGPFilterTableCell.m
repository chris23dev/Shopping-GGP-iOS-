//
//  GGPFilterTableCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/22/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPFilterTableCell.h"
#import "GGPFilterTableCellData.h"
#import "UIFont+GGPAdditions.h"

NSString *const GGPFilterCellReuseIdentifier = @"GGPFilterCellReuseIdentifier";

@implementation GGPFilterTableCell

- (void)configureWithCellData:(GGPFilterTableCellData *)cellData {
    self.layoutMargins = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = cellData.hasChildItems ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.textLabel.font = [UIFont ggp_regularWithSize:16];
    self.textLabel.textColor = [UIColor darkGrayColor];
    
    BOOL hasCategoryCount = cellData.filterItem.count > 0;
    NSString *filterCountString = hasCategoryCount ? [NSString stringWithFormat:@" (%ld)", (long)cellData.filterItem.count] : @"";
    self.textLabel.text = [NSString stringWithFormat:@"%@%@", cellData.title, filterCountString];
}

@end
