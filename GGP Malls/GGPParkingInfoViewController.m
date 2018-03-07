//
//  GGPParkingInfoViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPJmapViewcontroller+Levels.h"
#import "GGPJMapViewController+Zoom.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPModalViewController.h"
#import "GGPParkingAvailabilityViewController.h"
#import "GGPParkingInfoViewController.h"
#import "GGPParkingMapViewController.h"
#import "GGPParkingTenantPickerViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

static CGFloat const kScrollViewOffsetTopPadding = 10;

@interface GGPParkingInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (weak, nonatomic) IBOutlet UILabel *parkingDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *findNearestContainer;
@property (weak, nonatomic) IBOutlet UIView *pickerContainer;
@property (weak, nonatomic) IBOutlet UILabel *findNearestTitle;
@property (weak, nonatomic) IBOutlet UILabel *findNearestInstruction;
@property (weak, nonatomic) IBOutlet UIImageView *parkingIcon;

@property (strong, nonatomic) UIViewController *parkingMapViewController;
@property (strong, nonatomic) GGPParkingTenantPickerViewController *tenantPickerViewController;
@property (strong, nonatomic) GGPMall *mall;

@end

@implementation GGPParkingInfoViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = [@"PARKING_OVERVIEW_TITLE" ggp_toLocalized];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configurePickerContainer) name:GGPMallManagerMallUpdatedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController ggp_configureWithLightText];
    [self addMapViewToContainer];
    
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenParking];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeMapViewFromContainer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (GGPMall *)mall {
    return [GGPMallManager shared].selectedMall;
}

- (void)configureControls {
    [self configureMap];
    [self configureParkingIcon];
    [self configurePickerContainer];
    [self configureDescriptionText];
}

- (void)configureMap {
    if (!self.mall.config.isParkingAvailabilityEnabled) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapImageTapped)];
        self.mapContainer.userInteractionEnabled = YES;
        [self.mapContainer addGestureRecognizer:tapRecognizer];
    }
}

- (void)addMapViewToContainer {
    if (self.mall.config.isParkingAvailabilityEnabled) {
        [self.mapContainer ggp_collapseVertically];
    } else {
        self.parkingMapViewController = [GGPJMapManager shared].mapViewController;
        [GGPJMapManager shared].mapViewController.showLevelButtons = NO;
        [[GGPJMapManager shared].mapViewController centerMapForParkingInfo];
        [GGPJMapManager shared].mapViewController.view.userInteractionEnabled = NO;
        [self ggp_addChildViewController:self.parkingMapViewController toPlaceholderView:self.mapContainer];
    }
}

- (void)configureParkingIcon {
    self.parkingIcon.image = [UIImage imageNamed:@"ggp_icon_find_parking"];
}

- (void)configurePickerContainer {
    if ([self shouldShowFindNearestParking] && !self.tenantPickerViewController) {
        self.tenantPickerViewController = [GGPParkingTenantPickerViewController new];
        [self ggp_addChildViewController:self.tenantPickerViewController toPlaceholderView:self.pickerContainer];
        self.findNearestContainer.layer.borderColor = [UIColor ggp_lightGray].CGColor;
        self.findNearestContainer.layer.borderWidth = 1;
        
        self.findNearestTitle.font = [UIFont ggp_regularWithSize:16];
        self.findNearestTitle.text = [@"PARKING_INFO_FIND_NEAREST_HEADER" ggp_toLocalized];
        
        self.findNearestInstruction.font = [UIFont ggp_regularWithSize:14];
        self.findNearestInstruction.numberOfLines = 0;
        self.findNearestInstruction.text = [@"PARKING_INFO_FIND_NEAREST_INSTRUCTION" ggp_toLocalized];
        
        [self.findNearestContainer ggp_expandVertically];
    } else if (![self shouldShowFindNearestParking]) {
        [self.tenantPickerViewController ggp_removeFromParentViewController];
        self.tenantPickerViewController = nil;
        [self.findNearestContainer ggp_collapseVertically];
    }
}

- (BOOL)shouldShowFindNearestParking {
    return (self.mall.config.parkingAvailable && !self.mall.config.isParkingAvailabilityEnabled);
}

- (void)keyboardShown:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    self.scrollView.contentOffset = CGPointMake(0, self.findNearestContainer.frame.origin.y - kScrollViewOffsetTopPadding);
}

- (void)keyboardHidden {
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)removeMapViewFromContainer {
    if ([self.parkingMapViewController isEqual:[GGPJMapManager shared].mapViewController]) {
        [GGPJMapManager shared].mapViewController.showLevelButtons = YES;
        [GGPJMapManager shared].mapViewController.view.userInteractionEnabled = YES;
    }
    [self.parkingMapViewController ggp_removeFromParentViewController];
    self.parkingMapViewController = nil;
}

- (void)configureDescriptionText {
    NSString *parkingDescription = self.mall.parkingDescription;
    self.parkingDescriptionLabel.numberOfLines = 0;
    if (parkingDescription) {
        NSDictionary *attribs = @{
                                  NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                  NSForegroundColorAttributeName: [UIColor blackColor],
                                  NSFontAttributeName: [UIFont ggp_lightWithSize:16]
                                  };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithData:[parkingDescription dataUsingEncoding:NSUnicodeStringEncoding] options:attribs documentAttributes:nil error:nil];
            [description addAttributes:attribs range:NSMakeRange(0, [description length])];
            self.parkingDescriptionLabel.attributedText = description;
        });
    }
}

#pragma mark - Tap handlers

- (void)mapImageTapped {
    [self.navigationController pushViewController:[GGPParkingMapViewController new] animated:YES];
}

- (void)expandImageTapped {
    __weak typeof(self) weakSelf = self;
    GGPModalViewController *modal = [[GGPModalViewController alloc] initWithRootViewController:[GGPParkingAvailabilityViewController new] andOnClose:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:modal animated:YES completion:nil];
}

@end
