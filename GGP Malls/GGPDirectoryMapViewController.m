//
//  GGPDirectoryMapViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPDirectoryMapViewController.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController+Zoom.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPDirectoryMapViewController ()

@end

@implementation GGPDirectoryMapViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = [@"DIRECTORY_MAP_TITLE" ggp_toLocalized];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self ggp_addChildViewController:[GGPJMapManager shared].mapViewController toPlaceholderView:self.view];
    [[GGPJMapManager shared].mapViewController zoomToMall];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GGPJMapManager shared].mapViewController ggp_removeFromParentViewController];
    
}

@end
