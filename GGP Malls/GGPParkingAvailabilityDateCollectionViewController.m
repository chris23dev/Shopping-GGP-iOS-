//
//  GGPParkingAvailabilityDateCollectionViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/28/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPParkingAvailabilityDateCell.h"
#import "GGPParkingAvailabilityDateCollectionViewController.h"
#import "NSDate+GGPAdditions.h"

static CGFloat const kFractionalCellVisibility = 0.25;
static NSInteger const kMinimumNumberOfCells = 3;

@interface GGPParkingAvailabilityDateCollectionViewController ()

@property (strong, nonatomic) NSArray *dates;
@property (assign, nonatomic) NSInteger selectedRow;
@property (assign, nonatomic) CGFloat dynamicWidthForCell;

@end

@implementation GGPParkingAvailabilityDateCollectionViewController

- (instancetype)init {
    self = [super initWithCollectionViewLayout:[self createFlowLayout]];
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
    UINib *dateCell = [UINib nibWithNibName:@"GGPParkingAvailabilityDateCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:dateCell forCellWithReuseIdentifier:GGPParkingAvailabilityDateCellReuseIdentifier];
}

- (void)configureCollectionView {
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    self.dates = [NSDate ggp_upcomingWeekDatesForStartDate:[NSDate new]];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGPParkingAvailabilityDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGPParkingAvailabilityDateCellReuseIdentifier forIndexPath:indexPath];
    BOOL isLastCell = indexPath.row == self.dates.count - 1;
    BOOL isSelectedCell = indexPath.row == self.selectedRow;
    NSDate *dayOfWeek = self.dates[indexPath.row];
    [cell configureWithDate:dayOfWeek isLastCell:isLastCell isSelected:isSelectedCell];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.selectedRow) {
        self.selectedRow = indexPath.row;
        [self.collectionView reloadData];
        [self.dateDelegate didSelectDate:self.dates[self.selectedRow]];
    }
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.dynamicWidthForCell, GGPParkingAvailabilityDateCellHeight);
}

- (CGFloat)dynamicWidthForCell {
    return self.collectionView.frame.size.width / self.fractionalCellCount;
}

- (CGFloat)fractionalCellCount {
    NSInteger fractionCellCount = self.collectionView.frame.size.width / GGPParkingAvailabilityDateCellWidth;
    fractionCellCount = fractionCellCount >= kMinimumNumberOfCells ? fractionCellCount : kMinimumNumberOfCells;
    return fractionCellCount + kFractionalCellVisibility;
}

@end
