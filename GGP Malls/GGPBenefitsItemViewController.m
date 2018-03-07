//
//  GGPBenefitsItemViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBenefitsItemViewController.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPBenefitsItemViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) UIImage *icon;
@property (assign, nonatomic) NSInteger position;

@end

@implementation GGPBenefitsItemViewController

- (instancetype)initWithTitle:(NSString *)title description:(NSString *)description background:(UIImage *)background icon:(UIImage *)icon andPosition:(NSInteger)position {
    self = [super init];
    if (self) {
        self.backgroundImage = background;
        self.titleText = title;
        self.descriptionText = description;
        self.icon = icon;
        self.position = position;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerLabel.text = self.titleText;
    self.headerLabel.textColor = [UIColor whiteColor];
    self.headerLabel.font = [UIFont ggp_blackWithSize:18];
    
    self.descriptionLabel.text = self.descriptionText;
    self.descriptionLabel.textColor = [UIColor ggp_timberWolfGray];
    self.descriptionLabel.font = [UIFont ggp_regularWithSize:19];
    
    self.iconImageView.image = self.icon;
    self.backgroundImageView.image = self.backgroundImage;
}

@end
