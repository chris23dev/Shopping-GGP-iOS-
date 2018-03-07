//
//  GGPUpToDateCell.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 8/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPUpToDateCell.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"

NSString *const GGPUpToDateCellId = @"GGPUpToDateCellId";

@interface GGPUpToDateCell ()

@property (weak, nonatomic) IBOutlet UILabel *upToDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseFavoritesButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseFavoritesButtonHeightConstraint;

@end

@implementation GGPUpToDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.backgroundColor = [UIColor ggp_navigationBar];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.upToDateLabel.text = [@"JUST_FOR_YOU_UP_TO_DATE" ggp_toLocalized];
    self.upToDateLabel.textColor = [UIColor ggp_mediumGray];
    self.upToDateLabel.font = [UIFont ggp_regularWithSize:14];
    
    [self.chooseFavoritesButton setTitle:[@"JUST_FOR_YOU_ADD_FAVORITES" ggp_toLocalized] forState:UIControlStateNormal];
    [self.chooseFavoritesButton ggp_styleAsLinkButton];
    self.chooseFavoritesButton.titleLabel.font = [UIFont ggp_blackWithSize:14];
}

- (void)showChooseFavorites {
    [self.chooseFavoritesButton ggp_expandVertically];
}

- (void)hideChooseFavorites {
    [self.chooseFavoritesButton ggp_collapseVertically];
}

- (IBAction)onChooseFavoritesTap:(id)sender {
    if (self.onChooseFavoritesTapped) {
        self.onChooseFavoritesTapped();
    }
}

@end
