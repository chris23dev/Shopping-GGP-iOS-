//
//  GGPFilterCategoriesViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPTenant;
@class GGPFilterTableViewController;
@class GGPFilterSubCategoriesViewController;

@interface GGPFilterCategoriesViewController : UIViewController

- (instancetype)initWithTenants:(NSArray <GGPTenant *>*) tenants;

@property (weak, nonatomic) IBOutlet UIView *tableContainer;

@property (strong, nonatomic) GGPFilterTableViewController *tableViewController;
@property (strong, nonatomic) GGPFilterSubCategoriesViewController *subCategoryViewController;
@property (strong, nonatomic) NSArray *filterItems;

@end
