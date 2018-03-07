//
//  GGPSubscriptionDetailViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPSubscriptionDetailDelegate.h"
#import <UIKit/UIKit.h>

@interface GGPSubscriptionDetailViewController : UIViewController

@property (weak, nonatomic) id<GGPSubscriptionDetailDelegate> subscriptionDetailDelegate;

@end
