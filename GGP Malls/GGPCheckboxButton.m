//
//  GGPCheckboxButton.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/31/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCheckboxButton.h"

@implementation GGPCheckboxButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    [self setBackgroundImage:[UIImage imageNamed:@"ggp_checkbox_unchecked"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"ggp_checkbox_checked"] forState:UIControlStateSelected];
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
    
    [self addTarget:self action:@selector(onTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTouchUpInside {
    self.selected = !self.isSelected;
    if (self.tapHandler) {
        self.tapHandler();
    }
}

@end
