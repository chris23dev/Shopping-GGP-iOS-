//
//  GGPTenantTableCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAnalytics.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPMallManager.h"
#import "GGPLogoImageView.h"
#import "GGPTenant.h"
#import "GGPTenantTableCell.h"
#import "GGPUser.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIImage+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

NSString* const GGPTenantTableCellReuseIdentifier = @"GGPTenantTableCellReuseIdentifier";
CGFloat const GGPTenantTableCellHeight = 70;
CGFloat const kSwipeButtonWidth = 90;
CGFloat const kSwipeButtonIconWidthHeight = 25;

@interface GGPTenantTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet GGPLogoImageView *logoImageView;

@property (strong, nonatomic) MGSwipeButton *favoriteButton;
@property (strong, nonatomic) MGSwipeButton *guideMeButton;
@property (strong, nonatomic) GGPTenant *tenant;

@end

@implementation GGPTenantTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
    [self setupTextStyling];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFavoritesUpdated) name:GGPUserFavoritesUpdatedNotification object:nil];
}

- (void)configureControls {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.numberOfLines = 0;
    self.locationLabel.numberOfLines = 0;
}

- (void)configureCellWithTenant:(GGPTenant *)tenant {
    self.tenant = tenant;
    self.logoImageView.image = nil;
    [self.logoImageView cancelImageRequestOperation];
    
    self.titleLabel.text = tenant.displayName;
    [self.logoImageView setImageWithURL:tenant.tenantLogoUrl defaultName:tenant.name andFont:[UIFont ggp_mediumWithSize:10]];
    self.locationLabel.text = [self locationForTenant:tenant];
    
    [self configureSwipeButtonsForTenant:tenant];
}

- (NSString *)locationForTenant:(GGPTenant *)tenant {
    return tenant.parentTenant ?
        [NSString stringWithFormat:@"%@ %@", [@"WAYFINDING_INSIDE" ggp_toLocalized], tenant.parentTenant.name] :
        [[GGPJMapManager shared].mapViewController locationDescriptionForTenant:tenant];
}

- (void)setupTextStyling {
    [self.titleLabel setFont:[UIFont ggp_boldWithSize:15]];
    [self.locationLabel setFont:[UIFont ggp_lightWithSize:15]];
    self.locationLabel.textColor = [UIColor blackColor];
    self.titleLabel.textColor = [UIColor ggp_darkGray];
}

- (void)toggleFavoriteForTenant:(GGPTenant *)tenant {
    [self updateFavoriteIconWithIsFavorite:!tenant.isFavorite];
    [[GGPAccount shared].currentUser toggleFavorite:tenant];
}

- (void)userFavoritesUpdated {
    [self updateFavoriteIconWithIsFavorite:self.tenant.isFavorite];
}

- (void)updateFavoriteIconWithIsFavorite:(BOOL)isFavorite {
    NSString *imageName = [self imageNameForIsFavorite:isFavorite];
    [self.favoriteButton setImage:[self swipeButtonImageWithName:imageName] forState:UIControlStateNormal];
}

- (NSString *)imageNameForIsFavorite:(BOOL)isFavorite {
    return isFavorite ?
        @"ggp_choose_favorites_heart_active" :
        @"ggp_choose_favorites_heart_inactive";
}

#pragma mark MGSwipeTableCell methods

- (void)configureSwipeButtonsForTenant:(GGPTenant *)tenant {
    self.favoriteButton = nil;
    self.guideMeButton = nil;
    NSMutableArray *swipeButtons = [NSMutableArray new];
    
    if ([GGPAccount isLoggedIn]) {
        self.favoriteButton = [self favoriteSwipeButtonForTenant:tenant];
        [swipeButtons addObject:self.favoriteButton];
    }
    
    if ([[GGPJMapManager shared] wayfindingAvailableForTenant:tenant]) {
        self.guideMeButton = [self guideMeSwipeButtonForTenant:tenant];
        [swipeButtons addObject:self.guideMeButton];
    }
    
    self.rightButtons = swipeButtons;
    self.rightSwipeSettings.transition = MGSwipeTransitionStatic;
}

- (MGSwipeButton *)favoriteSwipeButtonForTenant:(GGPTenant *)tenant {
    NSString *title = [@"DIRECTORY_SWIPE_FAVORITE" ggp_toLocalized];
    NSString *imageName = [self imageNameForIsFavorite:tenant.isFavorite];
    
    return [self swipeButtonWithTitle:title imageName:imageName andCallback:^BOOL(MGSwipeTableCell *sender) {
        [self toggleFavoriteForTenant:tenant];
        return YES;
    }];
}

- (MGSwipeButton *)guideMeSwipeButtonForTenant:(GGPTenant *)tenant {
    NSString *title = [@"DIRECTORY_SWIPE_GUIDE_ME" ggp_toLocalized];
    NSString *imageName = @"ggp_icon_guide_me";
    
    return [self swipeButtonWithTitle:title imageName:imageName andCallback:^BOOL(MGSwipeTableCell *sender) {
        if (self.onGuideMeTapped) {
            self.onGuideMeTapped(self.tenant);
        }
        
        [self trackTenantGuideMe];
        
        return YES;
    }];
}

- (void)trackTenantGuideMe {
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantGuideMe withData:nil andTenant:self.tenant.name];
}

- (MGSwipeButton *)swipeButtonWithTitle:(NSString *)title imageName:(NSString *)imageName andCallback:(MGSwipeButtonCallback)callback {
    UIImage *icon = [self swipeButtonImageWithName:imageName];
    
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:title icon:icon backgroundColor:[UIColor ggp_blue] callback:callback];
    
    button.buttonWidth = kSwipeButtonWidth;
    button.titleLabel.font = [UIFont ggp_regularWithSize:12];
    [button centerIconOverText];
    
    return button;
}

- (UIImage *)swipeButtonImageWithName:(NSString *)imageName {
    return [UIImage ggp_imageWithImage:[UIImage imageNamed:imageName] scaledToSize:CGSizeMake(kSwipeButtonIconWidthHeight, kSwipeButtonIconWidthHeight)];
}

@end
