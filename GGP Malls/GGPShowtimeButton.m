//
//  GGPShowtimeButton.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovieTheater.h"
#import "GGPShowtime.h"
#import "GGPShowtimeButton.h"
#import "UIButton+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

@interface GGPShowtimeButton ()

@property (strong, nonatomic) GGPMovieTheater *theater;
@property (strong, nonatomic) GGPShowtime *showtime;
@property (assign, nonatomic) NSInteger fandangoId;

@end

@implementation GGPShowtimeButton

- (instancetype)initWithTheater:(GGPMovieTheater *)theater showtime:(GGPShowtime *)showtime andFandangoId:(NSInteger)fandangoId {
    self = [super init];
    if (self) {
        self.theater = theater;
        self.showtime = showtime;
        self.fandangoId = fandangoId;
        
        [self configureButton];
    }
    return self;
}

- (void)configureButton {
    [self ggp_styleAsDarkActionButton];
    self.titleLabel.font = [UIFont ggp_regularWithSize:11];
    [self setTitle:self.showtime.movieShowtime forState:UIControlStateNormal];
    
    self.backgroundColor = self.showtime.movieShowtimeDate.timeIntervalSinceNow > 0 ?
        [UIColor ggp_blue] :
        [UIColor ggp_pastelGray];
    
    self.userInteractionEnabled = self.showtime.movieShowtimeDate.timeIntervalSinceNow > 0;
    
    [self addTarget:self action:@selector(showTimeTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showTimeTapped {
    NSString *urlString = self.fandangoId > 0 ?
        [self.showtime determineFandangoUrlForFandangoId:self.fandangoId andTmsId:self.theater.tmsId] :
        self.theater.websiteUrl;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

@end
