//
//  GGPCallToRegisterViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCallToRegisterViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "GGPAuthenticationController.h"
#import "GGPTabBarController.h"
#import "GGPAuthenticationDelegate.h"

@interface GGPCallToRegisterViewController () <GGPAuthenticationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIView *dividerLine;

@end

@implementation GGPCallToRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureControls {
    self.titleLabel.font = [UIFont ggp_regularWithSize:16];
    self.titleLabel.text = [@"FEATURED_CALL_TO_REGISTER_TITLE" ggp_toLocalized];
    self.titleLabel.textColor = [UIColor ggp_darkGray];
    
    self.descriptionLabel.font = [UIFont ggp_lightWithSize:16];
    self.descriptionLabel.text = [@"FEATURED_CALL_TO_REGISTER_DESCRIPTION" ggp_toLocalized];
    self.descriptionLabel.textColor = [UIColor ggp_darkGray];
    
    [self.registerButton setTitleColor:[UIColor ggp_extraLightGray] forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = [UIFont ggp_boldWithSize:15];
    self.registerButton.backgroundColor = [UIColor ggp_blue];
    self.registerButton.layer.cornerRadius = 2;
    [self.registerButton setTitle:[@"FEATURED_CREATE_ACCOUNT" ggp_toLocalized] forState:UIControlStateNormal];
    
    self.dividerLine.backgroundColor = [UIColor ggp_gainsboroGray];
}

- (IBAction)registerButtonTapped:(id)sender {
    GGPAuthenticationController *authController = [GGPAuthenticationController authenticationControllerForRegistration];
    authController.authenticationDelegate = self;
    [self.presenterDelegate presentViewController:authController];
}

#pragma mark GGPAuthenticationDelegate

- (void)authenticationCompleted {
    [((GGPTabBarController *)self.tabBarController) reloadControllers];
}

@end
