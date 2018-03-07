//
//  GGPMovieTheaterDetailsCell.m
//  GGP Malls
//
//  Created by Janet Lin on 2/2/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovieTheaterDetailsCell.h"
#import "GGPLogoImageView.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

NSString *const GGPMovieTheaterDetailsCellReuseIdentifier = @"GGPMovieTheaterDetailsCellReuseIdentifier";

@interface GGPMovieTheaterDetailsCell ()

@property (weak, nonatomic) IBOutlet GGPLogoImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *theaterNameButton;
@property (weak, nonatomic) IBOutlet UILabel *theaterLocationLabel;

@end

@implementation GGPMovieTheaterDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureWithTheaterName:(NSString *)name Location:(NSString *)location andImageUrl:(NSURL *)logoUrl {
    [self configureTextStyling];
    [self.logoImageView setImageWithURL:logoUrl defaultName:name];
    [self.theaterNameButton setTitle:name forState:UIControlStateNormal];
    self.theaterLocationLabel.text = location;
}

- (void)configureTextStyling {
    self.theaterNameButton.titleLabel.font = [UIFont ggp_boldWithSize:18];
    [self.theaterNameButton setTitleColor:[UIColor ggp_blue] forState:UIControlStateNormal];
    
    self.theaterLocationLabel.font = [UIFont ggp_lightWithSize:16];
    self.theaterLocationLabel.textColor = [UIColor blackColor];
}

- (IBAction)theaterNameButtonTapped:(id)sender {
    [self.theaterDetailCellDelegate handleTheaterNameButtonTapped];
}

@end
