//
//  GGPBenefitsPageViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBenefitsPageViewController.h"
#import "GGPBenefitsItemViewController.h"

@interface GGPBenefitsPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSArray *benefitItemControllers;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation GGPBenefitsPageViewController

- (instancetype)init {
    return [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
}

- (void)configureWithViewControllers:(NSArray *)controllers andPageControl:(UIPageControl *)pageControl {
    self.benefitItemControllers = controllers;
    [self setViewControllers:@[self.benefitItemControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageControl = pageControl;
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.benefitItemControllers.count;
}

#pragma mark UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger position = ((GGPBenefitsItemViewController *)viewController).position;
    
    if (position <= 0) {
        return nil;
    }
    
    return self.benefitItemControllers[position - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger position = ((GGPBenefitsItemViewController *)viewController).position;
    
    if (position >= self.benefitItemControllers.count - 1) {
        return nil;
    }
    
    return self.benefitItemControllers[position + 1];
}

#pragma mark UIPageViewController Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        GGPBenefitsItemViewController *controller = pageViewController.viewControllers.firstObject;
        if (controller) {
            self.pageControl.currentPage = controller.position;
        }
    }
}

@end
