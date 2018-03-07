//
//  GGPFeedbackManager.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GGPFeedbackManager : NSObject

+ (void)configureWithPresenter:(UIViewController *)presenter;
+ (void)trackAction;
+ (void)resetActionCount;

@end
