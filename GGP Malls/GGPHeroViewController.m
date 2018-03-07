//
//  GGPHeroViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPHero.h"
#import "GGPHeroViewController.h"
#import "UIFont+GGPAdditions.h"
#import "UIImage+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPDynamicHeightImageView.h"
#import "GGPMall.h"
#import "GGPShoppingTableViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

static NSString *const kUrlSeparator = @":";
static NSString *const kScreenUrlType = @"screen";
static NSString *const kCampaignUrlType = @"campaign";
static NSString *const kParkingScreen = @"PARKING";
static NSString *const kDirectoryScreen = @"DIRECTORY";

@interface GGPHeroViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mallNameLabel;
@property (weak, nonatomic) IBOutlet GGPDynamicHeightImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UIView *dividerLine;

@property (strong, nonatomic) GGPHero *hero;
@property (strong, nonatomic) UIImage *image;

@end

@implementation GGPHeroViewController

- (instancetype)initWithHero:(GGPHero *)hero andImage:(UIImage *)image {
    self = [super init];
    if (self ) {
        self.hero = hero;
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureControls {
    self.mallNameLabel.font = [UIFont ggp_mediumWithSize:14];
    self.mallNameLabel.textColor = [UIColor ggp_darkGray];
    self.mallNameLabel.text = [GGPMallManager shared].selectedMall.name.uppercaseString;
    
    self.titleLabel.font = [UIFont ggp_mediumWithSize:16];
    self.titleLabel.textColor = [UIColor ggp_darkGray];
    self.titleLabel.text = self.hero.title;
    
    self.descriptionLabel.font = [UIFont ggp_lightWithSize:16];
    self.descriptionLabel.textColor = [UIColor ggp_darkGray];
    self.descriptionLabel.text = self.hero.heroDescription;
    
    self.dividerLine.backgroundColor = [UIColor ggp_gainsboroGray];
    
    [self configureUrlLabel];
    
    self.imageView.image = self.image;
}

- (void)configureUrlLabel {
    if (!self.hero.url) {
        [self.urlLabel ggp_collapseVertically];
        return;
    }
    
    self.urlLabel.userInteractionEnabled = YES;
    self.urlLabel.font = [UIFont ggp_regularWithSize:16];
    self.urlLabel.textColor = [UIColor ggp_blue];
    self.urlLabel.text = self.hero.urlText;
    
    UITapGestureRecognizer *urlTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(urlLabelTapped)];
    [self.urlLabel addGestureRecognizer:urlTap];
}

- (void)urlLabelTapped {
    NSArray *components = [self.hero.url componentsSeparatedByString:kUrlSeparator];
    NSString *urlType = components.firstObject;
    
    if ([urlType isEqualToString:kScreenUrlType]) {
        [self handleScreenUrlComponents:components];
    } else if ([urlType isEqualToString:kCampaignUrlType]) {
        [self handleCampaignUrlComponents:components];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.hero.url]];
    }
}

- (void)handleScreenUrlComponents:(NSArray *)urlComponents {
    NSString *screenType = urlComponents.count != 2 ? nil : urlComponents[1];
    
    if ([screenType isEqualToString:kParkingScreen]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GGPHeroParkingNotification object:nil];
    } else if ([screenType isEqualToString:kDirectoryScreen]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GGPHeroDirectoryNotification object:nil];
    }
}

- (void)handleCampaignUrlComponents:(NSArray *)urlComponents {
    NSString *campaignCode = urlComponents.count != 2 ? nil : urlComponents[1];
    if ([GGPCategory isValidCampaignCategoryCode:campaignCode]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GGPHeroCampaignNotification object:nil userInfo:@{GGPHeroCampaignCodeKey:campaignCode}];
    }
}

@end
