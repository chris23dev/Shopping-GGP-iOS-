//
//  GGPParkingGarageLevelViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingGarageLevelViewController.h"
#import "GGPParkingLevel.h"
#import "GGPParkingZone.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

@interface GGPParkingGarageLevelViewController ()

@property (weak, nonatomic) IBOutlet UILabel *levelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *availableProgressView;
@property (weak, nonatomic) IBOutlet UIView *occupiedProgressView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (strong, nonatomic) GGPParkingLevel *level;
@property (strong, nonatomic) GGPParkingZone *zone;

@end

@implementation GGPParkingGarageLevelViewController

- (instancetype)initWithLevel:(GGPParkingLevel *)level andZone:(GGPParkingZone *)zone {
    self = [super init];
    if (self) {
        self.level = level;
        self.zone = zone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureControls {
    self.levelNameLabel.font = [UIFont ggp_regularWithSize:17];
    self.levelNameLabel.textColor = [UIColor ggp_darkGray];
    self.levelNameLabel.text = self.level.levelDescription.length > 0 ? [NSString stringWithFormat:@"%@*", self.level.levelName] : self.level.levelName;
    
    self.countLabel.font = [UIFont ggp_boldWithSize:17];
    self.countLabel.textColor = self.zone.availableSpots > 0 ? [UIColor ggp_green] : [UIColor ggp_darkRed];
    self.countLabel.text = self.zone.availableSpots > 0 ? [NSString stringWithFormat:@"%ld", (long)self.zone.availableSpots] : [@"PARKING_GARAGE_FULL" ggp_toLocalized];
    
    self.availableProgressView.backgroundColor = [UIColor ggp_green];
    self.occupiedProgressView.backgroundColor = [UIColor ggp_manateeGray];
    self.separatorView.backgroundColor = self.zone.availableSpots > 0 ? [UIColor whiteColor] : [UIColor ggp_manateeGray];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.occupiedProgressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.availableProgressView attribute:NSLayoutAttributeWidth multiplier:[self progressViewConstraintMultiplier] constant:0]];
}

- (CGFloat)progressViewConstraintMultiplier {
    return self.zone.availableSpots == 0 ? 1 : (CGFloat)self.zone.occupiedSpots / (CGFloat)(self.zone.occupiedSpots + self.zone.availableSpots);
}


@end
