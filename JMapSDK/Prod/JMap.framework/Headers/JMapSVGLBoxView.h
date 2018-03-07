//
//  JMapSVGLBoxView.h
//  JMap
//
//  Created by Bryan Hayes on 2015-08-20.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface JMapSVGLBoxView : UIView

@property (nonatomic, retain) NSArray *linkToDestinations;
@property (nonatomic, retain) NSString *unitName;
@property (nonatomic) float textIndent;
@property (nonatomic, strong) UILabel *localLabel;

+(NSInteger)yourTag;

- (id)initWithFrame:(CGRect)aRect withString:(NSString *)withString withIndent:(float)withIndent;

@end
