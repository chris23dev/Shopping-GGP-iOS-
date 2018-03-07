//
//  GGPEventDetailViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPButton.h"
#import "GGPEvent.h"
#import "GGPEventDetailMapViewController.h"
#import "GGPEventDetailViewController.h"
#import "GGPExternalEventLink.h"
#import "GGPFadedImageView.h"
#import "GGPJMapManager.h"
#import "GGPLogoImageView.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPNavigationTitleView.h"
#import "GGPTenant.h"
#import "GGPTenantDetailViewController.h"
#import "GGPMapImageViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

static NSInteger const kGrandCanalMallId = 1077;
static CGFloat const kDefaultImageTopPadding = 20;

@interface GGPEventDetailViewController ()

@property (weak, nonatomic) IBOutlet GGPFadedImageView *eventImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventImageViewTopMarginConstraint;
@property (weak, nonatomic) IBOutlet UIView *locationContainer;
@property (weak, nonatomic) IBOutlet GGPButton *locationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *dateContainer;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTeaserLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *primaryLinkButton;
@property (weak, nonatomic) IBOutlet UIButton *secondaryLinkButton;
@property (weak, nonatomic) IBOutlet UILabel *eventDetailHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapHeaderLabel;
@property (weak, nonatomic) IBOutlet UIView *mapContainer;

@property (strong, nonatomic) GGPEvent *event;

@end

@implementation GGPEventDetailViewController

- (instancetype)initWithEvent:(GGPEvent *)event {
    self = [super init];
    if (self) {
        self.event = event;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
    self.tabBarController.tabBar.hidden = YES;
    
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenEventDetails];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (BOOL)shouldEnableLocationButton {
    return self.event.tenant != nil;
}

- (void)configureControls {
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.eventNameLabel.text = self.event.title;
    self.eventNameLabel.font = [UIFont ggp_regularWithSize:18];
    self.eventNameLabel.textColor = [UIColor ggp_darkGray];
    self.eventNameLabel.numberOfLines = 0;
    
    self.dateLabel.text = self.event.promotionDates;
    self.dateLabel.font = [UIFont ggp_lightWithSize:13];
    self.dateLabel.textColor = [UIColor ggp_darkGray];
    
    self.eventDetailHeaderLabel.text = [@"EVENT_DETAIL_SECTION_HEADER" ggp_toLocalized];
    self.eventDetailHeaderLabel.textColor = [UIColor ggp_darkGray];
    self.eventDetailHeaderLabel.font = [UIFont ggp_regularWithSize:15];
    
    self.mapHeaderLabel.font = [UIFont ggp_regularWithSize:15];
    self.mapHeaderLabel.textColor = [UIColor ggp_darkGray];

    [self configureImage];
    [self configureLocation];
    [self configureDescriptionTeaser];
    [self configureDescriptionText];
    [self configureEventLinks];
    [self configureShareButton];
    [self configureTenantMap];
}

- (void)configureNavigationBar {
    self.title = [self shouldShowEntertainmentTitle] ? [@"EVENT_ENTERTAINMENT_TITLE" ggp_toLocalized] : [@"EVENT_DETAIL_TITLE" ggp_toLocalized];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController ggp_configureWithDarkText];
}

- (void)configureShareButton {
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonTapped)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void)configureImage {
    __weak typeof(self) weakSelf = self;
    if (self.event.eventImageUrl) {
        [self.eventImageView configureWithImageUrl:[NSURL URLWithString:self.event.eventImageUrl] andOnFailure:^{
            [weakSelf configureDefaultImage];
        }];
    } else {
        [self configureDefaultImage];
    }
}

- (void)configureDefaultImage {
    self.eventImageView.image = [UIImage imageNamed:@"ggp_calendar_large"];
    self.eventImageViewTopMarginConstraint.constant = kDefaultImageTopPadding;
}

- (void)configureLocation {
    NSString *locationTitle = self.event.tenant ? self.event.tenant.name : self.event.location;
    
    [self.locationButton setTitle:locationTitle forState:UIControlStateNormal];
    self.locationButton.titleLabel.font = self.event.tenant ? [UIFont ggp_mediumWithSize:14] : [UIFont ggp_lightWithSize:14];
    self.locationButton.titleLabel.numberOfLines = 0;
    self.locationButton.enabled = [self shouldEnableLocationButton];
    UIColor *locationButtonColor = [self shouldEnableLocationButton] ? [UIColor ggp_blue] : [UIColor ggp_darkGray];
    [self.locationButton setTitleColor:locationButtonColor forState:UIControlStateNormal];
    self.locationButtonHeightConstraint.constant = [self.locationButton sizeThatFits:CGSizeMake(self.locationButton.frame.size.width, MAXFLOAT)].height;
}

- (void)configureDescriptionTeaser {
    self.descriptionTeaserLabel.numberOfLines = 0;
    if (self.event.teaserDescription.length > 0) {
        NSDictionary *attribs = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                   NSForegroundColorAttributeName: [UIColor ggp_darkGray],
                                   NSFontAttributeName: [UIFont ggp_regularWithSize:15] };
        
        NSMutableAttributedString *teaserDescription = [[NSMutableAttributedString alloc] initWithData:[self.event.teaserDescription dataUsingEncoding:NSUnicodeStringEncoding] options:attribs documentAttributes:nil error:nil];
        [teaserDescription addAttributes:attribs range:NSMakeRange(0, [teaserDescription length])];
        self.descriptionTeaserLabel.attributedText = teaserDescription;
        [self.descriptionTeaserLabel sizeToFit];
    } else {
        [self.descriptionTeaserLabel ggp_collapseVertically];
    }
}

- (void)configureDescriptionText {
    self.descriptionTextView.editable = NO;
    self.descriptionTextView.scrollEnabled = NO;
    self.descriptionTextView.textContainer.lineFragmentPadding = 0;
    self.descriptionTextView.textContainerInset = UIEdgeInsetsZero;
    self.descriptionTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    if (self.event.eventDescription.length > 0) {
        NSDictionary *attribs = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                   NSForegroundColorAttributeName: [UIColor ggp_darkGray],
                                   NSFontAttributeName: [UIFont ggp_lightWithSize:14] };
        
        NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithData:[self.event.eventDescription dataUsingEncoding:NSUnicodeStringEncoding] options:attribs documentAttributes:nil error:nil];
        [description addAttributes:attribs range:NSMakeRange(0, [description length])];
        self.descriptionTextView.attributedText = description;
        [self.descriptionTextView sizeToFit];
    } else {
        [self.eventDetailHeaderLabel ggp_collapseVertically];
        [self.descriptionTextView ggp_collapseVertically];
    }
}

- (void)configureEventLinks {
    if (self.event.externalLinks.count > 0) {
        [self configurePrimaryLink];
        [self configureSecondaryLink];
    } else {
        [self.primaryLinkButton ggp_collapseVertically];
        [self.secondaryLinkButton ggp_collapseVertically];
    }
}

- (void)configurePrimaryLink {
    GGPExternalEventLink *primaryLink = self.event.externalLinks.firstObject;
    [self.primaryLinkButton setTitle:primaryLink.displayText.uppercaseString
                            forState:UIControlStateNormal];
    [self.primaryLinkButton ggp_styleAsDarkActionButton];
    self.primaryLinkButton.layer.cornerRadius = 0;
    self.primaryLinkButton.layer.borderWidth = 0;
}

- (void)configureSecondaryLink {
    if (self.event.externalLinks.count > 1) {
        GGPExternalEventLink *secondaryLink = self.event.externalLinks[1];
        [self.secondaryLinkButton setTitle:secondaryLink.displayText.uppercaseString
                                  forState:UIControlStateNormal];
        [self.secondaryLinkButton ggp_styleAsLightActionButton];
        self.secondaryLinkButton.layer.cornerRadius = 0;
        self.secondaryLinkButton.layer.borderColor = [UIColor ggp_blue].CGColor;
    } else {
        [self.secondaryLinkButton ggp_collapseVertically];
    }
}

- (void)configureTenantMap {
    if (self.event.tenant) {
        self.mapHeaderLabel.text = [[GGPJMapManager shared].mapViewController locationDescriptionForTenant:self.event.tenant];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapContainerTapped)];
        [self.mapContainer addGestureRecognizer:tapGesture];
        
        [self ggp_addChildViewController:[[GGPMapImageViewController alloc] initWithTenant:self.event.tenant] toPlaceholderView:self.mapContainer];
    } else {
        [self.mapHeaderLabel ggp_collapseVertically];
        [self.mapContainer ggp_collapseVertically];
    }
}

- (BOOL)shouldShowEntertainmentTitle {
    return !self.event.tenant && [GGPMallManager shared].selectedMall.mallId == kGrandCanalMallId;
}

- (void)mapContainerTapped {
    GGPEventDetailMapViewController *mapController = [[GGPEventDetailMapViewController alloc] initWithTenant:self.event.tenant];
    [self.navigationController pushViewController:mapController animated:YES];
}

#pragma mark - IB Actions

- (IBAction)locationTapped:(id)sender {
    [self.navigationController pushViewController:[[GGPTenantDetailViewController alloc] initWithTenantDetails:self.event.tenant] animated:YES];
}

- (void)shareButtonTapped {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.event] applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)primaryLinkTapped:(id)sender {
    GGPExternalEventLink *primaryLink = self.event.externalLinks.firstObject;
    [[UIApplication sharedApplication] openURL:primaryLink.url];
}

- (IBAction)secondaryLinkTapped:(id)sender {
    GGPExternalEventLink *secondaryLink = self.event.externalLinks[1];
    [[UIApplication sharedApplication] openURL:secondaryLink.url];
}

@end
