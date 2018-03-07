//
//  GGPVersionController.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 5/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGPVersionController : NSObject

+ (void)checkAppVersionWithCompletion:(void(^)(BOOL requiresUpdate))completion;
+ (BOOL)hasUpdatedSincePreviousLaunch;

@end
