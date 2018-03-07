//
//  GGPTenantCardCollectionViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantCardCollectionViewController.h"
#import "GGPCardCollectionViewCell.h"

@interface GGPTenantCardCollectionViewController ()

@end

@implementation GGPTenantCardCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
}

- (void)registerCell {
    UINib *cardCell = [UINib nibWithNibName:@"GGPCardCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:cardCell forCellWithReuseIdentifier:GGPCardCollectionViewCellReuseIdentifier];
}

#pragma mark <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGPCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGPCardCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    cell.onWayfindingTapped = self.onWayfindingTapped;
    GGPTenant *tenant = self.data[indexPath.row];
    [cell configureWithTenant:tenant];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.onCardSelected) {
        self.onCardSelected(indexPath.row);
    }
}

@end
