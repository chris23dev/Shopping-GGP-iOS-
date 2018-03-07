//
//  GGPTenantDetailRibbonCollectionViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPJMapManager.h"
#import "GGPTenant.h"
#import "GGPTenantDetailRibbonCell.h"
#import "GGPTenantDetailRibbonCollectionViewController.h"
#import "GGPWayfindingViewController.h"
#import "UIView+GGPAdditions.h"

@interface GGPTenantDetailRibbonCollectionViewController (Testing)

@property GGPTenant *tenant;
@property NSMutableArray *cells;

- (BOOL)shouldShowCallItem;
- (BOOL)shouldShowOpenTableItem;
- (BOOL)shouldShowFavoriteItem;

- (void)callTapped;
- (void)guideMeTapped;
- (void)openTableTapped;
- (void)configureCellData;;

@end

@interface GGPTenantDetailRibbonCollectionViewControllerTests : XCTestCase

@property GGPTenantDetailRibbonCollectionViewController *collectionViewController;

@end

@implementation GGPTenantDetailRibbonCollectionViewControllerTests

- (void)setUp {
    [super setUp];
    self.collectionViewController = [[GGPTenantDetailRibbonCollectionViewController alloc] initWithTenant:[GGPTenant new]];
}

- (void)tearDown {
    self.collectionViewController = nil;
    [super tearDown];
}

- (void)testViewDidLoad {
    [self.collectionViewController view];
    XCTAssertFalse(self.collectionViewController.collectionView.scrollEnabled);
    XCTAssertFalse(self.collectionViewController.collectionView.showsHorizontalScrollIndicator);
    XCTAssertFalse(self.collectionViewController.collectionView.showsVerticalScrollIndicator);
    XCTAssertEqualObjects(self.collectionViewController.collectionView.dataSource, self.collectionViewController);
}

- (void)testConfigureCallItem {
    id mockCollectionViewController = OCMPartialMock(self.collectionViewController);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    
    [OCMStub([mockTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockTenant phoneNumber]) andReturn:@"5551234567"];
    [OCMStub([mockCollectionViewController tenant]) andReturn:mockTenant];
    
    [self.collectionViewController configureCellData];
    
    XCTAssertTrue([mockCollectionViewController shouldShowCallItem]);
    XCTAssertEqual(self.collectionViewController.cells.count, 1);
}

- (void)testConfigureOpenTableItem {
    id mockCollectionViewController = OCMPartialMock(self.collectionViewController);
    id mockTenant = OCMClassMock([GGPTenant class]);
    
    [OCMStub([mockTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockTenant openTableId]) andReturnValue:@(1234)];
    [OCMStub([mockCollectionViewController tenant]) andReturn:mockTenant];
    
    [self.collectionViewController configureCellData];
    
    XCTAssertTrue([mockCollectionViewController shouldShowOpenTableItem]);
    XCTAssertEqual(self.collectionViewController.cells.count, 1);
}

- (void)testConfigureGuideMeItem {
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockCollectionViewController = OCMPartialMock(self.collectionViewController);
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    id mockJMapManager = OCMPartialMock([GGPJMapManager shared]);
    [OCMStub([mockJMapManager wayfindingAvailableForTenant:OCMOCK_ANY]) andReturnValue:@YES];
    
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockCollectionViewController tenant]) andReturn:mockTenant];
    
    [self.collectionViewController configureCellData];
    
    XCTAssertEqual(self.collectionViewController.cells.count, 1);
    
    [mockMallManager stopMocking];
    [mockJMapManager stopMocking];
}

- (void)testConfigureFavoriteItem {
    id mockCollectionViewController = OCMPartialMock(self.collectionViewController);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    
    [OCMStub([mockTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockTenant placeWiseRetailerId]) andReturnValue:@(1234)];
    [OCMStub([mockCollectionViewController tenant]) andReturn:mockTenant];
    
    [self.collectionViewController configureCellData];
    
    XCTAssertTrue([mockCollectionViewController shouldShowFavoriteItem]);
    XCTAssertEqual(self.collectionViewController.cells.count, 1);
}

- (void)testCallButtonTapped {
    id mockTenant = OCMClassMock([GGPTenant class]);
    [OCMStub([mockTenant phoneNumber]) andReturn:@"5551234567"];
    
    id mockApplication = OCMPartialMock([UIApplication sharedApplication]);
    id mockNSURL = OCMClassMock([NSURL class]);
    
    self.collectionViewController.tenant = mockTenant;
    
    NSURL *url = [NSURL URLWithString:@"telprompt://5551234567"];
    OCMExpect([mockNSURL URLWithString:@"telprompt://5551234567"]);
    [OCMStub([mockNSURL URLWithString:OCMOCK_ANY]) andReturn:url];
    OCMExpect([mockApplication openURL:url]);
    
    [self.collectionViewController callTapped];
    
    OCMVerify(mockApplication);
    OCMVerify(mockNSURL);
    [mockApplication stopMocking];
    [mockNSURL stopMocking];
}

- (void)testGuideMeTapped {
    id mockController = OCMPartialMock(self.collectionViewController);
    id mockNavController = OCMPartialMock([UINavigationController new]);
    
    [OCMStub([mockController navigationController]) andReturn:mockNavController];
    
    OCMExpect([mockNavController pushViewController:[OCMArg isKindOfClass:[GGPWayfindingViewController class]] animated:YES]);
    
    [self.collectionViewController guideMeTapped];
    
    OCMVerify(mockNavController);
}

- (void)testOpenTableTapped {
    id mockTenant = OCMClassMock([GGPTenant class]);
    [OCMStub([mockTenant openTableId]) andReturnValue:@(1234)];
    [OCMStub([mockTenant name]) andReturn:@"Mock tenant name"];
    
    id mockApplication = OCMPartialMock([UIApplication sharedApplication]);

    self.collectionViewController.tenant = mockTenant;
    
    NSString *urlString = @"http://www.opentable.com";
    NSURL *url = [NSURL URLWithString:urlString];
    
    id mockNSURL = OCMClassMock([NSURL class]);
    [OCMStub([mockNSURL URLWithString:OCMOCK_ANY]) andReturn:url];
    
    OCMExpect([mockNSURL URLWithString:urlString]);
    OCMExpect([mockApplication openURL:url]);
    
    [self.collectionViewController openTableTapped];
    
    OCMVerify(mockApplication);
    OCMVerify(mockNSURL);
    [mockApplication stopMocking];
    [mockNSURL stopMocking];
}

@end
