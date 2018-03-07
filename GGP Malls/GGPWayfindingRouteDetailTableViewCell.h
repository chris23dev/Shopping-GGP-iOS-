//
//  GGPWayfindingRouteDetailTableViewCell.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <JMap/JMap.h>
#import <UIKit/UIKit.h>

extern NSString* const GGPWayfindingRouteDetailTableViewCellReuseIdentifier;
extern CGFloat const GGPWayfindingRouteDetailTableViewCellHeight;

@interface GGPWayfindingRouteDetailTableViewCell : UITableViewCell

- (void)configureCellWithDirectionInstruction:(JMapTextDirectionInstruction *)direction;

@end
