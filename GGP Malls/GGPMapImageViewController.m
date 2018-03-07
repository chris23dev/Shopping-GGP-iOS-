//
//  GGPMapImageViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJmapViewController+Highlighting.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPMapImageViewController.h"
#import "GGPTenant.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPMapImageViewController ()
@property (strong, nonatomic) GGPTenant *tenant;
@end

@implementation GGPMapImageViewController

- (instancetype)initWithTenant:(GGPTenant *)tenant {
    self = [super init];
    if (self) {
        self.tenant = tenant;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.hidden = YES;
    
    [GGPJMapManager shared].mapViewController.view.userInteractionEnabled = NO;
    if (self.tenant) {
        [[GGPJMapManager shared].mapViewController highlightTenants:@[self.tenant]];
    }
    [[GGPJMapManager shared].mapViewController removeDetailCard];
    
    [self ggp_addChildViewController:[GGPJMapManager shared].mapViewController toPlaceholderView:self.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [GGPJMapManager shared].mapViewController.showLevelButtons = NO;
    [[GGPJMapManager shared].mapViewController zoomToTenant:self.tenant withIcons:YES];
    [self.view ggp_addInnerShadowWithRadius:3 andOpacity:0.5];
    self.view.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [GGPJMapManager shared].mapViewController.view.userInteractionEnabled = YES;
    [[GGPJMapManager shared].mapViewController clearHighlightedDestinations];
    [GGPJMapManager shared].mapViewController.showLevelButtons = YES;
    [[GGPJMapManager shared].mapViewController ggp_removeFromParentViewController];
}

@end
