//
//  GGPModalViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 6/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPModalViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPModalViewController ()

@property (assign, nonatomic) BOOL includeCloseButton;
@property (copy, nonatomic) void(^onClose)();

@end

@implementation GGPModalViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController andOnClose:(void(^)())onClose {
    return [self initWithRootViewController:rootViewController includeCloseButton:YES andOnClose:onClose];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController includeCloseButton:(BOOL)includeCloseButton andOnClose:(void (^)())onClose {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.onClose = onClose;
        self.includeCloseButton = includeCloseButton;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationBar.barTintColor = [UIColor ggp_extraLightGray];
    [self ggp_configureWithDarkText];
    [self addCloseButtonToController:self.viewControllers.firstObject];
}

- (void)addCloseButtonToController:(UIViewController *)controller {
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                    target:self
                                    action:@selector(cancelButtonTapped)];
    controller.navigationItem.rightBarButtonItem = self.includeCloseButton ? closeButton : nil;
}

- (void)cancelButtonTapped {
    if (self.onClose) {
        self.onClose();
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self addCloseButtonToController:viewController];
    [viewController ggp_removeTitleFromBackButton];
    [super pushViewController:viewController animated:animated];
}

@end
