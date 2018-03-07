//
//  JMapSVGUnitView.h
//  JMap
//
//  Created by Bryan Hayes on 2015-08-19.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMapSVGUnitView : UIView

@property (nonatomic, retain) id linkToUnit;
@property (nonatomic, strong) NSMutableArray *arrayOfShapes;

// Bryan: This will be used to offset drawing of path.
// Once the JMapBaseElement* is done rendering the path will be draw as if on current map. But since we are overlaying UIView rect over the path's location, UIView drawRect: has to shift rendered cell. Use designatedCenter to offset the render once done.
@property CGPoint designatedCenter;

@property BOOL animatedState;

+(NSInteger)yourTag;

- (void)setIsAnimated:(BOOL)isAnimated;
- (BOOL)getIsAnimated;

@end
