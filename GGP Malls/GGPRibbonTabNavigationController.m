//
//  GGPRibbonTabNavigationController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCellData.h"
#import "GGPRibbonNavigationViewController.h"
#import "GGPRibbonTabNavigationController.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPRibbonTabNavigationController ()

@property (strong, nonatomic) GGPRibbonNavigationViewController *ribbonViewController;
@property (strong, nonatomic) UIViewController *activeViewController;
@property (strong, nonatomic) NSMutableArray *ribbonItems;

@end

@implementation GGPRibbonTabNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ribbonViewController = [GGPRibbonNavigationViewController new];
    self.ribbonItems = [NSMutableArray new];
    [self ggp_addChildViewController:self.ribbonViewController toPlaceholderView:self.ribbonContainer];
}

- (void)addRibbonController:(UIViewController *)controller withTapHandler:(void (^)())tapHandler {
    __weak typeof(self) weakSelf = self;
    [self.ribbonItems addObject:[[GGPCellData alloc] initWithTitle:controller.title andTapHandler:^{
        if (tapHandler) {
            weakSelf.activeViewController = controller;
            tapHandler();
        }
    }]];
    
    [self.ribbonViewController configureWithRibbonItems:self.ribbonItems];
    
    if (self.ribbonItems.count == 1) {
        self.activeViewController = controller;
    }
}

- (void)setRibbonControllers:(NSArray *)ribbonControllers {
    _ribbonControllers = ribbonControllers;
    
    self.ribbonItems = [NSMutableArray new];
    
    __weak typeof(self) weakSelf = self;
    for (UIViewController *controller in ribbonControllers) {
        [self.ribbonItems addObject:[[GGPCellData alloc] initWithTitle:controller.title andTapHandler:^{
            weakSelf.activeViewController = controller;
        }]];
    }
    
    [self.ribbonViewController configureWithRibbonItems:self.ribbonItems];
    self.activeViewController = ribbonControllers.firstObject;
}

- (void)setActiveViewController:(UIViewController *)activeViewController {
    [_activeViewController ggp_removeFromParentViewController];
    
    if (activeViewController) {
        [self ggp_addChildViewController:activeViewController toPlaceholderView:self.contentContainer];
    }
    
    _activeViewController = activeViewController;
}

@end
