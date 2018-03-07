//
//  GGPTenantDetailRibbonCollectionViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPAuthenticationController.h"
#import "GGPFeedbackManager.h"
#import "GGPJMapManager.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPTenant.h"
#import "GGPTenantDetailRibbonCell.h"
#import "GGPTenantDetailRibbonCellData.h"
#import "GGPTenantDetailRibbonCollectionViewController.h"
#import "GGPUser.h"
#import "GGPWayfindingViewController.h"
#import "NSString+GGPAdditions.h"

@interface GGPTenantDetailRibbonCollectionViewController () <GGPAuthenticationDelegate>

@property (strong, nonatomic) GGPTenant *tenant;
@property (strong, nonatomic) NSMutableArray *cells;
@property (strong, nonatomic) GGPTenantDetailRibbonCellData *favoriteCellData;

@end

@implementation GGPTenantDetailRibbonCollectionViewController

- (instancetype)initWithTenant:(GGPTenant *)tenant {
    self = [super initWithCollectionViewLayout:[self createFlowLayout]];
    if (self) {
        self.tenant = tenant;
    }
    return self;
}

- (UICollectionViewFlowLayout *)createFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    return flowLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionView];
    [self configureCellData];
    [self registerCell];
}

- (void)configureCollectionView {
    self.collectionView.scrollEnabled = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)registerCell {
    UINib *ribbonCell = [UINib nibWithNibName:@"GGPTenantDetailRibbonCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:ribbonCell forCellWithReuseIdentifier:GGPTenantDetailRibbonCellReuseIdentifier];
}

- (BOOL)shouldShowCallItem {
    return self.tenant.phoneNumber.length > 0;
}

- (BOOL)shouldShowFavoriteItem {
    return self.tenant.placeWiseRetailerId > 0;
}

- (BOOL)shouldShowOpenTableItem {
    return self.tenant.openTableId > 0;
}

- (void)configureCellData {
    self.cells = [NSMutableArray new];
    [self configureCallItem];
    [self configureOpenTableItem];
    [self configureFavoriteItem];
    [self configureGuideMeItem];
}

- (void)configureCallItem {
    __weak typeof(self) weakSelf = self;
    
    if ([self shouldShowCallItem]) {
        GGPTenantDetailRibbonCellData *cellData = [[GGPTenantDetailRibbonCellData alloc] initWithTitle:[@"DETAILS_CALL_LABEL" ggp_toLocalized] image:[UIImage imageNamed:@"ggp_icon_white_phone"] andTapHandler:^{
            [weakSelf callTapped];
        }];
        [self.cells addObject:cellData];
    }
}

- (void)configureOpenTableItem {
    __weak typeof(self) weakSelf = self;
    
    if ([self shouldShowOpenTableItem]) {
        GGPTenantDetailRibbonCellData *cellData = [[GGPTenantDetailRibbonCellData alloc] initWithTitle:[@"DETAILS_OPEN_TABLE_LABEL" ggp_toLocalized] image:[UIImage imageNamed:@"ggp_icon_opentable"] andTapHandler:^{
            [weakSelf openTableTapped];
        }];
        [self.cells addObject:cellData];
    }
}

- (void)configureFavoriteItem {
    if ([self shouldShowFavoriteItem]) {
        UIImage *heartImage = self.tenant.isFavorite ? [UIImage imageNamed:@"ggp_tenant_heart_red"] : [UIImage imageNamed:@"ggp_tenant_heart_white"];
        self.favoriteCellData = [[GGPTenantDetailRibbonCellData alloc] initWithTitle:[@"DETAILS_FAVORITE_LABEL" ggp_toLocalized] image:heartImage andTapHandler:^{
            [self favoriteTapped];
        }];
        [self.cells addObject:self.favoriteCellData];
    }
}

- (void)configureGuideMeItem {
    if ([[GGPJMapManager shared] wayfindingAvailableForTenant:self.tenant]) {
        __weak typeof(self) weakSelf = self;
        GGPTenantDetailRibbonCellData *cellData = [[GGPTenantDetailRibbonCellData alloc] initWithTitle:[@"DETAILS_GUIDE_ME_LABEL" ggp_toLocalized] image:[UIImage imageNamed:@"ggp_icon_guide_me"] andTapHandler:^{
            [weakSelf guideMeTapped];
        }];
        [self.cells addObject:cellData];
    }
}

- (void)callTapped {
    NSDictionary *data = @{ GGPAnalyticsContextDataTenantPhoneNumber : self.tenant.phoneNumber };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantCall withData:data andTenant:self.tenant.name];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",self.tenant.phoneNumber]]];
}

- (void)guideMeTapped {
    [self.navigationController pushViewController:[[GGPWayfindingViewController alloc] initWithTenant:self.tenant] animated:YES];
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantGuideMe withData:nil andTenant:self.tenant.name];
}

- (void)openTableTapped {
    NSDictionary *data = @{ GGPAnalyticsContextDataTenantName : self.tenant.name };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantOpenTable withData:data];
    [[UIApplication sharedApplication] openURL:[self.tenant openTableUrl]];
}

- (void)favoriteTapped {
    if ([GGPAccount isLoggedIn]) {
        [self handleAuthenticatedFavoriteTapped];
    } else {
        [self handleUnauthenticatedFavoriteTapped];
    }
}

- (void)handleAuthenticatedFavoriteTapped {
    [[GGPAccount shared].currentUser toggleFavorite:self.tenant];
    
    NSString *imageName = self.tenant.isFavorite ? @"ggp_tenant_heart_red" : @"ggp_tenant_heart_white";
    self.favoriteCellData.image = [UIImage imageNamed:imageName];

    [self.collectionView reloadData];
    [self trackFavoriteTap];
    [GGPFeedbackManager trackAction];
}

- (void)handleUnauthenticatedFavoriteTapped {
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantRegister withData:nil andTenant:self.tenant.name];
    
    GGPAuthenticationController *authController = [GGPAuthenticationController authenticationControllerForRegistration];
    authController.authenticationDelegate = self;
    [self presentViewController:authController animated:YES completion:nil];
}

- (void)trackFavoriteTap {
    NSString *favoriteStatus = self.tenant.isFavorite ? GGPAnalyticsContextDataTenantFavoriteStatusFavorite : GGPAnalyticsContextDataTenantFavoriteStatusUnFavorite;
    NSDictionary *data = @{ GGPAnalyticsContextDataTenantFavoriteStatus : favoriteStatus };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantFavoriteTap withData:data andTenant:self.tenant.name];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cells.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGPTenantDetailRibbonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGPTenantDetailRibbonCellReuseIdentifier forIndexPath:indexPath];
    GGPTenantDetailRibbonCellData *cellData = self.cells[indexPath.row];
    BOOL isLastCell = self.cells.count - 1 == indexPath.row;
    [cell configureCellWithCellData:cellData isLastCell:isLastCell];
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGFloat)widthForCell {
    return self.collectionView.frame.size.width / self.cells.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self widthForCell], GGPTenantDetailRibbonCellHeight);
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GGPTenantDetailRibbonCellData *cellData = self.cells[indexPath.row];
    if (cellData.tapHandler) {
        cellData.tapHandler();
    }
}

#pragma mark GGPAuthenticationDelegate 

- (void)authenticationCompleted {
    if (!self.tenant.isFavorite) {
        [[GGPAccount shared].currentUser toggleFavorite:self.tenant];
    }
    self.favoriteCellData.image = [UIImage imageNamed:@"ggp_tenant_heart_red"];
    [self.collectionView reloadData];
}

@end
