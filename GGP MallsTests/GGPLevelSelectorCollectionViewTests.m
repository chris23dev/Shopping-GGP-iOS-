//
//  GGPLevelSelectorCollectionViewTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPLevelCell.h"
#import "GGPLevelSelectorCollectionViewController.h"
#import <JMap/JMap.h>
#import <XCTest/XCTest.h>

@interface GGPLevelSelectorCollectionViewTests : XCTestCase

@property GGPLevelSelectorCollectionViewController *levelSelectorViewController;
@property NSArray *floors;

@end

@interface GGPLevelSelectorCollectionViewController (Testing)

@property NSInteger selectedIndex;
@property CGFloat cellWidth;
@property NSArray *mallFloors;
- (void)configureCollectionView;
- (void)registerCell;
- (BOOL)floorHasLongDescription;

@end

@implementation GGPLevelSelectorCollectionViewTests

- (void)setUp {
    [super setUp];
    JMapFloor *mockFloor = OCMClassMock(JMapFloor.class);
    self.levelSelectorViewController = [[GGPLevelSelectorCollectionViewController alloc] initWithFloors:@[mockFloor] selectedIndex:0];
    [self.levelSelectorViewController view];
}

- (void)tearDown {
    self.levelSelectorViewController = nil;
    [super tearDown];
}

- (void)testViewDidLoad {
    XCTAssertFalse(self.levelSelectorViewController.collectionView.showsHorizontalScrollIndicator);
    XCTAssertFalse(self.levelSelectorViewController.collectionView.showsVerticalScrollIndicator);
    XCTAssertEqualObjects(self.levelSelectorViewController.collectionView.dataSource, self.levelSelectorViewController);
}

- (void)testRegisterCellNib {
    GGPLevelCell *cell = [self.levelSelectorViewController.collectionView dequeueReusableCellWithReuseIdentifier:GGPLevelCellReuseIdentifier forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(cell);
}

@end
