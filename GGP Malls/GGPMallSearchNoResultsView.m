//
//  GGPMallLocationSearchNoResultsView.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMallSearchNoResultsView.h"
#import "NSString+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPMallSearchNoResultsView ()

@property (weak, nonatomic) IBOutlet UILabel *noResultsLabel;
@property (weak, nonatomic) IBOutlet UIButton *noResultsButton;

@property (copy, nonatomic) NSString *labelText;
@property (copy, nonatomic) NSString *buttonText;

@end

@implementation GGPMallSearchNoResultsView

- (instancetype)init {
    return [[NSBundle mainBundle] loadNibNamed:@"GGPMallSearchNoResultsView" owner:self options:nil].firstObject;
}

- (void)configureWithLabelText:(NSString *)label textColor:(UIColor *)textColor andButtonText:(NSString *)buttonText {
    self.labelText = label;
    self.buttonText = buttonText;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.noResultsLabel.numberOfLines = 0;
    self.noResultsLabel.textAlignment = NSTextAlignmentCenter;
    self.noResultsLabel.font = [UIFont ggp_regularWithSize:19];
    self.noResultsLabel.textColor = textColor;
    self.noResultsLabel.text = self.labelText;
    
    [self.noResultsButton ggp_styleAsLinkButton];
    [self.noResultsButton setTitle:self.buttonText forState:UIControlStateNormal];
}

- (IBAction)noResultsTapped:(id)sender {
    [self.noResultsDelegate didTapNoResultsButton];
}

@end
