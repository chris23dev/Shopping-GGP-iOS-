//
//  GGPLevelSelectorCollectionViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPJMapViewController+Levels.h"
#import "GGPLevelCell.h"
#import "GGPLevelSelectorCollectionViewController.h"

@interface GGPLevelSelectorCollectionViewController ()

@property (strong, nonatomic) NSArray *mallFloors;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (assign, nonatomic) CGFloat cellWidth;

@end

@implementation GGPLevelSelectorCollectionViewController

- (instancetype)initWithFloors:(NSArray *)mallFloors selectedIndex:(NSInteger)selectedIndex {
    self = [super initWithCollectionViewLayout:[self createFlowLayout]];
    if (self) {
        self.mallFloors = mallFloors;
        self.selectedIndex = selectedIndex;
    }
    return self;
}

- (UICollectionViewFlowLayout *)createFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    return flowLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    [self configureCollectionView];
}

- (void)registerCell {
    UINib *datesCellNib = [UINib nibWithNibName:@"GGPLevelCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:datesCellNib forCellWithReuseIdentifier:GGPLevelCellReuseIdentifier];
}

- (void)configureCollectionView {
    self.collectionView.scrollEnabled = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)updateWithFloors:(NSArray *)mallFloors selectedIndex:(NSInteger)selectedIndex {
    self.mallFloors = mallFloors;
    self.selectedIndex = selectedIndex;
    [self.collectionView reloadData];
}

- (void)updateWithSelectedFloor:(JMapFloor *)floor {
    self.selectedIndex = [self.mallFloors indexOfObject:floor];
    [self.collectionView reloadData];
}

- (CGFloat)cellWidth {
    NSInteger maxLength = 0;
    for (JMapFloor *floor in self.mallFloors) {
        NSInteger length = MIN(GGPLevelCellMaxStringLength, floor.description.length);
        if (length > maxLength) {
            maxLength = length;
        }
    }
    return [GGPLevelCell determineCellWidthForDescriptionLength:maxLength];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mallFloors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGPLevelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGPLevelCellReuseIdentifier forIndexPath:indexPath];
    JMapFloor *floor = self.mallFloors[indexPath.row];
    NSString *filterText = [[GGPJMapManager shared].mapViewController filterTextForFloor:floor];
    BOOL isBottomCell = indexPath.row == self.mallFloors.count - 1;
    BOOL isActive = self.selectedIndex == indexPath.row;
    
    [cell configureCellWithFloor:floor filterText:filterText isActive:isActive andIsBottomCell:isBottomCell];
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.cellWidth, GGPLevelCellHeight);
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.selectedIndex) {
        self.selectedIndex = indexPath.row;
        [self.collectionView reloadData];
        [self.levelSelectorDelegate levelCellWasTapped:self.mallFloors[indexPath.row]];
    }
}

@end
