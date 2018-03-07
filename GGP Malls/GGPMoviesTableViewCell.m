
//
//  GGPMovieTableViewCell.m
//  GGP Malls
//
//  Created by Janet Lin on 12/10/15.
//  Copyright (c) 2015 GGP. All rights reserved.
//

#import "GGPMallMovie.h"
#import "GGPMoviesTableViewCell.h"
#import "GGPShowtimeStackView.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <AFNetworking/UIButton+AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

NSString *const GGPMoviesCellReuseIdentifier = @"GGPMoviesCellReuseIdentifier";
CGFloat const GGPEstimatedMovieCellHeight = 200;

@interface GGPMoviesTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *movieCardView;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (weak, nonatomic) IBOutlet GGPShowtimeStackView *showtimeStackView;

@property (assign, nonatomic) NSInteger numberOfMovieTimes;
@property (strong, nonatomic) GGPMovie *movie;

@end

@implementation GGPMoviesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureControls];
}

- (void)configureControls {
    self.movieNameLabel.font = [UIFont ggp_boldWithSize:14];
    self.movieNameLabel.textColor = [UIColor blackColor];
    self.movieNameLabel.numberOfLines = 0;
    
    self.movieDetailsLabel.font = [UIFont ggp_lightWithSize:14];
    self.movieDetailsLabel.textColor = [UIColor blackColor];
    
    self.movieCardView.backgroundColor = [UIColor whiteColor];
    [self.movieCardView ggp_addShadowWithRadius:2 andOpacity:0.10];
    
    self.backgroundColor = [UIColor ggp_lightGray];
    self.layoutMargins = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureWithMallMovie:(GGPMallMovie *)mallMovie andSelectedDate:(NSDate *)selectedDate {
    self.movie = mallMovie.movie;
    self.movieNameLabel.text = self.movie.title;
    [self.moviePosterImageView setImageWithURL:self.movie.posterUrl];
    self.movieDetailsLabel.text = [NSString stringWithFormat:@"%@,  %@", self.movie.mpaaRating, [self.movie prettyPrintDuration]];
    
    [self.showtimeStackView configureWithMallMovie:mallMovie andSelectedDate:selectedDate];
}

@end
