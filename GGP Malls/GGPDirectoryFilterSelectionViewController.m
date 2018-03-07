//
//  GGPDirectoryFilterSelectionViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 11/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPDirectoryFilterSelectionViewController.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPDirectoryFilterSelectionViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *clearIconContainer;
@property (weak, nonatomic) IBOutlet UILabel *clearLabel;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

@end

@implementation GGPDirectoryFilterSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureControls {
    self.view.backgroundColor = [UIColor clearColor];
    
    self.containerView.userInteractionEnabled = YES;
    self.containerView.backgroundColor = [UIColor ggp_blue];
    self.containerView.layer.cornerRadius = 4;
    
    self.filterLabel.textColor = [UIColor whiteColor];
    self.filterLabel.font = [UIFont ggp_regularWithSize:11];
    
    self.clearIconContainer.backgroundColor = [UIColor whiteColor];
    self.clearIconContainer.layer.cornerRadius = 8;
    
    self.clearLabel.textAlignment = NSTextAlignmentCenter;
    self.clearLabel.textColor = [UIColor blackColor];
    self.clearLabel.font = [UIFont ggp_boldWithSize:10];
    self.clearLabel.text = @"X";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterSelectionTapped)];
    [self.containerView addGestureRecognizer:tapGesture];
}

- (void)configureWithFilterText:(NSString *)filterText {
    self.filterLabel.text = filterText;
}

- (void)filterSelectionTapped {
    [self.filterSelectionDelegate selectedFilterCleared];
}

@end
