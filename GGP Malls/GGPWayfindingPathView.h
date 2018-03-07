//
//  GGPWayfindingPathView.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMap/JMap.h>

@interface GGPWayfindingPathView : UIView

@property (strong, nonatomic) JMapPathPerFloor *pathPerFloor;
@property (strong, nonatomic) JMapFloor *floor;
@property (strong, nonatomic) id animationDelegate;

- (instancetype)initWithFloor:(JMapFloor *)floor;
- (void)animatePath;

@end
