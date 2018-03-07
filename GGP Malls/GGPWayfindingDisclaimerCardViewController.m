//
//  GGPWayfindingDisclaimerCardViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPWayfindingDisclaimerCardViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPWayfindingDisclaimerCardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;

@end

@implementation GGPWayfindingDisclaimerCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureControls {
    self.disclaimerLabel.numberOfLines = 0;
    self.disclaimerLabel.font = [UIFont ggp_regularWithSize:9];
    self.disclaimerLabel.text = [@"WAYFINDING_DISCLAIMER_TEXT" ggp_toLocalized];
}

@end
