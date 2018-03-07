//
//  GGPTodaysHoursViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPTodaysHoursViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPTodaysHoursViewController ()

@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UIView *dividerView;

@end

@implementation GGPTodaysHoursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureControls {
    self.view.backgroundColor = [UIColor ggp_gainsboroGray];
    self.hoursLabel.numberOfLines = 0;
    self.hoursLabel.textAlignment = NSTextAlignmentCenter;
    self.hoursLabel.font = [UIFont ggp_regularWithSize:14];
    self.hoursLabel.textColor = [UIColor ggp_darkGray];
    self.hoursLabel.text = [GGPMallManager shared].selectedMall.formattedTodaysHoursString;
    
    self.dividerView.backgroundColor = [UIColor ggp_pastelGray];
}

@end
