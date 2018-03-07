//
//  GGPMovie.m
//  GGP Malls
//
//  Created by Janet Lin on 12/10/15.
//  Copyright (c) 2015 GGP. All rights reserved.
//

#import "GGPMovie.h"
#import "NSString+GGPAdditions.h"
#import "GGPMallManager.h"
#import "GGPMall.h"

static NSString *const kPrefixThe = @"THE ";

@interface GGPMovie ()

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *mpaaRating;
@property (assign, nonatomic) NSInteger duration;
@property (strong, nonatomic) NSArray *showtimes;

@end

@implementation GGPMovie

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"smallPosterImageURL": @"smallPosterImageUrl",
             @"largePosterImageURL": @"largePosterImageUrl",
             @"title": @"title",
             @"mpaaRating": @"mpaaRating",
             @"duration": @"runTimeInMinutes",
             @"actors": @"actors",
             @"director": @"director",
             @"distributor": @"distributor",
             @"genres": @"genres",
             @"synopsis": @"synopsis",
             @"fandangoId": @"fandangoId",
             @"movieId": @"id",
             @"parentId": @"parentId",
             @"showtimes": @"showtimes"
             };
}

+ (NSValueTransformer *)showtimesJSONTransformer {
    return  [MTLJSONAdapter arrayTransformerWithModelClass:GGPShowtime.class];
}

- (NSArray *)retrieveScheduleForDate:(NSDate *)date {
    NSMutableArray *filteredShowtimes = [NSMutableArray new];
    
    for (GGPShowtime *time in self.showtimes) {
        if ([time isScheduledForDate:date]) {
            [filteredShowtimes addObject:time];
        }
    }
    
    NSMutableSet *unsortedSet = [[NSMutableSet alloc] initWithArray:filteredShowtimes];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"movieShowtimeDate" ascending:YES];
    
    return [unsortedSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (NSURL *)posterUrl {
    return [NSURL URLWithString:self.largePosterImageURL];
}

- (NSString *)prettyPrintDuration {
    int hours = (int)self.duration / 60;
    int minutes = self.duration % 60;
    return [NSString stringWithFormat:@"%d %@ %02d %@", hours, [@"MOVIE_DURATION_HOUR_LABEL" ggp_toLocalized], minutes, [@"MOVIE_DURATION_MINUTE_LABEL" ggp_toLocalized]];
}

- (NSString *)sortTitle {
    if ([[self.title uppercaseString] hasPrefix:kPrefixThe]) {
        return [self.title substringFromIndex:kPrefixThe.length];
    }
    return self.title;
}

#pragma mark UIActivityItemSource

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    return activityType == UIActivityTypeMail ? [NSString stringWithFormat:@"%@ | %@", self.title, self.theaterName] : nil;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    NSString *mallUrl = [GGPMallManager shared].selectedMall.websiteUrl;
    NSString *movieUrl = [NSString stringWithFormat:[@"SHARE_MOVIE_URL" ggp_toLocalized], mallUrl, (long)self.movieId];
    
    if (activityType == UIActivityTypeMail) {
        NSString *body = [NSString stringWithFormat:[@"SHARE_MOVIE_EMAIL_BODY" ggp_toLocalized], self.theaterName, [GGPMallManager shared].selectedMall.name, movieUrl];
        return [NSString stringWithFormat:@"%@%@", body, [@"SHARE_EMAIL_FOOTER" ggp_toLocalized]];
    } else {
        return [NSString stringWithFormat:@"%@ | %@ %@", self.title, self.theaterName, movieUrl];
    }
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

@end
