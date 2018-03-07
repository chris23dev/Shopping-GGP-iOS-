//
//  GGPLevelSelectorDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMap/JMap.h>

@protocol GGPLevelSelectorDelegate <NSObject>

- (void)levelCellWasTapped:(JMapFloor *)selectedFloor;

@end
