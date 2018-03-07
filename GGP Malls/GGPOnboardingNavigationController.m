//
//  GGPOnboardingViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPOnboardingLoadingViewController.h"
#import "GGPOnboardingNavigationController.h"
#import "UINavigationController+GGPAdditions.h"

@implementation GGPOnboardingNavigationController

- (instancetype)init {
    return [super initWithRootViewController:[GGPOnboardingLoadingViewController new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
}

@end
