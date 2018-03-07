//
//  GGPMovieDetailViewController.m
//  GGP Malls
//
//  Created by Janet Lin on 2/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPShowtimeStackView.h"
#import "GGPMall.h"
#import "GGPMallMovie.h"
#import "GGPMallRepository.h"
#import "GGPMovieDatesCollectionViewController.h"
#import "GGPMovieDetailViewController.h"
#import "GGPNavigationTitleView.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UINavigationController+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"
#import "NSArray+GGPAdditions.h"
#import "UIStackView+GGPAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

static NSString* const kDateFormat = @"MMM d";

@interface GGPMovieDetailViewController () <GGPMovieDatesCollectionDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreDurationLabel;
@property (weak, nonatomic) IBOutlet UIView *datePickerContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerContainerViewTopConstraint;
@property (assign, nonatomic) CGFloat datePickerInitialY;

@property (weak, nonatomic) IBOutlet UILabel *showtimesHeaderLabel;
@property (weak, nonatomic) IBOutlet GGPShowtimeStackView *showtimeStackView;
@property (weak, nonatomic) IBOutlet UIButton *noShowtimesButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showtimeHeaderTopConstraint;

@property (weak, nonatomic) IBOutlet UILabel *plotSummaryHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *plotSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *castHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *castLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreInfoHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreInfoLabel;

@property (strong, nonatomic) GGPMallMovie *mallMovie;
@property (strong, nonatomic) GGPMovie *movie;
@property (strong, nonatomic) NSDate *selectedDate;

@end

@implementation GGPMovieDetailViewController

- (instancetype)initWithMallMovie:(GGPMallMovie *)mallMovie andSelectedDate:(NSDate *)selectedDate {
    self = [super init];
    if (self) {
        self.mallMovie = mallMovie;
        self.movie = mallMovie.movie;
        self.selectedDate = selectedDate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"MOVIE_DETAILS_TITLE" ggp_toLocalized];
    
    [self configureNavigationBar];
    [self configureTextStyling];
    [self configureTextWithMovie];
    [self configureDatePicker];
    [self configureNoShowtimesButton];
    [self configureShowtimesStackView];
    [self configureShareButton];
    
    self.scrollView.delegate = self;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBar];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    [super viewWillDisappear:animated];
}

- (void)configureShareButton {
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonTapped)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void)configureNavigationBar {
    [self.navigationController ggp_configureWithDarkText];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)configureTextStyling {
    self.titleLabel.font = [UIFont ggp_boldWithSize:14];
    self.genreDurationLabel.font = [UIFont ggp_mediumWithSize:13];
    self.showtimesHeaderLabel.font = [UIFont ggp_boldWithSize:14];
    self.plotSummaryHeaderLabel.font = [UIFont ggp_boldWithSize:14];
    self.plotSummaryLabel.font = [UIFont ggp_lightWithSize:13];
    self.castHeaderLabel.font = [UIFont ggp_boldWithSize:14];
    self.castLabel.font = [UIFont ggp_lightWithSize:13];
    self.moreInfoHeaderLabel.font = [UIFont ggp_boldWithSize:14];
    self.moreInfoLabel.font = [UIFont ggp_lightWithSize:13];
}

- (void)configureTextWithMovie {
    [self.posterImageView setImageWithURL:self.movie.posterUrl];
    self.titleLabel.text = self.movie.title;
    self.genreDurationLabel.text = [self prettyPrintDetails];
    self.showtimesHeaderLabel.text = [self prettyPrintShowtimeHeaderDate:self.selectedDate];
    
    self.plotSummaryLabel.text = self.movie.synopsis;
    self.plotSummaryHeaderLabel.text = self.plotSummaryLabel.text ? [@"MOVIE_DETAILS_PLOT_SUMMARY_HEADER" ggp_toLocalized] : nil;
    
    self.castHeaderLabel.text = self.movie.actors.count > 0 ? [@"MOVIE_DETAILS_CAST_HEADER" ggp_toLocalized] : nil;
    self.castLabel.text = self.movie.actors.count > 0 ? [self prettyPrintCast]: nil;
    
    self.moreInfoHeaderLabel.text = self.movie.director || self.movie.distributor ? [@"MOVIE_DETAILS_MORE_INFO_HEADER" ggp_toLocalized] : nil;
    self.moreInfoLabel.text = [self prettyPrintMoreInfo];
}

- (NSString *)prettyPrintMoreInfo {
    NSString *directorString = [NSString stringWithFormat:[@"MOVIE_DETAILS_DIRECTOR_LABEL" ggp_toLocalized], self.movie.director];
    NSString *distributorString = [NSString stringWithFormat:[@"MOVIE_DETAILS_DISTRIBUTOR_LABEL" ggp_toLocalized], self.movie.distributor];
    if (self.movie.director && self.movie.distributor) {
        return [NSString stringWithFormat:@"%@\n%@", directorString, distributorString];
    } else if (self.movie.director) {
        return directorString;
    } else if (self.movie.distributor) {
        return distributorString;
    }
    return nil;
}

- (NSString *)prettyPrintDetails {
    NSString *genres = [self.movie.genres componentsJoinedByString:@"/"];
    NSString *duration = [self.movie prettyPrintDuration];
    return genres.length ? [NSString stringWithFormat:@"%@,  %@", genres, duration] : duration;
}

- (NSString *)prettyPrintCast {
    NSString *cast = [self.movie.actors componentsJoinedByString:@", "];
    return [NSString stringWithFormat:[@"MOVIE_DETAILS_CAST_LABEL" ggp_toLocalized], cast, self.movie.title];
}

- (NSString *)prettyPrintShowtimeHeaderDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = kDateFormat;
    return [NSString stringWithFormat:[@"MOVIE_DETAILS_SHOWTIMES_HEADER" ggp_toLocalized], [dateFormatter stringFromDate:date]];
}

- (void)configureDatePicker {
    self.datePickerContainerView.backgroundColor = [UIColor clearColor];
    NSArray *datesForWeek = [NSDate ggp_upcomingWeekDatesForStartDate:[NSDate new]];
    
    GGPMovieDatesCollectionViewController *datePicker = [[GGPMovieDatesCollectionViewController alloc] initWithShowtimeDates:datesForWeek andSelectedDate:self.selectedDate];
    datePicker.dateCollectionDelegate = self;

    [self ggp_addChildViewController:datePicker toPlaceholderView:self.datePickerContainerView];
}

- (NSArray *)determineShowtimeDatesForMovie:(GGPMovie *)movie {
    NSMutableArray *unsortedDates = [NSMutableArray new];
    for (GGPShowtime *showtime in movie.showtimes) {
        NSDate* dateWithoutTime = [[NSCalendar currentCalendar] startOfDayForDate:showtime.movieShowtimeDate];
        if (dateWithoutTime && ![unsortedDates containsObject:dateWithoutTime]) {
            [unsortedDates addObject:dateWithoutTime];
        }
    }
    return [unsortedDates sortedArrayUsingSelector:@selector(compare:)];
}

- (void)configureNoShowtimesButton {
    [self.noShowtimesButton ggp_styleAsDarkActionButton];
    self.noShowtimesButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 6);
    self.noShowtimesButton.backgroundColor = [UIColor ggp_pastelGray];
    self.noShowtimesButton.titleLabel.font = [UIFont ggp_regularWithSize:14];
    [self.noShowtimesButton setTitle:[@"MOVIES_NO_TIMES_TODAY_LABEL" ggp_toLocalized]
                            forState:UIControlStateNormal];
    [self.noShowtimesButton sizeToFit];

    [self.noShowtimesButton ggp_collapseVertically];
}

- (void)configureShowtimesStackView {
    [self.showtimeStackView configureWithMallMovie:self.mallMovie andSelectedDate:self.selectedDate];
}

- (void)shareButtonTapped {
    GGPMovieTheater *theater = self.mallMovie.showtimesLookup.allKeys.count == 1 ?
        self.mallMovie.showtimesLookup.allKeys.firstObject :
        nil;
    
    self.movie.theaterName = theater ? theater.name : @"";
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[self.movie]
                                                        applicationActivities:nil];
    
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.datePickerContainerViewTopConstraint.constant = MAX(self.datePickerInitialY, scrollView.contentOffset.y);
}

#pragma mark - <GGPMovieDatesCollectionDelegate>

- (void)selectedDate:(NSDate *)date {
    BOOL isPlayingForDate = [self.mallMovie isPlayingOnSelectedDate:date];
    
    if (isPlayingForDate) {
        [self.noShowtimesButton ggp_collapseVertically];
        [self.showtimeStackView configureWithMallMovie:self.mallMovie andSelectedDate:date];
    } else {
        [self.noShowtimesButton ggp_expandVertically];
        [self.showtimeStackView ggp_clearArrangedSubviews];
    }
    
    self.showtimesHeaderLabel.text = [self prettyPrintShowtimeHeaderDate:date];
}

@end
