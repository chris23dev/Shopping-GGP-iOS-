//
//  JMapStyleSheetKeys.h
//  JMapSDK
//
//  Created by developer on 2015-03-27.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const kCSSStoreLabels;
FOUNDATION_EXTERN NSString *const kCSSPathIcon;
FOUNDATION_EXPORT NSString *const kCSSPathStyles;

@class JMapStyleLayers;

@interface JMapCustomStyleSheet : NSObject
@property (nonatomic, strong, readonly) NSDictionary *originalDictionary;
@property (nonatomic, strong, readonly) NSMutableDictionary *inputStyleSheet;
@property (nonatomic, strong) NSString *jSONSourceConfig;
@property (nonatomic, strong) NSDictionary *embeddedSVGStyle;
@end
