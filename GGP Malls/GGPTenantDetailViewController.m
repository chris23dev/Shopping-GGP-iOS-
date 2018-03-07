//
//  GGPTenantDetailViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 2/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAnalytics.h"
#import "GGPCategory.h"
#import "GGPChildTenantsTableViewController.h"
#import "GGPEvent.h"
#import "GGPEventDetailViewController.h"
#import "GGPFadedLabel.h"
#import "GGPFeedbackManager.h"
#import "GGPHours.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPLogoImageView.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPMapImageViewController.h"
#import "GGPModalViewController.h"
#import "GGPProduct.h"
#import "GGPShoppingDetailViewController.h"
#import "GGPTenant.h"
#import "GGPTenantDetailMapViewController.h"
#import "GGPTenantDetailProductsDelegate.h"
#import "GGPTenantDetailProductsViewController.h"
#import "GGPTenantDetailRibbonCollectionViewController.h"
#import "GGPTenantDetailViewController.h"
#import "GGPTenantPromotionsTableViewController.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIImage+GGPAdditions.h"
#import "UILabel+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UITableView+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import "UIViewController+GGPDirections.h"

static NSInteger const kNumberOfLinesForDescription = 3;
static double const kDefaultRibbonContainerHeight = 10;

@interface GGPTenantDetailViewController () <GGPTenantPromotionsTableViewDelegate, GGPFadedLabelDelegate, UITextViewDelegate, GGPTenantDetailProductsDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *promotionsContainer;
@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (weak, nonatomic) IBOutlet GGPLogoImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ribbonContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *ribbonContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promotionsContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *nowOpenContainer;
@property (weak, nonatomic) IBOutlet UILabel *nowOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *descriptionContainer;
@property (weak, nonatomic) IBOutlet GGPFadedLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionContainerViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursHeaderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hoursContainerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *hoursContainer;
@property (weak, nonatomic) IBOutlet UIImageView *hoursDownArrowImageView;

@property (weak, nonatomic) IBOutlet UIView *websiteContainer;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;

@property (weak, nonatomic) IBOutlet UIView *locationContainer;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIView *directionsContainer;
@property (weak, nonatomic) IBOutlet UITextView *directionsTextView;

@property (weak, nonatomic) IBOutlet UIView *productsContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productsContainerHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *childTenantsContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *childTenantsContainerHeightConstraint;

@property (strong, nonatomic) UINavigationController *localNavigationController;
@property (strong, nonatomic) GGPTenant *tenant;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSArray *sales;
@property (strong, nonatomic) GGPTenantPromotionsTableViewController *promotionsTableViewController;
@property (strong, nonatomic) GGPChildTenantsTableViewController *childTenantsTableViewController;

@end

@implementation GGPTenantDetailViewController

- (instancetype)initWithTenantDetails:(GGPTenant *)tenant {
    self = [super initWithNibName:@"GGPTenantDetailViewController" bundle:nil];
    if (self) {
        self.tenant = tenant;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [GGPFeedbackManager trackAction];
    
    if (self.tenant.parentTenant) {
        [self trackStoreInStoreTenant:self.tenant.name];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.scrollView.contentInset = UIEdgeInsetsZero;
    
    self.localNavigationController = self.navigationController;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController ggp_configureWithDarkText];
    self.tabBarController.tabBar.hidden = YES;
    
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenTenantDetail withTenant:self.tenant.name];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.localNavigationController ggp_configureWithLightText];
    self.localNavigationController = nil;
    
    self.tabBarController.tabBar.hidden = NO;
    
    [super viewWillDisappear:animated];
}

- (void)configureControls {
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = [@"DETAILS_TITLE" ggp_toLocalized];
    
    [self configureHeader];
    [self configureRibbon];
    [self fetchPromotionData];
    [self configureDescriptionText];
    [self configureHours];
    [self configureWebsite];
    [self configureProducts];
    [self configureChildTenants];
    
    if (self.tenant.parentTenant) {
        [self configureLocationForParentTenant:self.tenant.parentTenant];
        [self configureDirectionsForTenant:self.tenant.parentTenant];
        [self configureMapForTenant:self.tenant.parentTenant];
    } else {
        [self configureLocation];
        [self configureDirectionsForTenant:self.tenant];
        [self configureMapForTenant:self.tenant];
    }
}

- (void)configureHeader {
    [self.logoImageView setImageWithURL:self.tenant.tenantLogoUrl defaultName:self.tenant.name];
    self.nowOpenLabel.text = [@"DETAILS_NOW_OPEN" ggp_toLocalized];
    self.nowOpenLabel.textColor = [UIColor whiteColor];
    self.nowOpenLabel.font = [UIFont ggp_mediumWithSize:12];
    self.nowOpenContainer.backgroundColor = [UIColor ggp_gray];
    
    if (![self shouldShowNowOpen]) {
        [self.nowOpenContainer ggp_collapseVertically];
    }
    
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.text = self.tenant.displayName;
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont ggp_boldWithSize:16];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    
    self.categoryLabel.text = [self.tenant prettyPrintCategories];
    self.categoryLabel.textColor = [UIColor grayColor];
    self.categoryLabel.font = [UIFont ggp_lightItalicWithSize:14];
}

- (void)configureRibbon {
    if ([self shouldShowRibbon]) {
        [self ggp_addChildViewController:[[GGPTenantDetailRibbonCollectionViewController alloc] initWithTenant:self.tenant] toPlaceholderView:self.ribbonContainer];
    } else {
        self.ribbonContainerHeightConstraint.constant = kDefaultRibbonContainerHeight;
    }
}

- (BOOL)shouldShowRibbon {
    return self.tenant.phoneNumber.length ||
        self.tenant.openTableId ||
        self.tenant.placeWiseRetailerId ||
        [[GGPJMapManager shared] wayfindingAvailableForTenant:self.tenant];
}

- (void)configureDescriptionText {
    self.descriptionLabel.userInteractionEnabled = YES;
    self.descriptionLabel.labelDelegate = self;
    
    if (self.tenant.tenantDescription) {
        NSDictionary *attribs = @{
                                  NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                  NSForegroundColorAttributeName: [UIColor blackColor],
                                  NSFontAttributeName: [UIFont ggp_lightWithSize:14]
                                  };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithData:[self.tenant.tenantDescription dataUsingEncoding:NSUnicodeStringEncoding] options:attribs documentAttributes:nil error:nil];
            [description addAttributes:attribs range:NSMakeRange(0, [description length])];
            self.descriptionLabel.attributedText = description;
            self.descriptionLabel.numberOfLines = kNumberOfLinesForDescription;
            [self.descriptionLabel sizeToFit];
            CGFloat contentHeightForNumberOfLines = self.descriptionLabel.frame.size.height;
            self.descriptionContainerViewHeightConstraint.constant = contentHeightForNumberOfLines;
            
            if ([self.descriptionLabel ggp_lineCount] > kNumberOfLinesForDescription) {
                [self.descriptionLabel addWhiteFadeAtBottomYOffset:contentHeightForNumberOfLines];
                self.descriptionLabel.numberOfLines = 0;
            }
        });
    } else {
        [self.descriptionContainer ggp_collapseVertically];
    }
}

- (void)fadedLabelTapped:(GGPFadedLabel *)label {
    [UIView animateWithDuration:0.5 animations:^{
        self.descriptionContainerViewHeightConstraint.constant = [self.descriptionLabel ggp_contentHeight];
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)shouldShowNowOpen {
    return [self.tenant.categories ggp_anyWithFilter:^BOOL(GGPCategory *category) {
        return [category.code isEqualToString:GGPCategoryTenantOpeningsCode];
    }];
}

- (void)configureHours {
    if (!self.tenant.temporarilyClosed && self.tenant.operatingHours.count > 0) {
        [self configureHoursHeader];
        [self configureHoursWeekly];
        [self determineHoursTapGesture];
    } else {
        [self.hoursContainer ggp_collapseVertically];
    }
}

- (void)configureHoursHeader {
    NSDictionary *attribs = @{ NSFontAttributeName: [UIFont ggp_regularWithSize:14] };
    
    NSMutableAttributedString *hoursHeader = [[NSMutableAttributedString alloc] initWithString:self.tenant.formattedHoursHeader attributes:attribs];
    
    NSInteger headerLength = self.tenant.hasHoursForToday ? [@"DETAILS_HOURS_HEADER_TODAY" ggp_toLocalized].length : [@"DETAILS_HOURS_HEADER_STORE" ggp_toLocalized].length;
    
    [hoursHeader addAttribute:NSForegroundColorAttributeName
                        value:[UIColor blackColor]
                        range:NSMakeRange(0, headerLength)];
    
    [hoursHeader addAttribute:NSForegroundColorAttributeName
                        value:[UIColor ggp_blue]
                        range:NSMakeRange(headerLength, hoursHeader.length - headerLength)];
    
    [self addParagraphStyleAttributeForHours:hoursHeader];
    
    self.hoursHeaderLabel.numberOfLines = 0;
    self.hoursHeaderLabel.attributedText = hoursHeader;
}

- (void)configureHoursWeekly {
    self.hoursLabel.numberOfLines = 0;
    NSDictionary *attribs = @{ NSFontAttributeName: [UIFont ggp_lightWithSize:14] };
    
    NSMutableAttributedString *hours = [[NSMutableAttributedString alloc] initWithString:[self.tenant formattedWeeklyHours] attributes:attribs];
    [self addParagraphStyleAttributeForHours:hours];
    
    self.hoursLabel.attributedText = hours;
}

- (void)updateHoursHeader {
    NSDictionary *attribs = @{ NSForegroundColorAttributeName: [UIColor blackColor],
                               NSFontAttributeName: [UIFont ggp_regularWithSize:14] };
    NSMutableAttributedString *hoursHeader = [[NSMutableAttributedString alloc] initWithString:self.tenant.formattedHoursHeader attributes:attribs];
    [self addParagraphStyleAttributeForHours:hoursHeader];
    
    self.hoursHeaderLabel.attributedText = hoursHeader;
}

- (void)addParagraphStyleAttributeForHours:(NSMutableAttributedString *)hours {
    NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle new];
    pStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:100 options:@{}]];
    [hours addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, hours.length)];
}

- (void)determineHoursTapGesture {
    if ([self.hoursLabel ggp_lineCount] > 0) {
        self.hoursHeaderLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hoursLabelTapped)];
        [self.hoursHeaderLabel addGestureRecognizer:gestureRecognizer];
    }
}

- (void)hoursLabelTapped {
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantHours withData:nil andTenant:self.tenant.name];
    
    [self updateHoursHeader];
    self.hoursDownArrowImageView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.hoursContainerViewHeightConstraint.constant = self.hoursHeaderLabel.frame.size.height + [self.hoursLabel ggp_contentHeight];
        [self.view layoutIfNeeded];
    }];
}

- (void)configureWebsite {
    if (self.tenant.websiteUrl.length) {
        self.websiteButton.titleLabel.font = [UIFont ggp_regularWithSize:14];
        [self.websiteButton setTitleColor:[UIColor ggp_blue] forState:UIControlStateNormal];
        [self.websiteButton setTitle:[self prettyPrintWesbite:self.tenant.websiteUrl] forState:UIControlStateNormal];
        
    } else {
        [self.websiteContainer ggp_collapseVertically];
    }
}

- (NSString *)prettyPrintWesbite:(NSString *)website {
    NSString *hostName = [NSURL URLWithString:website].host;
    return [hostName stringByReplacingOccurrencesOfString:@"www." withString:@""];
}

- (void)configureLocation {
    NSString *location = [[GGPJMapManager shared].mapViewController locationDescriptionForTenant:self.tenant];
    if (location.length) {
        self.locationLabel.text = location;
        self.locationLabel.textColor = [UIColor blackColor];
        self.locationLabel.font = [UIFont ggp_regularWithSize:14];
    } else {
        [self.locationContainer ggp_collapseVertically];
    }
}

- (void)configureLocationForParentTenant:(GGPTenant *)parentTenant {
    self.locationLabel.attributedText = [self attributedStringForLocationWithParentTenant:parentTenant];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(parentLocationTapped)];
    [self.locationLabel addGestureRecognizer:tap];
    self.locationLabel.userInteractionEnabled = YES;
}

- (NSAttributedString *)attributedStringForLocationWithParentTenant:(GGPTenant *)parentTenant {
    NSString *inside = [@"WAYFINDING_INSIDE" ggp_toLocalized];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", inside, parentTenant.name]];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont ggp_regularWithSize:14] range:NSMakeRange(0, attributedString.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor ggp_blue] range:NSMakeRange(inside.length, attributedString.length - inside.length)];
    
    return attributedString;
}

- (void)configureTextViewForAttributedString {
    self.directionsTextView.delegate = self;
    self.directionsTextView.editable = NO;
    self.directionsTextView.scrollEnabled = NO;
    self.directionsTextView.backgroundColor = [UIColor clearColor];
    self.directionsTextView.textContainer.lineFragmentPadding = 0;
    self.directionsTextView.textContainerInset = UIEdgeInsetsZero;
    self.directionsTextView.linkTextAttributes = @{ NSForegroundColorAttributeName: [UIColor ggp_blue],
                                                    NSFontAttributeName: [UIFont ggp_regularWithSize:14] };
}

- (void)configureDirectionsForTenant:(GGPTenant *)tenant {
    GGPMall *selectedMall = [GGPMallManager shared].selectedMall;
    if (selectedMall.config.parkingAvailable) {
        [self configureTextViewForAttributedString];
        NSAttributedString *directionsString = [self ggp_attributedDirectionsStringForTenant:tenant];
        self.directionsTextView.attributedText = directionsString;
        [self.directionsTextView sizeToFit];
    } else {
        [self.directionsContainer ggp_collapseVertically];
    }
}

- (void)configureDirectionsForParentTenant:(GGPTenant *)parentTenant {
    GGPMall *selectedMall = [GGPMallManager shared].selectedMall;
    if (selectedMall.config.parkingAvailable) {
        [self configureTextViewForAttributedString];
        NSAttributedString *directionsString = [self ggp_attributedDirectionsStringForTenant:self.tenant];
        self.directionsTextView.attributedText = directionsString;
        [self.directionsTextView sizeToFit];
    } else {
        [self.directionsContainer ggp_collapseVertically];
    }
}

- (void)fetchPromotionData {
    dispatch_group_t group = dispatch_group_create();
    
    [self fetchEventsWithGroup:(dispatch_group_t)group];
    [self fetchSalesWithGroup:(dispatch_group_t)group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self configurePromotionsViewController];
    });
}

- (void)fetchEventsWithGroup:(dispatch_group_t)group {
    dispatch_group_enter(group);
    [GGPMallRepository fetchEventsWithCompletion:^(NSArray *events) {
        self.events = [self filterEvents:events];
        dispatch_group_leave(group);
    }];
}

- (void)fetchSalesWithGroup:(dispatch_group_t)group {
    dispatch_group_enter(group);
    [GGPMallRepository fetchSalesForTenantId:self.tenant.tenantId withCompletion:^(NSArray *sales) {
        self.sales = sales;
        dispatch_group_leave(group);
    }];
}

- (NSArray *)filterEvents:(NSArray *)events {
    return [events ggp_arrayWithFilter:^BOOL(GGPEvent *event) {
        return event.tenantId == self.tenant.tenantId;
    }];
}

- (void)configureChildTenants {
    if (self.tenant.childTenants.count == 0) {
        [self.childTenantsContainerView ggp_collapseVertically];
        return;
    }
    
    self.childTenantsTableViewController = [GGPChildTenantsTableViewController new];
    [self.childTenantsTableViewController configureWithParentTenant:self.tenant];
    
    [self ggp_addChildViewController:self.childTenantsTableViewController
                   toPlaceholderView:self.childTenantsContainerView];
    
    self.childTenantsContainerHeightConstraint.constant = self.childTenantsTableViewController.tableView.contentSize.height;
}

- (void)configurePromotionsViewController {
    if (self.sales.count == 0) {
        [self.promotionsContainer ggp_collapseVertically];
        return;
    }
    
    self.promotionsTableViewController = [GGPTenantPromotionsTableViewController new];
    self.promotionsTableViewController.tenantPromotionsDelegate = self;
    [self.promotionsTableViewController configureWithSales:self.sales andEvents:self.events];
    [self ggp_addChildViewController:self.promotionsTableViewController
                   toPlaceholderView:self.promotionsContainer];
    self.promotionsContainerHeightConstraint.constant = self.promotionsTableViewController.tableView.contentSize.height;
}

- (void)configureMapForTenant:(GGPTenant *)tenant {
    if (![[GGPJMapManager shared] mapDestinationAvailableForTenant:tenant]) {
        [self.mapContainer ggp_collapseVertically];
        return;
    }
    
    self.mapContainer.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapContainerTapped)];
    [self.mapContainer addGestureRecognizer:tapRecognizer];
    
   
    [self ggp_addChildViewController:[[GGPMapImageViewController alloc] initWithTenant:tenant] toPlaceholderView:self.mapContainer];
}

- (void)configureProducts {
    NSArray *productsForTenant = [GGPProduct productsListFromTenants:@[ self.tenant ]];
    if (productsForTenant.count == 0) {
        [self.productsContainerView ggp_collapseVertically];
        return;
    }
    
    GGPTenantDetailProductsViewController *productsViewController = [[GGPTenantDetailProductsViewController alloc] initWithProducts:productsForTenant];
    productsViewController.productsDelegate = self;
    [self ggp_addChildViewController:productsViewController toPlaceholderView:self.productsContainerView];
}

- (void)mapContainerTapped {
    GGPTenant *tenant = self.tenant.parentTenant ? self.tenant.parentTenant : self.tenant;
    
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantMap withData:nil andTenant:tenant.name];
    
    GGPTenantDetailMapViewController *tenantMap = [[GGPTenantDetailMapViewController alloc] initWithTenant:tenant];
    
    GGPModalViewController *modal = [[GGPModalViewController alloc] initWithRootViewController:tenantMap andOnClose:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:modal animated:YES completion:nil];
}

- (void)parentLocationTapped {
    if (self.tenant.parentTenant) {
        GGPTenantDetailViewController *tenantDetailViewController = [[GGPTenantDetailViewController alloc] initWithTenantDetails:self.tenant.parentTenant];
        [self.navigationController pushViewController:tenantDetailViewController animated:YES];
    }
}

#pragma mark Analytics

- (void)trackStoreInStoreTenant:(NSString *)tenantName {
    NSDictionary *data = @{ GGPAnalyticsContextDataTenantName : tenantName };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantStoreInStore withData:data];
}

- (void)trackDirectionsForTenantName:(NSString *)tenantName {
    NSDictionary *data = @{ GGPAnalyticsContextDataTenantName : tenantName };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantGetDirections withData:data];
}

#pragma mark - IB Actions

- (IBAction)websiteButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.tenant.websiteUrl]];
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTenantWebsite withData:nil andTenant:self.tenant.name];
}

#pragma mark - GGPTenantDetailProductsDelegate

- (void)didExpandProductsWithHeight:(CGFloat)height {
    self.productsContainerHeightConstraint.constant = height;
    [self.view layoutIfNeeded];
    CGRect rect = CGRectMake(self.productsContainerView.frame.origin.x,
                             self.productsContainerView.frame.origin.y + 10,
                             10,
                             10);
    [self.scrollView scrollRectToVisible:rect animated:YES];
}

#pragma mark - GGPTenantPromotionsTableViewDelegate

- (void)selectedPromotion:(GGPPromotion *)promotion {
    promotion.tenant = (GGPTenant *)self.tenant;
    if ([promotion isKindOfClass:GGPEvent.class]) {
        GGPEventDetailViewController *eventDetailViewController = [[GGPEventDetailViewController alloc] initWithEvent:(GGPEvent *)promotion];
        [self.navigationController pushViewController:eventDetailViewController animated:YES];
    } else {
        GGPShoppingDetailViewController *shoppingDetailViewController = [[GGPShoppingDetailViewController alloc] initWithSale:(GGPSale *)promotion];
        [self.navigationController pushViewController:shoppingDetailViewController animated:YES];
    }
}

- (BOOL)shouldShowTransitionNavBarForNameFrame:(CGRect)nameFrame andTransitionBarFrame:(CGRect)transitionBarFrame {
    return (nameFrame.origin.y + nameFrame.size.height) < (transitionBarFrame.origin.y + transitionBarFrame.size.height);
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    GGPTenant *tenant = self.tenant.parentTenant ? self.tenant.parentTenant : self.tenant;
    [self ggp_getDirectionsForTenant:tenant];
    [self trackDirectionsForTenantName:tenant.name];
    return NO;
}

@end
