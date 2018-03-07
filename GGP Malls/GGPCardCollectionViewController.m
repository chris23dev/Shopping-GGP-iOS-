//
//  GGPCardCollectionViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCardCollectionViewController.h"
#import "GGPEventDetailViewController.h"
#import "GGPCardCollectionViewCell.h"

static NSInteger const kMinimumItemSpacing = 20;
static NSInteger const kCellPadding = 60;

@implementation GGPCardCollectionViewController

- (instancetype)init {
    self = [super initWithCollectionViewLayout:[self createFlowLayout]];
    return self;
}

- (void)configureWithData:(NSArray *)data {
    self.data = data;
    [self.collectionView reloadData];
}

- (UICollectionViewFlowLayout *)createFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = kMinimumItemSpacing;
    flowLayout.minimumInteritemSpacing = kMinimumItemSpacing;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, kMinimumItemSpacing, 0, kMinimumItemSpacing);
    return flowLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    [self configureCollectionView];
}

- (void)registerCell {
    UINib *cardCell = [UINib nibWithNibName:@"GGPCardCollectionViewCell" bundle:NSBundle.mainBundle];
    [self.collectionView registerNib:cardCell forCellWithReuseIdentifier:GGPCardCollectionViewCellReuseIdentifier];
}

- (void)configureCollectionView {
    self.collectionView.clipsToBounds = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat cellWidth = screenWidth - kCellPadding;
    return CGSizeMake(cellWidth, GGPCardCollectionViewCellHeight);
}

#pragma mark - Analytics tracking

- (void)trackActionWithTitle:(NSString *)tileTitle type:(NSString *)tileType andRowIndex:(NSInteger)rowIndex {
    NSDictionary *data = @{ GGPAnalyticsContextDataTileName: tileTitle,
                            GGPAnalyticsContextDataTileType: tileType,
                            GGPAnalyticsContextDataTilePosition: [NSString stringWithFormat: @"%ld", (long)rowIndex]
                            };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionTileTap withData:data];
}

@end
