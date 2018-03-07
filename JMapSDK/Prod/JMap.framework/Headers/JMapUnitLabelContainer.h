//
//  JMapUnitLabelContainer.h
//  JMap
//
//  Created by Bryan Hayes on 2015-09-02.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface JMapUnitLabelContainer : NSObject

@property (strong) UIView *theView;
@property BOOL toolTip;
@property BOOL viewFrozen;
@property (assign) CGAffineTransform originalTransform;

-(id)initWithView:(UIView *)viewIn isPopup:(BOOL)isPopup isFrozen:(BOOL)isFrozen;

@end
