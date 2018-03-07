//
//  GGPFilterSubCategoriesViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPFilterTableViewController;

@interface GGPFilterSubCategoriesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;

@property (strong, nonatomic) GGPFilterTableViewController *tableViewController;
@property (strong, nonatomic) NSArray *filterItems;
@property (assign, nonatomic) BOOL hasDisclaimerSection;

- (instancetype)initWithTitle:(NSString *)title andFilterItems:(NSArray *)filterItems hasDisclaimerSection:(BOOL)hasDisclaimerSection;

@end
