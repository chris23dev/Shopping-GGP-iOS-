//
//  JMapSVGIconView.h
//  JMap
//
//  Created by Bryan Hayes on 2015-08-14.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMapSVGParser;

@interface JMapSVGIconView : UIView

@property (weak) JMapSVGParser *linkToSVGIcon;

- (void)setIsAnimated:(BOOL)isAnimated scale:(float)scale;
+(NSInteger)yourTag;
-(id)initWithFrame:(CGRect)aRect parentId:(id)parentId iconId:(id)iconId;
-(id)getParent;
-(BOOL)getIsAnimated;
-(void)cleanUp;

-(void)setShapes:(NSArray *)shapes;

-(void)redrawIcon:(BOOL)forceRedraw;

@end
