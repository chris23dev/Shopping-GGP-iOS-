//
//  GGPCarMapViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCarMapViewController.h"
#import "GGPParkingCarLocation.h"
#import "GGPParkAssistClient.h"
#import "GGPParkingSite.h"
#import "NSString+GGPAdditions.h"
#import "UIImage+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

static CGFloat const kMinZoomScale = 1;
static CGFloat const kMaxZoomScale = 6;

@interface GGPCarMapViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) GGPParkingCarLocation *carLocation;
@property (strong, nonatomic) GGPParkingSite *site;

@end

@implementation GGPCarMapViewController

- (instancetype)initWithCarLocation:(GGPParkingCarLocation *)carLocation andSite:(GGPParkingSite *)site {
    self = [super init];
    if (self) {
        self.carLocation = carLocation;
        self.site = site;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"FIND_MY_CAR_MAP_VIEW" ggp_toLocalized];
    [self configureControls];
}

- (void)configureControls {
    self.scrollView.minimumZoomScale = kMinZoomScale;
    self.scrollView.maximumZoomScale = kMaxZoomScale;
    self.scrollView.contentSize = self.mapImageView.frame.size;
    self.scrollView.delegate = self;
    
    NSURL *mapURL = [[GGPParkAssistClient shared] retrieveMapURLForMapName:self.carLocation.map andSite:self.site];
    [self.mapImageView setImageWithURLRequest:[NSURLRequest requestWithURL:mapURL] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [self placePinForMapImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [self ggp_displayAlertWithTitle:nil message:[@"ALERT_GENERIC_ERROR_MESSAGE" ggp_toLocalized] actionTitle:nil andCompletion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)placePinForMapImage:(UIImage *)mapImage {
    UIImage *pinImage = [UIImage imageNamed:@"ggp_car_pin_blue"];
    NSInteger xPosition = self.carLocation.xPosition.integerValue/mapImage.scale;
    NSInteger yPosition = self.carLocation.yPosition.integerValue/mapImage.scale;
    
    NSInteger xOffset = pinImage.size.width * 0.75;
    NSInteger yOffset = pinImage.size.height;
    
    CGPoint pinPoint = CGPointMake(xPosition - xOffset, yPosition - yOffset);
    
    self.mapImageView.image = [UIImage ggp_drawImage:pinImage inImage:mapImage atPoint:pinPoint];
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.mapImageView;
}

@end
