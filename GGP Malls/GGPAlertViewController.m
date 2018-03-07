//
//  GGPAlertViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAlert.h"
#import "GGPAlertViewController.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPAlertViewController ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) GGPAlert *alert;

@end

@implementation GGPAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor ggp_alertBackground];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont ggp_regularWithSize:14];
    self.messageLabel.textColor = [UIColor ggp_darkGray];
    self.messageLabel.text = self.alert.message;
}

- (instancetype)initWithAlert:(GGPAlert *)alert {
    self = [super init];
    if (self) {
        self.alert = alert;
    }
    return self;
}

@end
