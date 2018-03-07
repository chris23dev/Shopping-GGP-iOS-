//
//  GGPCardCollectionViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCardCollectionViewController.h"

@interface GGPCardCollectionViewControllerTests : XCTestCase

@property GGPCardCollectionViewController *collectionViewController;

@end

@interface GGPCardCollectionViewController (Testing)

- (void)configureCollectionView;

@end

@implementation GGPCardCollectionViewControllerTests

- (void)setUp {
    [super setUp];
    self.collectionViewController = [[GGPCardCollectionViewController alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
}

- (void)tearDown {
    self.collectionViewController = nil;
    [super tearDown];
}

- (void)testCollectionViewConfiguration {
    [self.collectionViewController configureCollectionView];
    XCTAssertFalse(self.collectionViewController.collectionView.clipsToBounds);
    XCTAssertEqualObjects(self.collectionViewController.collectionView.backgroundColor, [UIColor clearColor]);
    XCTAssertFalse(self.collectionViewController.collectionView.showsHorizontalScrollIndicator);
    XCTAssertFalse(self.collectionViewController.collectionView.showsVerticalScrollIndicator);
    XCTAssertEqualObjects(self.collectionViewController.collectionView.dataSource, self.collectionViewController);
}

@end
