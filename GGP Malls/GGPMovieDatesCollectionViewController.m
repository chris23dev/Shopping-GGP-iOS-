//
//  GGPMovieDatesCollectionViewController.m
//  GGP Malls
//
//  Created by Janet Lin on 2/3/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMovie.h"
#import "GGPMovieDatesCell.h"
#import "GGPMovieDatesCollectionViewController.h"
#import "GGPShowtime.h"
#import "UIColor+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"

@interface GGPMovieDatesCollectionViewController ()

@property (strong, nonatomic) NSArray *showtimeDates;
@property (strong, nonatomic) NSIndexPath *selectedDatePath;

@end

@implementation GGPMovieDatesCollectionViewController

- (instancetype)initWithShowtimeDates:(NSArray *)showtimeDates andSelectedDate:(NSDate *)selectedDate {
    self = [super initWithCollectionViewLayout:[self createFlowLayout]];
    if (self) {
        self.showtimeDates = showtimeDates;
        NSInteger index = [NSDate ggp_daysFromDate:[NSDate new] toDate:selectedDate];
        self.selectedDatePath = [NSIndexPath indexPathForRow:index inSection:0];
    }
    return self;
}

- (UICollectionViewFlowLayout *)createFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    return flowLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionView];
    [self registerCalendarDateCell];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView scrollToItemAtIndexPath:self.selectedDatePath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)configureCollectionView {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
}

- (void)registerCalendarDateCell {
    UINib *datesCellNib = [UINib nibWithNibName:@"GGPMovieDatesCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:datesCellNib forCellWithReuseIdentifier:GGPMovieDatesCellReuseIdentifier];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showtimeDates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGPMovieDatesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGPMovieDatesCellReuseIdentifier forIndexPath:indexPath];
    [cell configureWithDate:self.showtimeDates[indexPath.row]
                   isActive:[self.selectedDatePath
                             isEqual:indexPath]];
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(GGPMovieDatesCellWidth, GGPMovieDatesCellHeight);
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![indexPath isEqual:self.selectedDatePath]) {
        self.selectedDatePath = indexPath;
        [self.collectionView reloadData];
        [self.dateCollectionDelegate selectedDate:self.showtimeDates[indexPath.row]];
    }
}

@end
