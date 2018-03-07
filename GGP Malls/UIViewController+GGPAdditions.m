//
//  UIViewController+GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPFormField.h"
#import "NSString+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@implementation UIViewController (GGPAdditions)

- (void)ggp_addChildViewController:(UIViewController *)childViewController toPlaceholderView:(UIView *)placeholderView {
    if (!childViewController || !placeholderView) {
        return;
    }
    
    [self addChildViewController:childViewController];
    [placeholderView addSubview:childViewController.view];
    [childViewController.view ggp_addConstraintsToFillSuperview];
    [childViewController didMoveToParentViewController:self];
}

- (void)ggp_addChildViewController:(UIViewController *)childViewController toStackView:(UIStackView *)stackView {
    if (!childViewController || !stackView) {
        return;
    }
    
    [self addChildViewController:childViewController];
    [stackView addArrangedSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
}

- (void)ggp_removeFromParentViewController {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (BOOL)ggp_childViewControllersContainViewControllerOfClass:(Class)childControllerClass {
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController isKindOfClass:childControllerClass]) {
            return YES;
        }
    }
    return NO;
}

- (void)ggp_displayAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    [self ggp_displayAlertWithTitle:title message:message actionTitle:nil andCompletion:nil];
}

- (void)ggp_displayAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)customActionTitle andCompletion:(void (^)(void))completion {
    [self ggp_displayAlertWithTitle:title message:message actionTitle:customActionTitle actionCompletion:completion cancelTitle:nil cancelCompletion:nil];
}

- (void)ggp_displayAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)customActionTitle actionCompletion:(void (^)(void))actionCompletion cancelTitle:(NSString *)cancelTitle cancelCompletion:(void (^)(void))cancelCompletion {
    NSString *defaultActionTitle = customActionTitle.length ? customActionTitle : [@"ALERT_OK" ggp_toLocalized];
    
    NSMutableArray *actions = [NSMutableArray new];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:defaultActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (actionCompletion) {
            actionCompletion();
        }
    }];
    [actions addObject:defaultAction];
    
    if (cancelTitle.length) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelCompletion) {
                cancelCompletion();
            }
        }];
        [actions addObject:cancelAction];
    }
    
    [self ggp_displayAlertWithTitle:title message:message actions:actions andPreferredAction:nil];
    
}

- (void)ggp_displayAlertWithTitle:(NSString *)title message:(NSString *)message andActions:(NSArray *)actions {
    [self ggp_displayAlertWithTitle:title message:message actions:actions andPreferredAction:nil];
}

- (void)ggp_displayAlertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions andPreferredAction:(UIAlertAction *)preferredAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (UIAlertAction *action in actions) {
        [alertController addAction:action];
    }
    
    if ([alertController respondsToSelector:@selector(preferredAction)]) {
        alertController.preferredAction = preferredAction;
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)ggp_configureAndAddFormField:(GGPFormField *)formField withPlaceholder:(NSString *)placeholder andErrorMessage:(NSString *)errorMessage toContainer:(UIView *)container {
    formField.placeholder = placeholder;
    formField.errorMessage = errorMessage;
    container.backgroundColor = [UIColor clearColor];
    [container addSubview:formField];
    [formField ggp_addConstraintsToFillSuperview];
}

- (void)ggp_accountBackButtonPressedForState:(BOOL)userHasChanges {
    if (userHasChanges) {
        [self ggp_displayAlertWithTitle:[@"ALERT_UNSAVED_CHANGES_TITLE" ggp_toLocalized]
                                message:[@"ALERT_UNSAVED_CHANGES_TEXT" ggp_toLocalized]
                            actionTitle:[@"ALERT_UNSAVED_CHANGES_LEAVE" ggp_toLocalized]
                       actionCompletion:^{
                           [self.navigationController popViewControllerAnimated:YES];
                       }    cancelTitle:[@"ALERT_UNSAVED_CHANGES_STAY" ggp_toLocalized]
                       cancelCompletion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)ggp_removeTitleFromBackButton {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - Application

- (BOOL)canOpenScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    return [application canOpenURL:URL];
}

@end
