//
//  GGPEventsTableViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPEvent.h"
#import "GGPEventDetailViewController.h"
#import "GGPEventsNoResultsView.h"
#import "GGPEventsTableViewController.h"
#import "GGPHomePromotionTableViewCell.h"
#import "GGPMallRepository.h"
#import "GGPSpinner.h"
#import "NSArray+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIImage+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import <AFNetworking/AFNetworking.h>

@interface GGPEventsTableViewController () <GGPPromotionCellDelegate>

@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSMutableArray *imageUrls;
@property (strong, nonatomic) NSMutableDictionary *eventImageDictionary;

@end

@implementation GGPEventsTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = [@"EVENTS_TITLE" ggp_toLocalized];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor ggp_gainsboroGray];
    
    self.imageUrls = [NSMutableArray new];
    self.eventImageDictionary = [NSMutableDictionary new];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"GGPHomePromotionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:GGPHomePromotionTableViewCellReuseIdentifier];
    self.tableView.backgroundView = [GGPEventsNoResultsView new];
    self.tableView.backgroundView.hidden = YES;
    
    [GGPSpinner showForView:self.view];
    [self fetchEvents];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchEvents) name:GGPClientEventsUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchEvents) name:GGPClientTenantsUpdatedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GGPAnalytics shared] trackScreen:GGPAnalyticsScreenEvents];
}

- (void)fetchEvents {
    [GGPMallRepository fetchEventsWithCompletion:^(NSArray *events) {
        self.events = [events ggp_sortListAscendingForKey:@"endDateTime"];
        self.tableView.backgroundView.hidden = self.events.count > 0;
        [UIImage ggp_fetchImagesForPromotions:self.events intoLookup:self.eventImageDictionary completion:^{
            [GGPSpinner hideForView:self.view];
            [self.tableView reloadData];
        }];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPHomePromotionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGPHomePromotionTableViewCellReuseIdentifier];
    cell.cellDelegate = self;
    GGPEvent *event = self.events[indexPath.row];
    UIImage *image = [self.eventImageDictionary objectForKey:@(event.eventId)];
    [cell configureWithPromotion:self.events[indexPath.row] andImage:image];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[GGPEventDetailViewController alloc] initWithEvent:self.events[indexPath.row]] animated:YES];
}

#pragma mark - Promotion Cell Delegate

- (void)didTapPostOptionsWithPromotion:(GGPPromotion *)promotion {
    UIAlertController *shareOptions = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (UIAlertAction *action in [self alertActionsForPromotion:promotion]) {
        [shareOptions addAction:action];
    }
    
    [self.navigationController presentViewController:shareOptions animated:YES completion:nil];
}

- (NSArray *)alertActionsForPromotion:(GGPPromotion *)promotion {
    NSMutableArray *shareActions = [NSMutableArray new];
    
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:[@"POST_OPTIONS_SHARE" ggp_toLocalized] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareActionTappedWithPromotion:promotion];
    }];
    [shareActions addObject:shareAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[@"POST_OPTIONS_CANCEL" ggp_toLocalized] style:UIAlertActionStyleCancel handler:nil];
    [shareActions addObject:cancelAction];
    
    return shareActions;
}

- (void)shareActionTappedWithPromotion:(GGPPromotion *)promotion {
    GGPEvent *event = (GGPEvent *)promotion;
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[event] applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
}

@end
