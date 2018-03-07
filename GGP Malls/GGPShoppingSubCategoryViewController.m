//
//  GGPShoppingSubCategoryViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/7/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPShoppingTableViewController.h"
#import "GGPShoppingSubCategoryViewController.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPShoppingSubCategoryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) GGPCategory *category;

@end

@implementation GGPShoppingSubCategoryViewController

- (instancetype)initWithCategory:(GGPCategory *)category {
    self = [super init];
    if (self) {
        self.category = category;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.attributedText = [self attributedStringForName];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryTapped)]];
}

- (NSAttributedString *)attributedStringForName {
    NSString *countString = [NSString stringWithFormat:@"(%ld)", (long)self.category.count];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", self.category.name.uppercaseString, countString]];
    
    NSDictionary *nameAttributes = @{ NSFontAttributeName: [UIFont ggp_boldWithSize:16],
                                      NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSDictionary *countAttributes = @{ NSFontAttributeName: [UIFont ggp_regularWithSize:16],
                                       NSForegroundColorAttributeName: [UIColor ggp_manateeGray] };
    
    [attributedString addAttributes:nameAttributes range:[attributedString.string rangeOfString:self.category.name.uppercaseString]];
    [attributedString addAttributes:countAttributes range:[attributedString.string rangeOfString:countString]];
    
    return attributedString;
}
     
- (void)categoryTapped {
    NSString *categoryName = self.category.name ? self.category.name : @"";
    NSDictionary *data = @{ GGPAnalyticsContextDataShoppingSubCategoryName: categoryName };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionShoppingSubCategory withData:data];
    
    GGPShoppingTableViewController *tableViewController = [[GGPShoppingTableViewController alloc] initWithCategory:self.category];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

@end
