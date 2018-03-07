//
//  GGPAuthenticationController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAuthenticationController.h"
#import "GGPRegisterViewController.h"
#import "GGPLoginViewController.h"
#import "UIViewController+GGPAdditions.h"

NSString *const GGPAuthenticationCompletedNotification = @"GGPAuthenticationCompletedNotification";

@implementation GGPAuthenticationController

+ (instancetype)authenticationControllerForLogin {
    return [[GGPAuthenticationController alloc] initWithRootViewController:[GGPLoginViewController new]];
}

+ (instancetype)authenticationControllerForRegistration {
    return [[GGPAuthenticationController alloc] initWithRootViewController:[GGPRegisterViewController new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCloseButtonToController:self.viewControllers.firstObject];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationCompleted) name:GGPAuthenticationCompletedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GGPAuthenticationCompletedNotification object:nil];
}

- (void)addCloseButtonToController:(UIViewController *)controller {
    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeButtonTapped)];
}

- (void)authenticationCompleted {
    if ([self.authenticationDelegate respondsToSelector:@selector(authenticationCompleted)]) {
        [self.authenticationDelegate authenticationCompleted];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeButtonTapped {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.authenticationDelegate respondsToSelector:@selector(authenticationCanceled)]) {
            [self.authenticationDelegate authenticationCanceled];
        }
    }];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self addCloseButtonToController:viewController];
    [viewController ggp_removeTitleFromBackButton];
    [super pushViewController:viewController animated:animated];
}

@end
