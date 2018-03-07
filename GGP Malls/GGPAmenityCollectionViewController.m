//
//  GGPAmenityCollectionViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAmenityCollectionViewController.h"
#import "GGPAmenityCollectionViewCell.h"
#import "GGPAmenity.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController+Amenities.h"
#import "UIColor+GGPAdditions.h"
#import "UIView+GGPAdditions.h"

@interface GGPAmenityCollectionViewController ()

@property (strong, nonatomic) NSArray *amenities;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation GGPAmenityCollectionViewController

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(GGPAmenityCollectionViewCellSize, GGPAmenityCollectionViewCellSize);
    layout.minimumInteritemSpacing = GGPAmenityCollectionViewCellSpacing;
    
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor ggp_lightGray];
    [self.collectionView ggp_addBorderRadius:5];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GGPAmenityCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:GGPAmenityCollectionViewCellReuseIdentifier];
}

- (void)configureWithAmenities:(NSArray *)amenities {
    self.amenities = amenities;
    [self resetAmenitySelection];
}

- (void)resetAmenitySelection {
    self.selectedIndex = -1;
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.amenities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGPAmenityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGPAmenityCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    GGPAmenity *amenity = self.amenities[indexPath.row];
    [cell configureWithAmenity:amenity];
    
    if (self.selectedIndex == indexPath.row) {
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[GGPJMapManager shared].mapViewController resetAmenityFilters];
    
    if (self.selectedIndex == indexPath.row) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        self.selectedIndex = -1;
        return NO;
    }

    self.selectedIndex = indexPath.row;
    GGPAmenity *amenity = self.amenities[indexPath.row];
    [[GGPJMapManager shared].mapViewController highlightAmenity:amenity];
    
    [self trackAmenity:amenity];
    
    return YES;
}

#pragma mark Analytics

- (void)trackAmenity:(GGPAmenity *)amenity {
    NSDictionary *data = @{ GGPAnalyticsContextDataAmenitiesCategory: amenity.name.lowercaseString };
    [[GGPAnalytics shared] trackAction:GGPAnalyticsActionAmenitiesCategory withData:data];
}

@end
