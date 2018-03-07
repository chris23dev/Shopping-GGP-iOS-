//
//  GGPSubscriptionDetailTableViewDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GGPMall;

@protocol GGPSubscriptionDetailTableViewDelegate <NSObject>

- (void)cellTappedWithPreferredMall:(GGPMall *)preferredMall forUserMallId:(NSString *)userMallIdString;

@end
