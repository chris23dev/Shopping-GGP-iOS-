//
//  UIViewController+GGPAdditions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

@class GGPFormField;
#import <UIKit/UIKit.h>

@interface UIViewController (GGPAdditions)

#pragma mark - Child view controllers

- (void)ggp_addChildViewController:(UIViewController *)childViewController toPlaceholderView:(UIView *)placeholderView;
- (void)ggp_addChildViewController:(UIViewController *)childViewController toStackView:(UIStackView *)stackView;
- (void)ggp_removeFromParentViewController;
- (BOOL)ggp_childViewControllersContainViewControllerOfClass:(Class)childControllerClass;
- (void)ggp_configureAndAddFormField:(GGPFormField *)formField withPlaceholder:(NSString *)placeholder andErrorMessage:(NSString *)errorMessage toContainer:(UIView *)container;

# pragma mark - Alerts

- (void)ggp_displayAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)ggp_displayAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)customActionTitle andCompletion:(void (^)(void))completion;
- (void)ggp_displayAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)customActionTitle actionCompletion:(void (^)(void))actionCompletion cancelTitle:(NSString *)cancelTitle cancelCompletion:(void (^)(void))cancelCompletion;
- (void)ggp_displayAlertWithTitle:(NSString *)title message:(NSString *)message andActions:(NSArray *)actions;
- (void)ggp_displayAlertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions andPreferredAction:(UIAlertAction *)preferredAction;

#pragma mark - Account back button

- (void)ggp_accountBackButtonPressedForState:(BOOL)userHasChanges;
- (void)ggp_removeTitleFromBackButton;

#pragma mark - Application

- (BOOL)canOpenScheme:(NSString *)scheme;

@end
