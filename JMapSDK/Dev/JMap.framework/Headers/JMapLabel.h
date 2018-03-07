//
//  SVGLabel.h
//  JMapSDK
//
//  Created by developer on 2015-04-17.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import "JMapToolTips.h"
/**
 * Welcome to JMapLabel.
 *
 * This Object is rendered in the map as a label box entity.
 **/
@interface JMapLabel : JMapToolTips
{
    CGRect _textRect;
}
/*!
 * Flag which determins if the display of image
 */
@property (NS_NONATOMIC_IOSONLY) BOOL bShowImageFlag;
/*!
 * The orientation of label box in radians
 */
@property (NS_NONATOMIC_IOSONLY) CGFloat angle;
/*!
 * Path url to the label box image
 */
@property (NS_NONATOMIC_IOSONLY) NSURL *helpImagerURL;
/*!
 * Image container view for help image url
 */
@property (nonatomic, strong, readonly) UIImageView *helperImage;

@end
