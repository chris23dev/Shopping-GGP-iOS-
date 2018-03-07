//
//  GGPAccountItemTableViewCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const GGPAccountItemTableViewCellReuseIdentifier;
extern CGFloat const GGPAccountItemTableViewCellHeight;

@interface GGPAccountItemTableViewCell : UITableViewCell

- (void)configureWithText:(NSString *)text;

@end
