//
//  GGPShowTimesStackView.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPShowtimeButton.h"
#import "GGPMallMovie.h"
#import "GGPShowtimeStackView.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIButton+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIStackView+GGPAdditions.h"

static NSInteger const kVerticalStackViewSpacing = 10;
static NSInteger const kHorizontalStackViewSpacing = 8;
static NSInteger const kShowtimesPerRow = 3;

@interface GGPShowtimeStackView ()

@property (strong, nonatomic) GGPMallMovie *mallMovie;
@property (strong, nonatomic) NSDate *selectedDate;
@property (assign, nonatomic) BOOL hasAddedNoShowtimesButton;

@end

@implementation GGPShowtimeStackView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.axis = UILayoutConstraintAxisVertical;
    self.spacing = kVerticalStackViewSpacing;
}

- (void)configureWithMallMovie:(GGPMallMovie *)mallMovie andSelectedDate:(NSDate *)selectedDate {
    [self ggp_clearArrangedSubviews];
    
    self.mallMovie = mallMovie;
    self.selectedDate = selectedDate;
    
    for (GGPMovieTheater *theater in mallMovie.showtimesLookup.allKeys) {
        [self addTheater:theater];
    }
}

- (void)addTheater:(GGPMovieTheater *)theater {
    NSArray *timesForSelectedDate = [self.mallMovie retrieveShowtimesForTheater:theater onSelectedDate:self.selectedDate];
    
    if (timesForSelectedDate.count == 0) {
        return;
    }
    
    UIStackView *showtimeStackView = [self stackViewForRow];
    
    if (self.mallMovie.numberOfTheatersAtMall > 1) {
        [self addArrangedSubview:[self labelForTheater:theater]];
    }
    
    for (GGPShowtime *showtime in timesForSelectedDate) {
        BOOL isLastShowtime = [showtime isEqual:timesForSelectedDate.lastObject];
        
        GGPShowtimeButton *button = [[GGPShowtimeButton alloc] initWithTheater:theater showtime:showtime andFandangoId:self.mallMovie.movie.fandangoId];
        [showtimeStackView addArrangedSubview:button];
        
        if (isLastShowtime) {
            // If showtimes aren't divisible by 3, add spacers needed to fill row with 3
            NSInteger spacersNeeded = [self spacersNeededForShowTimeCount:timesForSelectedDate.count];
            [self addSpacersToStackView:showtimeStackView forNumberOfSpacers:spacersNeeded];
        }
        
        if (isLastShowtime || showtimeStackView.arrangedSubviews.count == kShowtimesPerRow) {
            [self addArrangedSubview:showtimeStackView];
            showtimeStackView = [self stackViewForRow];
        }
    }
}

- (UILabel *)labelForTheater:(GGPMovieTheater *)theater {
    UILabel *label = [UILabel new];
    label.font = [UIFont ggp_regularWithSize:14];
    label.text = theater.name;
    return label;
}

- (void)addSpacersToStackView:(UIStackView *)stackView forNumberOfSpacers:(NSInteger)numberOfSpacers {
    for (NSInteger i = 0; i < numberOfSpacers; i++) {
        [stackView addArrangedSubview:[self stretchingView]];
    }
}

- (NSInteger)spacersNeededForShowTimeCount:(NSInteger)showTimeCount {
    return showTimeCount % kShowtimesPerRow == 0 ?
        0 :
        kShowtimesPerRow - ((showTimeCount + kShowtimesPerRow) % kShowtimesPerRow);
}

- (UIStackView *)stackViewForRow {
    UIStackView *stackView = [UIStackView new];
    stackView.spacing = kHorizontalStackViewSpacing;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentLeading;
    stackView.distribution = UIStackViewDistributionFillEqually;
    return stackView;
}

- (UIView *)stretchingView {
    UIView *stretchingView = [UIView new];
    [stretchingView setContentHuggingPriority:1 forAxis:UILayoutConstraintAxisHorizontal];
    stretchingView.backgroundColor = [UIColor clearColor];
    stretchingView.translatesAutoresizingMaskIntoConstraints = false;
    return stretchingView;
}

@end
