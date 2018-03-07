//
//  GGPMovieTheaterTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPSpinner.h"
#import "GGPMallRepository.h"
#import "GGPViewCell.h"
#import "GGPFeedbackManager.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPMovieTheaterDetailStackView.h"
#import "GGPMovieDatesCollectionViewController.h"
#import "GGPMovieDetailViewController.h"
#import "GGPMoviesDatePickerHeaderView.h"
#import "GGPMoviesTableViewCell.h"
#import "GGPMallMovie.h"
#import "GGPMovie.h"
#import "GGPMovieTheater.h"
#import "GGPMovieTheaterDetailsCell.h"
#import "GGPMultiTheaterDetailViewController.h"
#import "GGPMovieTheaterNoMoviesCell.h"
#import "GGPNavigationTitleView.h"
#import "GGPTenantDetailViewController.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import "NSArray+GGPAdditions.h"
#import "GGPMovieTheaterTableViewController.h"

static CGFloat const kTheaterHeaderSection = 0;
static CGFloat const kMovieListSection = 1;

@interface GGPMovieTheaterTableViewController () <GGPMovieDatesCollectionDelegate,
GGPMovieTheaterDetailsCellDelegate>

@property (strong, nonatomic) NSArray <GGPMallMovie *> *mallMovies;
@property (strong, nonatomic) NSArray <GGPMovieTheater *> *theaters;
@property (strong, nonatomic) GGPMovieTheater *theater;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSArray *mallMoviesWithShowtimes;
@property (strong, nonatomic) GGPMovieDatesCollectionViewController *datesCollectionViewController;
@property (assign, nonatomic, readonly) BOOL moviesAreShowingForSelectedDate;

@end

@implementation GGPMovieTheaterTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = [@"MOVIES_TITLE" ggp_toLocalized];
        self.selectedDate = [NSDate date];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self fetchTheaters];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchTheaters) name:GGPMallManagerMallUpdatedNotification object:nil];
    
    [GGPFeedbackManager trackAction];
}

- (void)configureTableView {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = GGPEstimatedMovieCellHeight;
    
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = UITableViewAutomaticDimension;
    
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerCells];
}

- (void)fetchTheaters {
    [GGPSpinner showForView:self.view];
    
    [GGPMallRepository fetchMallMoviesWithCompletion:^(NSArray *theaters, NSArray *mallMovies) {
        [GGPSpinner hideForView:self.view];
        self.theaters = theaters;
        self.mallMovies = mallMovies;
        [self configureWithTheaters:self.theaters andMallMovies:self.mallMovies];
    }];
}

- (void)configureWithTheaters:(NSArray *)theaters andMallMovies:(NSArray *)mallMovies {
    self.mallMovies = mallMovies;
    self.theaters = theaters;
    self.theater = theaters.count == 1 ? self.theaters.firstObject : nil;
    
    self.mallMoviesWithShowtimes = [GGPMallMovie mallMoviesFromList:self.mallMovies
                                                    forSelectedDate:self.selectedDate];
    
    [self configureDatesCollectionViewController];
    [self.tableView reloadData];
    [self trackScreen];
}

- (void)configureDatesCollectionViewController {
    self.datesCollectionViewController = [[GGPMovieDatesCollectionViewController alloc] initWithShowtimeDates:[NSDate ggp_upcomingWeekDatesForStartDate:[NSDate date]] andSelectedDate:self.selectedDate];
    
    self.datesCollectionViewController.dateCollectionDelegate = self;
    self.datesCollectionViewController.collectionView.backgroundColor = [UIColor ggp_lightGray];
}

- (void)registerCells {
    UINib *moviesCellNib = [UINib nibWithNibName:@"GGPMoviesTableViewCell" bundle:nil];
    [self.tableView registerNib:moviesCellNib forCellReuseIdentifier:GGPMoviesCellReuseIdentifier];
    
    UINib *noMoviesCellNib = [UINib nibWithNibName:@"GGPMovieTheaterNoMoviesCell" bundle:nil];
    [self.tableView registerNib:noMoviesCellNib forCellReuseIdentifier:GGPMovieTheaterNoMoviesCellReuseIdentifier];
    
    UINib *detailsCellNib = [UINib nibWithNibName:@"GGPMovieTheaterDetailsCell" bundle:nil];
    [self.tableView registerNib:detailsCellNib forCellReuseIdentifier:GGPMovieTheaterDetailsCellReuseIdentifier];
    [self.tableView registerClass:GGPViewCell.class forCellReuseIdentifier:GGPViewCellId];
    
    UINib *datePickerNib = [UINib nibWithNibName:@"GGPMoviesDatePickerHeaderView" bundle:nil];
    [self.tableView registerNib:datePickerNib forHeaderFooterViewReuseIdentifier:GGPMoviesDatePickerHeaderViewReuseIdentifier];
}

- (BOOL)moviesAreShowingForSelectedDate {
    return self.mallMoviesWithShowtimes.count > 0;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.theaters.count == 0) {
        return 0;
    }
    
    return section == kTheaterHeaderSection || !self.moviesAreShowingForSelectedDate ?
        1 :
        self.mallMoviesWithShowtimes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == kTheaterHeaderSection ? 0 : GGPMoviesDatePickerHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.datesCollectionViewController) {
        return nil;
    }
    
    GGPMoviesDatePickerHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:GGPMoviesDatePickerHeaderViewReuseIdentifier];
    [self ggp_addChildViewController:self.datesCollectionViewController toPlaceholderView:headerView];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == kTheaterHeaderSection ?
        [self determineMovieTheaterDetailCellForTableView:tableView] :
        [self determineMoviesCellForTableView:tableView andIndexPath:indexPath];
}

#pragma mark - Theater Detail Cell

- (UITableViewCell *)determineMovieTheaterDetailCellForTableView:(UITableView *)tableView {
    return self.theaters.count == 1 ?
        [self singleMovieTheaterDetailsCellForTableView:tableView] :
        [self multiMovieTheaterDetailCellForTableView:tableView];
}

#pragma mark - Single Theater Detail

- (GGPMovieTheaterDetailsCell *)singleMovieTheaterDetailsCellForTableView:(UITableView *)tableView {
    GGPMovieTheaterDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPMovieTheaterDetailsCellReuseIdentifier];
    
    NSString *location = [[GGPJMapManager shared].mapViewController locationDescriptionForTenant:self.theater];
    [cell configureWithTheaterName:self.theater.name Location:location andImageUrl:self.theater.tenantLogoUrl];
    
    cell.theaterDetailCellDelegate = self;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

#pragma mark - Multi Theater Detail

- (UITableViewCell *)multiMovieTheaterDetailCellForTableView:(UITableView *)tableView {
    GGPViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPViewCellId];
    
    GGPMovieTheaterDetailStackView *detailStackView = [GGPMovieTheaterDetailStackView new];
    [detailStackView configureWithTheaters:self.theaters andParentViewController:self];
    [cell configureWithView:detailStackView];
    
    return cell;
}

#pragma mark - Movies cell

- (UITableViewCell *)determineMoviesCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    return self.moviesAreShowingForSelectedDate ?
        [self dequeueMovieCellForTableView:tableView atIndexPath:indexPath] :
        [self dequeuNoMoviesCellForTableView:tableView];
}

#pragma mark - Detail Movies Cell

- (GGPMoviesTableViewCell *)dequeueMovieCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    GGPMoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPMoviesCellReuseIdentifier forIndexPath:indexPath];
    
    GGPMallMovie *mallMovie = self.mallMoviesWithShowtimes[indexPath.row];
    
    [cell configureWithMallMovie:mallMovie andSelectedDate:self.selectedDate];
    
    return cell;
}

#pragma mark - No Movies Cell

- (GGPMovieTheaterNoMoviesCell *)dequeuNoMoviesCellForTableView:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:GGPMovieTheaterNoMoviesCellReuseIdentifier];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kMovieListSection) {
        GGPMallMovie *movie = self.mallMoviesWithShowtimes[indexPath.row];
        GGPMovieDetailViewController *movieDetailViewController = [[GGPMovieDetailViewController alloc] initWithMallMovie:movie andSelectedDate:self.selectedDate];
        [self.navigationController pushViewController:movieDetailViewController animated:YES];
    }
}

#pragma mark - Single Theater GGPMovieTheaterDetailsCellDelegate

- (void)handleTheaterNameButtonTapped {
    GGPTenantDetailViewController *detailViewController = [[GGPTenantDetailViewController alloc] initWithTenantDetails:self.theater];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - GGPMovieDatesCollectionDelegate

- (void)selectedDate:(NSDate *)date {
    self.selectedDate = date;
    self.mallMoviesWithShowtimes = [GGPMallMovie mallMoviesFromList:self.mallMovies forSelectedDate:self.selectedDate];
    [self.tableView reloadData];
}

#pragma mark - Analytics 

- (void)trackScreen {
    for (GGPMovieTheater *theater in self.theaters) {
        [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenMovies withTenant:theater.name];
    }
}

@end
