//
//  GGPMessageViewController.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 4/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMessageViewController.h"
#import "UIView+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

@interface GGPMessageViewController ()

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *headline;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *actionTitle;
@property (copy, nonatomic) void(^onActionTapHandler)();

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation GGPMessageViewController

- (instancetype)initWithImage:(UIImage *)image headline:(NSString *)headline andBody:(NSString *)body {
    return [self initWithImage:image headline:headline body:body actionTitle:nil actionTapHandler:nil];
}

- (instancetype)initWithImage:(UIImage *)image headline:(NSString *)headline body:(NSString *)body actionTitle:(NSString *)actionTitle actionTapHandler:(void(^)())onActionTap {
    self = [super init];
    if (self) {
        self.image = image;
        self.headline = headline;
        self.body = body;
        self.actionTitle = actionTitle;
        self.onActionTapHandler = onActionTap;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureImage];
    [self configureHeadline];
    [self configureBody];
    [self configureActionButton];
}

- (void)configureImage {
    if (self.image) {
        self.imageView.image = self.image;
    } else {
        [self.imageView ggp_collapseVertically];
    }
}

- (void)configureHeadline {
    self.headlineLabel.font = [UIFont ggp_mediumWithSize:18];
    self.headlineLabel.text = self.headline;
}

- (void)configureBody {
    self.bodyLabel.font = [UIFont ggp_regularWithSize:14];
    self.bodyLabel.text = self.body;
}

- (void)configureActionButton {
    self.actionButton.hidden = YES;
    
    if (self.actionTitle) {
        [self.actionButton setTitleColor:[UIColor ggp_blue] forState:UIControlStateNormal];
        self.actionButton.titleLabel.font = [UIFont ggp_mediumWithSize:16];
        [self.actionButton setTitle:self.actionTitle forState:UIControlStateNormal];
        self.actionButton.hidden = NO;
    }
}

- (IBAction)onActionButtonTapped:(id)sender {
    if (self.onActionTapHandler) {
        self.onActionTapHandler();
    }
}

@end
