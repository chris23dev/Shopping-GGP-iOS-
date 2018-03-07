//
//  GGPCarLocationCell.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCarLocationCell.h"
#import "GGPParkingCarLocation.h"
#import "GGPParkAssistClient.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

NSString *const GGPCarLocationCellId = @"GGPCarLocationCellId";

@interface GGPCarLocationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *garageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@property (strong, nonatomic) GGPParkingCarLocation *carLocation;
@property (strong, nonatomic) GGPParkingSite *site;

@end

@implementation GGPCarLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureControls];
}

- (void)configureControls {
    self.garageNameLabel.font = [UIFont ggp_regularWithSize:14];
    self.garageNameLabel.textColor = [UIColor ggp_darkGray];
    
    self.locationLabel.font = [UIFont ggp_regularWithSize:16];
    self.locationLabel.textColor = [UIColor ggp_darkGray];
    
    [self.mapButton setTitle:[@"FIND_MY_CAR_MAP_VIEW" ggp_toLocalized] forState:UIControlStateNormal];
    [self.mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.mapButton.titleLabel.font = [UIFont ggp_boldWithSize:12];
    self.mapButton.backgroundColor = [UIColor ggp_blue];
    self.mapButton.layer.cornerRadius = 4;
    self.mapButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
}

- (void)configureWithCarLocation:(GGPParkingCarLocation *)carLocation andSite:(GGPParkingSite *)site {
    self.carLocation = carLocation;
    self.site = site;
    
    [self configureImage];
    [self configureLabels];
    [self configureMapButton];
}

- (void)configureImage {
    [self.thumbnailImageView cancelImageRequestOperation];
    NSURL *thumbnailURL = [[GGPParkAssistClient shared] retrieveThumbnailURLForUUID:self.carLocation.uuid andSite:self.site];
    [self.thumbnailImageView setImageWithURL:thumbnailURL placeholderImage:[UIImage imageNamed:@"ggp_parking_no_image"]];
}

- (void)configureLabels {
    GGPParkingLevel *level = [GGPParkingSite levelForZoneName:self.carLocation.zoneName fromLevels:self.site.levels];
    GGPParkingGarage *garage = [GGPParkingSite garageForGarageId:level.garageId fromGarages:self.site.garages];
    
    self.garageNameLabel.text = garage.garageName;
    self.locationLabel.text = level.levelName;
}

- (void)configureMapButton {
    if (self.carLocation.map.length > 0) {
        [self.mapButton ggp_expandVertically];
    } else {
        [self.mapButton ggp_collapseVertically];
    }
}

- (IBAction)mapButtonTapped:(id)sender {
    if (self.onMapTapped) {
        self.onMapTapped(self.carLocation);
    }
}

@end
