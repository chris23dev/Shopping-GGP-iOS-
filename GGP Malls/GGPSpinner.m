//
//  GGPLoaderManager.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/30/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPSpinner.h"
#import "MBProgressHUD.h"
#import "UIColor+GGPAdditions.h"

static NSInteger const kGraceLoadTime = 3;

@implementation GGPSpinner

+ (void)showForView:(id)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.color = [UIColor clearColor];
    hud.graceTime = kGraceLoadTime;
}

+ (void)hideForView:(id)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
