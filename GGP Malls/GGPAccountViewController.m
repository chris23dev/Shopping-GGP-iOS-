//
//  GGPAccountViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAccountInfoViewController.h"
#import "GGPAccountPreferencesViewController.h"
#import "GGPAccountTableViewController.h"
#import "GGPAccountViewController.h"
#import "GGPCellData.h"
#import "GGPChangePasswordViewController.h"
#import "GGPFavoriteTenantsViewController.h"
#import "GGPLogoImageView.h"
#import "GGPModalViewController.h"
#import "GGPTabBarController.h"
#import "GGPUser.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPAccountViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *heroImageView;
@property (weak, nonatomic) IBOutlet GGPLogoImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewFavoritesButton;
@property (weak, nonatomic) IBOutlet UIView *accountItemTableContainer;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableContainerHeightConstraint;

@end

@implementation GGPAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    self.title = [@"USER_ACCOUNT_TITLE" ggp_toLocalized];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
    [self configureStateForUser:[GGPAccount shared].currentUser];
    self.tabBarController.tabBar.hidden = YES;
    
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenAccount];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)configureControls {
    [self configureHeroImage];
    [self configureAvatarImage];
    [self configureGreetingLabel];
    [self configureFavoritesButton];
    [self configureAccountItems];
    [self configureLogoutButton];
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithDarkText];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)configureHeroImage {
    self.heroImageView.image = [UIImage imageNamed:@"ggp_account_background"];
}

- (void)configureAvatarImage {
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.avatarImageView.clipsToBounds = YES;
    [self.avatarImageView ggp_addBorderRadius:self.avatarImageView.bounds.size.width / 2];
    [self.avatarImageView ggp_addBorderWithWidth:1 andColor:[UIColor whiteColor]];
}

- (void)configureGreetingLabel {
    self.greetingLabel.textColor = [UIColor whiteColor];
    self.greetingLabel.font = [UIFont ggp_mediumWithSize:24];
    [self.greetingLabel sizeToFit];
}

- (void)configureFavoritesButton {
    self.viewFavoritesButton.backgroundColor = [UIColor whiteColor];
    self.viewFavoritesButton.contentEdgeInsets = UIEdgeInsetsMake(8, 10, 8, 10);
    [self.viewFavoritesButton ggp_addBorderRadius:4];
    [self.viewFavoritesButton setTitleColor:[UIColor ggp_blue] forState:UIControlStateNormal];
    [self.viewFavoritesButton.titleLabel setFont:[UIFont ggp_mediumWithSize:14]];
    [self.viewFavoritesButton setTitle:[@"USER_ACCOUNT_MANAGE_FAVORITES" ggp_toLocalized]
                              forState:UIControlStateNormal];
    [self.viewFavoritesButton sizeToFit];
}

- (void)configureAccountItems {
    NSMutableArray *accountItems = [NSMutableArray new];
    GGPAccountTableViewController *tableViewController = [GGPAccountTableViewController new];
    self.accountItemTableContainer.backgroundColor = [UIColor clearColor];
    
    GGPCellData *myAccountItem = [[GGPCellData alloc] initWithTitle:[@"USER_ACCOUNT_MY_INFO" ggp_toLocalized] andTapHandler:^{
        [self myInfoTapped];
    }];
    [accountItems addObject:myAccountItem];
    
    GGPCellData *preferencesItem = [[GGPCellData alloc] initWithTitle:[@"USER_ACCOUNT_PREFERENCES" ggp_toLocalized] andTapHandler:^{
        [self preferencesTapped];
    }];
    [accountItems addObject:preferencesItem];
    
    if (![GGPAccount shared].currentUser.isSocialLogin) {
        GGPCellData *changePasswordItem = [[GGPCellData alloc] initWithTitle:[@"USER_ACCOUNT_CHANGE_PASSWORD" ggp_toLocalized] andTapHandler:^{
            [self changePasswordTapped];
        }];
        [accountItems addObject:changePasswordItem];
    }
    
    [self ggp_addChildViewController:tableViewController toPlaceholderView:self.accountItemTableContainer];
    [tableViewController configureWithAccountItems:accountItems];
    self.tableContainerHeightConstraint.constant = tableViewController.tableView.contentSize.height;
}

- (void)configureLogoutButton {
    self.logoutButton.backgroundColor = [UIColor clearColor];
    [self.logoutButton setTitle:[@"USER_ACCOUNT_LOGOUT" ggp_toLocalized] forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.logoutButton.titleLabel.font = [UIFont ggp_regularWithSize:16];
}

- (NSString *)firstCharacterOfName:(NSString *)firstName {
    return [[firstName substringToIndex:1] uppercaseString];
}

- (void)configureStateForUser:(GGPUser *)user {
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:user.photoURL] defaultName:[self firstCharacterOfName:user.firstName] andFont:[UIFont ggp_boldWithSize:40]];
    self.greetingLabel.text = [NSString stringWithFormat:[@"USER_ACCOUNT_GREETING" ggp_toLocalized], user.firstName];
}

#pragma mark - Tap handlers

- (IBAction)favoritesButtonTapped:(id)sender {
    GGPModalViewController *modalViewController = [[GGPModalViewController alloc] initWithRootViewController:[GGPFavoriteTenantsViewController new] andOnClose:^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
}

- (void)myInfoTapped {
    [self.navigationController pushViewController:[GGPAccountInfoViewController new] animated:YES];
}

- (void)preferencesTapped {
    [self.navigationController pushViewController:[GGPAccountPreferencesViewController new] animated:YES];
}

- (void)changePasswordTapped {
    [self.navigationController pushViewController:[GGPChangePasswordViewController new] animated:YES];
}

- (IBAction)logoutButtonTapped:(id)sender {
    [GGPAccount logoutWithCompletion:^(NSError *error) {
        [((GGPTabBarController *)self.tabBarController) reloadControllers];
        if (error) {
            GGPLogError(@"Logout call failed: %@", error.localizedDescription);
        }
    }];
}

@end
