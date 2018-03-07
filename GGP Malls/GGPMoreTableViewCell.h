//
//  GGPMoreTableViewCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GGPMoreTableViewCellReuseIdentifier;

@interface GGPMoreTableViewCell : UITableViewCell

- (void)configureWithTitle:(NSString *)title;

@end
