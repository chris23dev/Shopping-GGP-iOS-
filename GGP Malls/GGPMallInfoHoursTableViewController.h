//
//  GGPMallInfoHoursTableViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPMall;

@interface GGPMallInfoHoursTableViewController : UITableViewController

- (void)configureWithMall:(GGPMall *)mall;

@end
