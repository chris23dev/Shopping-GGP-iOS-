//
//  GGPWayfindingRouteDetailHeaderFooterView.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

@class GGPTenant;
#import <UIKit/UIKit.h>

extern NSString* const GGPWayfindingRouteDetailHeaderFooterViewReuseIdentifier;

@interface GGPWayfindingRouteDetailHeaderFooterView : UITableViewHeaderFooterView

- (void)configureWithTenant:(GGPTenant *)tenant isFooterView:(BOOL)isFooterView;

@end
