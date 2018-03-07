//
//  GGPMovieTheaterDetailViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovieTheater.h"
#import "GGPLogoImageView.h"
#import "GGPMultiTheaterDetailViewController.h"
#import "GGPJMapManager.h"
#import "GGPTenantDetailViewController.h"
#import "GGPJMapViewController.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"

@interface GGPMultiTheaterDetailViewController ()

@property (weak, nonatomic) IBOutlet GGPLogoImageView *theaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *theaterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *theaterLocationLabel;

@property (strong, nonatomic) GGPMovieTheater *theater;

@end

@implementation GGPMultiTheaterDetailViewController

- (instancetype)initWithTheater:(GGPMovieTheater *)theater {
    self = [super init];
    if (self) {
        self.theater = theater;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureControls {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view ggp_addShadowWithRadius:1 andOpacity:0.25];
    
    UITapGestureRecognizer *tapHandler = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(theaterDetailTapped)];
    [self.view addGestureRecognizer:tapHandler];
    
    self.theaterNameLabel.textColor = [UIColor blackColor];
    self.theaterNameLabel.font = [UIFont ggp_regularWithSize:16];
    
    self.theaterLocationLabel.numberOfLines = 0;
    self.theaterLocationLabel.textColor = [UIColor ggp_mediumGray];
    self.theaterLocationLabel.font = [UIFont ggp_regularWithSize:14];
    
    [self.theaterImageView setImageWithURL:self.theater.tenantLogoUrl defaultName:self.theater.name];
    self.theaterNameLabel.text = self.theater.name;
    self.theaterLocationLabel.text = [[GGPJMapManager shared].mapViewController locationDescriptionForTenant:self.theater];
}

- (void)theaterDetailTapped {
    [self trackTheater];
    
    GGPTenantDetailViewController *detailViewController = [[GGPTenantDetailViewController alloc] initWithTenantDetails:self.theater];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark Analytics

- (void)trackTheater {
    NSString *name = self.theater.name ? self.theater.name : @"";
    NSDictionary *data = @{ GGPAnalyticsContextDataMultiTheaterMallTheater: name };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionMultiTheaterMallTheater withData:data];
}

@end
