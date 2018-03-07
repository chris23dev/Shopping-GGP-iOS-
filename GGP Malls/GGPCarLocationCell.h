//
//  GGPCarLocationCell.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GGPCarLocationCellId;

@class GGPParkingCarLocation;
@class GGPParkingSite;

@interface GGPCarLocationCell : UITableViewCell

- (void)configureWithCarLocation:(GGPParkingCarLocation *)carLocation andSite:(GGPParkingSite *)site;

@property (copy, nonatomic) void(^onMapTapped)(GGPParkingCarLocation *carLocation);

@end
