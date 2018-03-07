//
//  GGPLog.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface GGPLog : NSObject

+ (void)configureLoggers;

@end
