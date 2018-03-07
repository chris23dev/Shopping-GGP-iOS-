//
//  JMapViewCommander.h
//  JMap
//
//  Created by Bryan Hayes on 2015-08-25.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface JMapViewCommander : NSObject

-(id)initViewCommander:(id)withLinkToMain;

-(NSThread *)getYourThread;
-(void)exitThread;

// JMap functions
-(void)addView:(UIView *)thisView;
-(void)removeView:(UIView *)thisView;
-(void)updateFrame:(UIView *)thisView;

@end
