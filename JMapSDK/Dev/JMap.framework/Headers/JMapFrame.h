//
//  JMapFrame.h
//  JMap
//
//  Created by Bryan Hayes on 2015-08-25.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface JMapFrame : NSObject

// View container

@property (weak) UIView *theView;

@property CGRect originalFrame;
@property CGPoint originalCenter;

@property CGRect currentFrame;
@property CGPoint currentCenter;

@property BOOL needsToUpdate;

@end
