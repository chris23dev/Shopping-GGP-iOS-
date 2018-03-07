//
//  GGPNavigationController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPNavigationController.h"

@interface GGPNavigationController () <UINavigationControllerDelegate>

@end

@implementation GGPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (self.presentedViewController != viewControllerToPresent) {
        [super presentViewController:viewControllerToPresent animated:YES completion:completion];
    }
}

@end
