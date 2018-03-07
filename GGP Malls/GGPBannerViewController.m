//
//  GGPBannerViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBannerViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPBannerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) NSString *message;

@end

@implementation GGPBannerViewController

- (instancetype)initWithMessage:(NSString *)message {
    self = [super init];
    if (self) {
        self.message = message;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBanner];
}

- (void)configureBanner {
    self.view.backgroundColor = [UIColor ggp_colorFromHexString:@"000000" andAlpha:0.75];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont ggp_regularWithSize:12];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.text = self.message;
}

@end
