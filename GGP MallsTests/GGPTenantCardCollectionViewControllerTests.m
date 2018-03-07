//
//  GGPTenantCardCollectionViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 6/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCardCollectionViewCell.h"
#import "GGPTenant.h"
#import "GGPTenantCardCollectionViewController.h"
#import "GGPTenantDetailViewController.h"

@interface GGPTenantCardCollectionViewControllerTests : XCTestCase

@property GGPTenantCardCollectionViewController *collectionViewController;

@end

@implementation GGPTenantCardCollectionViewControllerTests

- (void)setUp {
    [super setUp];
    self.collectionViewController = [GGPTenantCardCollectionViewController new];
}

- (void)tearDown {
    self.collectionViewController = nil;
    [super tearDown];
}

- (void)testCellForItemAtIndex {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    id mockTenant = OCMClassMock([GGPTenant class]);
    id mockCollectionView = OCMPartialMock(self.collectionViewController.collectionView);
    NSArray *mockData = @[ mockTenant ];
    self.collectionViewController.data = mockData;
    
    id mockCell = OCMClassMock([GGPCardCollectionViewCell class]);
    
    [OCMStub([mockCollectionView dequeueReusableCellWithReuseIdentifier:GGPCardCollectionViewCellReuseIdentifier forIndexPath:path]) andReturn:mockCell];
    
    OCMExpect([mockCell configureWithTenant:mockTenant]);
    
    [self.collectionViewController collectionView:self.collectionViewController.collectionView cellForItemAtIndexPath:path];
    
    OCMVerifyAll(mockCell);
}

- (void)testDidSelectItemAtIndexPath {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    self.collectionViewController.onCardSelected = ^(NSInteger index) {
        [expectation fulfill];
    };
    [self.collectionViewController collectionView:self.collectionViewController.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

@end
