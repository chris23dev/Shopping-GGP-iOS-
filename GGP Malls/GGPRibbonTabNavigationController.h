//
//  GGPTabNavigationController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPRibbonTabNavigationController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *ribbonContainer;
@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (strong, nonatomic) NSArray *ribbonControllers;

- (void)addRibbonController:(UIViewController *)controller withTapHandler:(void (^)())tapHandler;

@end
