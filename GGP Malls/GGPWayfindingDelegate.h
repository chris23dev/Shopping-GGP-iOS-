//
//  GGPWayfindingDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/7/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMapFloor;

@protocol GGPWayfindingDelegate <NSObject>

- (void)didUpdateFloor:(JMapFloor *)floor;

@end
