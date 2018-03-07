//
//  GGPParkingAvailabilityTimeCollectionViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingAvailabilityTimeCell.h"
#import "GGPParkingAvailabilityTimeCellData.h"
#import "GGPParkingAvailabilityTimeCollectionViewController.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

static NSInteger const kNowCellIndex = 0;
static NSInteger const kFirstCellIndex = 0;
static NSInteger const kLastCellIndexWithoutNowCell = 3;

@interface GGPParkingAvailabilityTimeCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *times;
@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) GGPCellData *nowCell;
@property (assign, nonatomic) BOOL hasNowCell;

@end

@implementation GGPParkingAvailabilityTimeCollectionViewController

- (instancetype)init {
    self = [super initWithCollectionViewLayout:[self createFlowLayout]];
    if (self) {
        self.hasNowCell = YES;
    }
    return self;
}

- (UICollectionViewFlowLayout *)createFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    return flowLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    [self configureCollectionView];
}

- (void)registerCell {
    UINib *timeCell = [UINib nibWithNibName:@"GGPParkingAvailabilityTimeCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:timeCell forCellWithReuseIdentifier:GGPParkingAvailabilityTimeCellReuseIdentifier];
}

- (void)configureCollectionView {
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    self.collectionView.clipsToBounds = YES;
    self.times = [self timesDataForCollection];
    
    [self.collectionView reloadData];
}

- (NSMutableArray *)timesDataForCollection {
    self.nowCell = [[GGPParkingAvailabilityTimeCellData alloc]
                    initWithTitle:[@"PARKING_AVAILABILITY_NOW" ggp_toLocalized]
                    activeImage:[UIImage imageNamed:@"ggp_icon_parking_now_active"]
                    inactiveImage:[UIImage imageNamed:@"ggp_icon_parking_now_inactive"]
                    arrivalTimeHour:GGPParkingAvailabilityArrivalTimeNow
                    andTapHandler:nil];
    
    GGPParkingAvailabilityTimeCellData *morningCell = [[GGPParkingAvailabilityTimeCellData alloc]
                                    initWithTitle:[@"PARKING_AVAILABILITY_MORNING" ggp_toLocalized]
                                    activeImage:[UIImage imageNamed:@"ggp_icon_parking_morning_active"]
                                    inactiveImage:[UIImage imageNamed:@"ggp_icon_parking_morning_inactive"]
                                    arrivalTimeHour:GGPParkingAvailabilityArrivalTimeMorning
                                    andTapHandler:nil];
    
    GGPParkingAvailabilityTimeCellData *afternoonCell = [[GGPParkingAvailabilityTimeCellData alloc]
                                      initWithTitle:[@"PARKING_AVAILABILITY_AFTERNOON" ggp_toLocalized]
                                      activeImage:[UIImage imageNamed:@"ggp_icon_parking_afternoon_active"]
                                      inactiveImage:[UIImage imageNamed:@"ggp_icon_parking_afternoon_inactive"]
                                      arrivalTimeHour:GGPParkingAvailabilityArrivalTimeAfternoon
                                      andTapHandler:nil];
    
    GGPParkingAvailabilityTimeCellData *eveningCell = [[GGPParkingAvailabilityTimeCellData alloc]
                                    initWithTitle:[@"PARKING_AVAILABILITY_EVENING" ggp_toLocalized]
                                    activeImage:[UIImage imageNamed:@"ggp_icon_parking_evening_active"]
                                    inactiveImage:[UIImage imageNamed:@"ggp_icon_parking_evening_inactive"]
                                    arrivalTimeHour:GGPParkingAvailabilityArrivalTimeEvening
                                    andTapHandler:nil];
    
    return @[ self.nowCell, morningCell, afternoonCell, eveningCell ].mutableCopy;
}

- (void)configureWithSelectedDate:(NSDate *)selectedDate {
    if ([selectedDate ggp_isToday] && !self.hasNowCell) {
        self.hasNowCell = YES;
        self.selectedRow = [self incrementNowSelectedRow];
        [self.times insertObject:self.nowCell atIndex:kNowCellIndex];
    }
    
    if (![selectedDate ggp_isToday] && self.hasNowCell) {
        self.hasNowCell = NO;
        self.selectedRow = [self decrementNowSelectedRow];
        [self.times removeObjectAtIndex:kNowCellIndex];
    }
    
    GGPParkingAvailabilityTimeCellData *cellData = self.times[self.selectedRow];
    [self.timeDelegate didSelectTime:cellData.title withArrivalTimeHour:cellData.arrivalTimeHour];
    [self.collectionView reloadData];
}

- (NSInteger)incrementNowSelectedRow {
    return self.selectedRow < kLastCellIndexWithoutNowCell ? ++self.selectedRow : 0;
}

- (NSInteger)decrementNowSelectedRow {
    return self.selectedRow > kFirstCellIndex ? --self.selectedRow : 0;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.times.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGPParkingAvailabilityTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGPParkingAvailabilityTimeCellReuseIdentifier forIndexPath:indexPath];
    GGPCellData *timeData = self.times[indexPath.row];
    BOOL isLastCell = indexPath.row == self.times.count - 1;
    BOOL isSelected = indexPath.row == self.selectedRow;
    [cell configureWithTimeData:timeData isLastCell:isLastCell isSelected:isSelected];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.selectedRow) {
        self.selectedRow = indexPath.row;
        [self.collectionView reloadData];
        GGPParkingAvailabilityTimeCellData *cellData = self.times[indexPath.row];
        [self.timeDelegate didSelectTime:cellData.title withArrivalTimeHour:cellData.arrivalTimeHour];
    }
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = self.collectionView.bounds.size.width / self.times.count;
    return CGSizeMake(cellWidth, GGPParkingAvailabilityTimeCellHeight);
}

@end
