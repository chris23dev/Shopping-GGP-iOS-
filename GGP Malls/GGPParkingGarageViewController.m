//
//  GGPParkingGarageViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingGarageViewController.h"
#import "GGPParkingGarageLevelViewController.h"
#import "GGPParkingLevel.h"
#import "GGPParkingZone.h"
#import "NSArray+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import "UIViewController+GGPDirections.h"

static NSString *const kLevelSortKey = @"sort";
static CGFloat const kStackViewExpandedMargin = 10;
static CGFloat const kStackViewCollapsedMargin = 0;

@interface GGPParkingGarageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *garageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *entranceLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionsLabel;

@property (weak, nonatomic) IBOutlet UILabel *occupiedLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupiedCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableCountLabel;

@property (weak, nonatomic) IBOutlet UIView *occupiedEndCapView;
@property (weak, nonatomic) IBOutlet UIView *availableEndCapView;

@property (weak, nonatomic) IBOutlet UIView *occupiedProgressView;
@property (weak, nonatomic) IBOutlet UIView *availableProgressView;
@property (weak, nonatomic) IBOutlet UIView *progressDividerView;

@property (weak, nonatomic) IBOutlet UILabel *seeByLevelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIStackView *levelStackView;
@property (weak, nonatomic) IBOutlet UIStackView *descriptionStackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewTopMargin;

@property (strong, nonatomic) GGPParkingGarage *garage;
@property (strong, nonatomic) NSArray *levels;
@property (strong, nonatomic) NSArray *zones;
@property (strong, nonatomic) NSDictionary *levelToZoneLookup;
@property (strong, nonatomic) NSArray *levelViewControllers;
@property (strong, nonatomic) NSArray *descriptionLabels;

@end

@implementation GGPParkingGarageViewController

- (instancetype)initWithGarage:(GGPParkingGarage *)garage levels:(NSArray *)levels andZones:(NSArray *)zones {
    self = [super init];
    if (self) {
        self.garage = garage;
        self.levels = [levels ggp_sortListAscendingForKey:kLevelSortKey];
        self.zones = zones;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.levelToZoneLookup = [GGPParkingGarageViewController createLevelToZoneLookupWithLevels:self.levels andZones:self.zones];
    [self configureControls];
}

- (void)configureControls {
    [self configureLabels];
    [self configureDirections];
    [self configureProgressView];
    [self configureLevels];
}

- (void)configureLabels {
    self.garageNameLabel.font = [UIFont ggp_lightWithSize:32];
    self.garageNameLabel.textColor = [UIColor ggp_darkGray];
    self.garageNameLabel.text = self.garage.garageName;
    
    self.occupiedLabel.font = [UIFont ggp_regularWithSize:16];
    self.occupiedLabel.textColor = [UIColor ggp_manateeGray];
    self.occupiedLabel.text = [@"PARKING_GARAGE_SPACES_OCCUPIED" ggp_toLocalized];
   
    self.seeByLevelLabel.font = [UIFont ggp_regularWithSize:16];
    self.seeByLevelLabel.textColor = [UIColor ggp_manateeGray];
    self.seeByLevelLabel.text = [@"PARKING_GARAGE_SEE_BY_LEVEL" ggp_toLocalized];
    self.seeByLevelLabel.userInteractionEnabled = YES;
    [self.seeByLevelLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLevelAvailability)]];
    
    [self configureEntranceLabel];
}

- (void)configureEntranceLabel {
    if (self.garage.garageDescription.length > 0) {
        self.entranceLabel.font = [UIFont ggp_regularWithSize:16];
        self.entranceLabel.textColor = [UIColor ggp_darkGray];
        self.entranceLabel.text = self.garage.garageDescription;
    } else {
        [self.entranceLabel ggp_collapseVertically];
    }
}

- (void)configureDirections {
    if (self.garage.latitude && self.garage.longitude) {
        self.directionsLabel.font = [UIFont ggp_regularWithSize:16];
        self.directionsLabel.textColor = [UIColor ggp_blue];
        self.directionsLabel.text = [@"PARKING_GARAGE_DIRECTIONS" ggp_toLocalized];
        self.directionsLabel.userInteractionEnabled = YES;
        [self.directionsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(directionsLabelTapped)]];
    } else {
        [self.directionsLabel ggp_collapseVertically];
    }
}

- (void)configureProgressView {
    NSInteger garageAvailableSpots = [GGPParkingGarageViewController totalAvailableSpotsFromZones:self.levelToZoneLookup.allValues];
    NSInteger garageOccupiedSpots = [GGPParkingGarageViewController totalOccupiedSpotsFromZones:self.levelToZoneLookup.allValues];
    
    self.availableLabel.font = [UIFont ggp_regularWithSize:16];
    self.availableLabel.textColor = garageAvailableSpots > 0 ? [UIColor ggp_green] : [UIColor ggp_darkRed];
    self.availableLabel.text = [@"PARKING_GARAGE_SPACES_AVAILABLE" ggp_toLocalized];
    
    self.occupiedCountLabel.font = [UIFont ggp_boldWithSize:19];
    self.occupiedCountLabel.textColor = [UIColor ggp_manateeGray];
    self.occupiedCountLabel.text = [NSString stringWithFormat:@"%ld", (long)garageOccupiedSpots];
    
    self.availableCountLabel.font = [UIFont ggp_boldWithSize:19];
    self.availableCountLabel.textColor = garageAvailableSpots > 0 ? [UIColor ggp_green] : [UIColor ggp_darkRed];
    self.availableCountLabel.text = garageAvailableSpots > 0 ? [NSString stringWithFormat:@"%ld", (long)garageAvailableSpots] : [@"PARKING_GARAGE_FULL" ggp_toLocalized];
    
    self.occupiedEndCapView.backgroundColor = [UIColor ggp_manateeGray];
    self.occupiedProgressView.backgroundColor = [UIColor ggp_manateeGray];
    self.availableEndCapView.backgroundColor = [UIColor ggp_manateeGray];
    self.availableProgressView.backgroundColor = [UIColor ggp_green];
    
    self.progressDividerView.backgroundColor = garageAvailableSpots > 0 ? [UIColor whiteColor] : [UIColor ggp_manateeGray];
    [self.view addConstraint:[self progressWidthConstraintForOccupiedSpots:garageOccupiedSpots andAvailableSpots:garageAvailableSpots]];
}

- (NSLayoutConstraint *)progressWidthConstraintForOccupiedSpots:(NSInteger)occupiedSpots andAvailableSpots:(NSInteger)availableSpots {
    NSInteger totalSpots = availableSpots + occupiedSpots;
    CGFloat multiplier = totalSpots == 0 ? 1 : (CGFloat)occupiedSpots / (CGFloat)totalSpots;
    return [NSLayoutConstraint constraintWithItem:self.occupiedProgressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.availableProgressView attribute:NSLayoutAttributeWidth multiplier:multiplier constant:0];
}

- (void)configureLevels {
    self.arrowImageView.image = [UIImage imageNamed:@"ggp_icon_filter_down_arrow"];
    self.arrowImageView.userInteractionEnabled = YES;
    [self.arrowImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLevelAvailability)]];
    
    self.descriptionLabels = [self createDescriptionLabels];
    self.levelViewControllers = [self createLevelViewControllers];
    
    self.stackViewTopMargin.constant = kStackViewCollapsedMargin;
    self.stackViewBottomMargin.constant = kStackViewCollapsedMargin;
}

- (NSArray *)createLevelViewControllers {
    NSMutableArray *controllers = [NSMutableArray new];
    for (GGPParkingLevel *level in self.levels) {
        GGPParkingZone *zone = self.levelToZoneLookup[@(level.levelId)];
        GGPParkingGarageLevelViewController *levelController = [[GGPParkingGarageLevelViewController alloc] initWithLevel:level andZone:zone];
        [controllers addObject:levelController];
    }
    return controllers;
}

- (NSArray *)createDescriptionLabels {
    NSMutableArray *labels = [NSMutableArray new];
    for (GGPParkingLevel *level in self.levels) {
        if (level.levelDescription.length > 0) {
            UILabel *label = [UILabel new];
            label.font = [UIFont ggp_regularWithSize:14];
            label.textColor = [UIColor ggp_manateeGray];
            label.text = [NSString stringWithFormat:@"*%@ - %@", level.levelName, level.levelDescription];
            label.numberOfLines = 0;
            [labels addObject:label];
        }
    }
    return labels;
}

- (void)directionsLabelTapped {
    [self ggp_getDirectionsForLatitude:self.garage.latitude.floatValue andLongitude:self.garage.longitude.floatValue];
}

- (void)toggleLevelAvailability {
    if (self.levelStackView.arrangedSubviews.count == 0) {
        [[GGPAnalytics shared] trackAction:GGPAnalyticsActionParkingAvailabilityByLevel withData:nil];
        [self expandLevels];
    } else {
        [self collapseLevels];
    }
}

- (void)expandLevels {
    [self.seeByLevelLabel ggp_collapseVertically];
    self.arrowImageView.image = [UIImage imageNamed:@"ggp_icon_filter_up_arrow"];
    
    for (GGPParkingGarageLevelViewController *levelController in self.levelViewControllers) {
        [self ggp_addChildViewController:levelController toStackView:self.levelStackView];
    }
    
    for (UILabel *label in self.descriptionLabels) {
        [self.descriptionStackView addArrangedSubview:label];
    }
    
    self.stackViewTopMargin.constant = kStackViewExpandedMargin;
    self.stackViewBottomMargin.constant = kStackViewExpandedMargin;
}

- (void)collapseLevels {
    [self.seeByLevelLabel ggp_expandVertically];
    self.arrowImageView.image = [UIImage imageNamed:@"ggp_icon_filter_down_arrow"];
    
    for (GGPParkingGarageLevelViewController *levelController in self.levelViewControllers) {
        [levelController ggp_removeFromParentViewController];
    }
    
    for (UILabel *label in self.descriptionLabels) {
        [label removeFromSuperview];
    }
    
    self.stackViewTopMargin.constant = kStackViewCollapsedMargin;
    self.stackViewBottomMargin.constant = kStackViewCollapsedMargin;
}

+ (NSDictionary *)createLevelToZoneLookupWithLevels:(NSArray *)levels andZones:(NSArray *)zones {
    NSMutableDictionary *lookup = [NSMutableDictionary new];
    
    for (GGPParkingLevel *level in levels) {
        GGPParkingZone *zone = [GGPParkingSite zoneForZoneName:level.zoneName fromZones:zones];
        if (zone) {
            [lookup setObject:zone forKey:@(level.levelId)];
        }
    }
    
    return lookup;
}

+ (NSInteger)totalAvailableSpotsFromZones:(NSArray *)zones {
    NSInteger spots = 0;
    
    for (GGPParkingZone *zone in zones) {
        spots += zone.availableSpots;
    }
    
    return spots;
}

+ (NSInteger)totalOccupiedSpotsFromZones:(NSArray *)zones {
    NSInteger spots = 0;
    for (GGPParkingZone *zone in zones) {
        spots += zone.occupiedSpots;
    }
    return spots;
}

@end
