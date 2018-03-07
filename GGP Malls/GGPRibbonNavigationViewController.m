//
//  GGPRibbonNavigationViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPRibbonNavigationViewController.h"
#import "GGPRibbonNavigationViewCell.h"
#import "GGPCellData.h"
#import "UIFont+GGPAdditions.h"
#import "GGPFixedSpaceFlowLayout.h"

static CGFloat const kCellPadding = 5;

@interface GGPRibbonNavigationViewController ()

@property (strong, nonatomic) NSArray *ribbonItems;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation GGPRibbonNavigationViewController

- (instancetype)init {
    self = [super initWithCollectionViewLayout:[GGPFixedSpaceFlowLayout new]];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionView];
}

- (void)configureWithRibbonItems:(NSArray *)ribbonItems {
    self.ribbonItems = ribbonItems;
    
    [self.collectionView reloadData];
    
    if (ribbonItems.count > 0) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)configureCollectionView {
    UINib *cellNib = [UINib nibWithNibName:@"GGPRibbonNavigationViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:GGPRibbonNavigationViewCellReuseIdentifier];
    
    self.collectionView.scrollEnabled = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.selectedIndex = 0;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ribbonItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGPRibbonNavigationViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGPRibbonNavigationViewCellReuseIdentifier forIndexPath:indexPath];
    
    GGPCellData *ribbonData = self.ribbonItems[indexPath.row];
    BOOL isSelected = self.selectedIndex == indexPath.row;
    [cell configureWithTitle:ribbonData.title andIsSelected:isSelected];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGPCellData *cellData = self.ribbonItems[indexPath.row];
    
    CGFloat cellWidth = [cellData.title sizeWithAttributes:@{ NSFontAttributeName: [UIFont ggp_boldWithSize:13] }].width;
    
    return CGSizeMake(cellWidth + kCellPadding, GGPRibbonNavigationViewCellHeight);
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    
    GGPCellData *cellData = self.ribbonItems[indexPath.row];
    if (cellData.tapHandler) {
        cellData.tapHandler();
    }
}

@end
