//
//  GGPJMapUnitLabelViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapUnitLabelViewController.h"
#import "UIFont+GGPAdditions.h"

CGFloat const kHideAfterSize = 12;

@interface GGPJMapUnitLabelViewController ()

@property (weak, nonatomic) IBOutlet UILabel *unitNameLabel;
@property (strong, nonatomic) NSString *unitName;

@end

@implementation GGPJMapUnitLabelViewController

- (instancetype)initWithUnitName:(NSString *)unitName {
    self = [super init];
    if (self) {
        self.unitName = unitName;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.unitNameLabel.text = self.unitName;
    if([self shouldRotate]) {
        self.unitNameLabel.bounds = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.height, self.view.bounds.size.width);
        self.unitNameLabel.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
}

- (void)setShouldShow:(BOOL)shouldShow {
    self.unitNameLabel.hidden = !shouldShow;
}

- (void)configureLabel {
    self.unitNameLabel.backgroundColor = [UIColor clearColor];
    self.unitNameLabel.numberOfLines = 0;
    self.unitNameLabel.textAlignment = NSTextAlignmentCenter;
}

- (BOOL)shouldRotate {
    return self.view.bounds.size.width < self.view.bounds.size.height;
}

- (void)contentScaleFactorChanged:(NSNumber *)newScale {
    float scaledSize = kHideAfterSize / [newScale floatValue];
    UIFont *scaledFont = [UIFont ggp_mediumWithSize:scaledSize];
    CGSize size = [self.unitNameLabel.text sizeWithAttributes:@{NSFontAttributeName:scaledFont}];
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.unitNameLabel.font = scaledFont;
        
        if ([self shouldRotate]) {
            self.unitNameLabel.hidden = adjustedSize.height > self.unitNameLabel.frame.size.width;
        } else {
            self.unitNameLabel.hidden = adjustedSize.height > self.unitNameLabel.frame.size.height;
        }
    });
}

@end
