//
//  GGPSubscriptionDetailTableViewCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGPMall;

extern NSString* const GGPSubscriptionDetailTableViewCellReuseIdentifier;

@interface GGPSubscriptionDetailTableViewCell : UITableViewCell

- (void)configureWithMall:(GGPMall *)mall;

@end
