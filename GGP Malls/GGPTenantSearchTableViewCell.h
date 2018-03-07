//
//  GGPTenantSearchTableViewCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GGPTenantSearchTableViewCellReuseIdentifier;

@interface GGPTenantSearchTableViewCell : UITableViewCell

- (void)configureWithTenantName:(NSString *)name;

@end
