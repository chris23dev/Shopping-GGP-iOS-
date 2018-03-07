//
//  GGPMovieTheaterNoMoviesCell.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/3/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovieTheaterNoMoviesCell.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"

NSString *const GGPMovieTheaterNoMoviesCellReuseIdentifier = @"GGPNoMoviesCellReuseIdentifier";

@interface GGPMovieTheaterNoMoviesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *noMoviesImage;
@property (weak, nonatomic) IBOutlet UILabel *noMoviesHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *pleaseCheckBackLabel;

@end

@implementation GGPMovieTheaterNoMoviesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layoutMargins = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell];
}

- (void)configureCell {
    self.backgroundColor = [UIColor ggp_lightGray];
    
    self.noMoviesImage.image = [UIImage imageNamed:@"ggp_icon_no_movies"];
    
    self.noMoviesHeaderLabel.numberOfLines = 0;
    self.noMoviesHeaderLabel.textAlignment = NSTextAlignmentCenter;
    self.noMoviesHeaderLabel.font = [UIFont ggp_boldWithSize:16];
    self.noMoviesHeaderLabel.textColor = [UIColor ggp_darkGray];
    self.noMoviesHeaderLabel.text = [@"MOVIES_NO_SHOWTIMES_FOR_DAY" ggp_toLocalized];
    
    self.pleaseCheckBackLabel.numberOfLines = 0;
    self.pleaseCheckBackLabel.textAlignment = NSTextAlignmentCenter;
    self.pleaseCheckBackLabel.font = [UIFont ggp_regularWithSize:14];
    self.pleaseCheckBackLabel.textColor = [UIColor ggp_darkGray];
    self.pleaseCheckBackLabel.text = [@"MOVIES_NO_SHOWTIMES_PLEASE_CHECK_BACK" ggp_toLocalized];
}

@end
