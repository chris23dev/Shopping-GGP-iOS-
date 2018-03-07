//
//  GGPSubscriptionDetailDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GGPMall;

@protocol GGPSubscriptionDetailDelegate <NSObject>

- (void)didUpdatePreferredMall:(GGPMall *)newPreferredMall toReplaceMall:(GGPMall *)formerPreferredMall forUserMallIdString:(NSString *)userMallIdString;

@end
