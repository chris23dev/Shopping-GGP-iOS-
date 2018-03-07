//
//  GGPNowOpenViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPNowOpenViewController.h"
#import "GGPTenant.h"
#import "GGPTenantCardCollectionViewController.h"
#import "GGPTenantDetailViewController.h"
#import "GGPWayfindingViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPNowOpenViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nowOpenLabel;
@property (weak, nonatomic) IBOutlet UIView *collectionViewContainer;

@property (strong, nonatomic) NSArray *tenants;
@property (strong, nonatomic) GGPTenantCardCollectionViewController *collectionViewController;

@end

@implementation GGPNowOpenViewController

- (instancetype)initWithTenants:(NSArray *)tenants {
    self = [super init];
    if (self) {
        self.tenants = tenants;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self configureWithTenants:self.tenants];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleJmapDataReady) name:GGPJMapDataReadyNotification object:nil];
}

- (void)handleJmapDataReady {
    [self configureWithTenants:self.tenants];
}

- (void)configureControls {
    self.view.backgroundColor = [UIColor ggp_gainsboroGray];
    
    self.nowOpenLabel.text = [@"HOME_NOW_OPEN" ggp_toLocalized];
    self.nowOpenLabel.textColor = [UIColor ggp_darkGray];
    self.nowOpenLabel.font = [UIFont ggp_regularWithSize:14];
}

- (void)configureWithTenants:(NSArray *)tenants {
    self.tenants = tenants;
    
    if (!self.collectionViewController) {
        self.collectionViewController = [GGPTenantCardCollectionViewController new];
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.collectionViewController.onCardSelected = ^(NSInteger index) {
        GGPTenant *tenant = weakSelf.tenants[index];
        GGPTenantDetailViewController *tenantDetailViewController = [[GGPTenantDetailViewController alloc] initWithTenantDetails:tenant];
        [weakSelf.presenterDelegate pushViewController:tenantDetailViewController];
    };
    
    self.collectionViewController.onWayfindingTapped = ^(GGPTenant *tenant) {
        [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantGuideMe withData:nil andTenant:tenant.name];
        
        GGPWayfindingViewController *wayfindingController = [[GGPWayfindingViewController alloc]
                                                             initWithTenant:tenant];
        [weakSelf.presenterDelegate pushViewController:wayfindingController];
    };
    
    [self ggp_addChildViewController:self.collectionViewController
                   toPlaceholderView:self.collectionViewContainer];
    
    [self.collectionViewController configureWithData:self.tenants];
}

@end
