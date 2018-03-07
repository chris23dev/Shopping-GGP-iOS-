//
//  GGPShoppingDetailViewController.m
//  GGP Malls
//
//  Created by Janet Lin on 1/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPButton.h"
#import "GGPFadedImageView.h"
#import "GGPFeedbackManager.h"
#import "GGPJMapManager.h"
#import "GGPLogoImageView.h"
#import "GGPMapImageViewController.h"
#import "GGPModalViewController.h"
#import "GGPNavigationTitleView.h"
#import "GGPShoppingDetailMapViewController.h"
#import "GGPShoppingDetailViewController.h"
#import "GGPTenantDetailViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface GGPShoppingDetailViewController ()

@property (weak, nonatomic) IBOutlet GGPFadedImageView *saleImageView;
@property (weak, nonatomic) IBOutlet GGPLogoImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *saleTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *dateContainer;
@property (weak, nonatomic) IBOutlet UIView *locationContainer;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet GGPButton *locationButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *mapHeaderLabel;
@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageHeightConstraint;
@property (strong, nonatomic) UINavigationController *localNavigationController;

@property (strong, nonatomic) GGPSale *sale;

@end

@implementation GGPShoppingDetailViewController

- (instancetype)initWithSale:(GGPSale *)sale {
    self = [super initWithNibName:@"GGPShoppingDetailViewController" bundle:nil];
    if (self) {
        self.sale = sale;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GGPFeedbackManager trackAction];
    [self configureControls];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
    self.tabBarController.tabBar.hidden = YES;
    
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenSalesDetail withTenant:self.sale.tenant.name];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.localNavigationController ggp_configureAsTransparent:NO];
    [self.localNavigationController ggp_configureWithLightText];
    self.localNavigationController = nil;
    self.tabBarController.tabBar.hidden = NO;
    
    [super viewWillDisappear:animated];
}

- (void)configureControls {
    [self configureSaleTitle];
    [self configureDate];
    [self configureLocation];
    [self configureDescriptionText];
    [self configureImages];
    [self configureShareButton];
    [self configureMap];
}

- (void)configureNavigationBar {
    self.localNavigationController = self.navigationController;
    [self.navigationController ggp_configureWithDarkText];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.title = [@"SHOPPING_SALE_DETAILS_TITLE" ggp_toLocalized];
}

- (void)configureImages {
    if (self.sale.imageUrl) {
        [self.saleImageView configureWithImageUrl:self.sale.imageUrl];
    } else {
        [self.saleImageView ggp_collapseVertically];
    }
    
    [self.logoImageView setImageWithURL:self.sale.tenant.tenantLogoUrl defaultName:self.sale.tenant.name font:[UIFont ggp_regularWithSize:22] andCompletion:^(UIImage *image) {
        self.logoImageView.image = image;
        self.logoImageHeightConstraint.constant = (self.logoImageView.frame.size.width * image.size.height) / image.size.width;
    }];
}

- (void)configureSaleTitle {
    self.saleTitleLabel.text = self.sale.title;
    self.saleTitleLabel.numberOfLines = 0;
    self.saleTitleLabel.font = [UIFont ggp_boldWithSize:16];
    self.saleTitleLabel.textColor = [UIColor blackColor];
}

- (void)configureDate {
    self.dateLabel.text = self.sale.promotionDates;
    self.dateLabel.font = [UIFont ggp_lightWithSize:13];
    self.dateLabel.textColor = [UIColor ggp_darkGray];
}

- (void)configureLocation {
    [self.locationButton setTitle:self.sale.tenantName forState:UIControlStateNormal];
    self.locationButton.titleLabel.font = [UIFont ggp_mediumWithSize:14];
    self.locationButton.titleLabel.numberOfLines = 0;
    [self.locationButton setTitleColor:[UIColor ggp_blue] forState:UIControlStateNormal];
}

- (void)configureDescriptionText {
    self.descriptionTextView.editable = NO;
    self.descriptionTextView.scrollEnabled = NO;
    self.descriptionTextView.textContainer.lineFragmentPadding = 0;
    self.descriptionTextView.textContainerInset = UIEdgeInsetsZero;
    self.descriptionTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    if (self.sale.saleDescription) {
        NSDictionary *attribs = @{
                                  NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                  NSForegroundColorAttributeName: [UIColor darkGrayColor],
                                  NSFontAttributeName: [UIFont ggp_lightWithSize:14]
                                  };
        
        NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithData:[self.sale.saleDescription dataUsingEncoding:NSUnicodeStringEncoding] options:attribs documentAttributes:nil error:nil];
        [description addAttributes:attribs range:NSMakeRange(0, [description length])];
        self.descriptionTextView.attributedText = description;
        [self.descriptionTextView sizeToFit];
        
    } else {
        [self.descriptionTextView ggp_collapseVertically];
    }
}

- (void)configureMap {
    self.mapHeaderLabel.font = [UIFont ggp_regularWithSize:15];
    self.mapHeaderLabel.textColor = [UIColor ggp_darkGray];
    self.mapHeaderLabel.text = [[GGPJMapManager shared].mapViewController locationDescriptionForTenant:self.sale.tenant];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapContainerTapped)];
    self.mapContainer.userInteractionEnabled = YES;
    [self.mapContainer addGestureRecognizer:tapRecognizer];
    
    [self ggp_addChildViewController:[[GGPMapImageViewController alloc] initWithTenant:self.sale.tenant] toPlaceholderView:self.mapContainer];
}

- (void)configureShareButton {
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonTapped)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void)shareButtonTapped {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.sale] applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
}

- (void)mapContainerTapped {
    GGPShoppingDetailMapViewController *mapController = [[GGPShoppingDetailMapViewController alloc] initWithTenant:self.sale.tenant];
    
    GGPModalViewController *modal = [[GGPModalViewController alloc] initWithRootViewController:mapController andOnClose:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:modal animated:YES completion:nil];
}

- (IBAction)locationButtonTapped:(id)sender {
    [self.navigationController pushViewController:[[GGPTenantDetailViewController alloc] initWithTenantDetails:self.sale.tenant] animated:YES];
}

@end
