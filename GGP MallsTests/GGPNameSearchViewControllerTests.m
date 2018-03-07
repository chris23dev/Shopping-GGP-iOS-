//
//  GGPNameSearchViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPNameSearchViewController.h"

@interface GGPNameSearchViewControllerTests : XCTestCase

@property GGPNameSearchViewController *nameSearchViewController;
@property id mockNameSearchViewController;

@end

@interface GGPNameSearchViewController (Testing)

@property NSArray *malls;
@property NSArray *searchResults;

- (void)fetchMalls;
- (void)searchByName:(NSString *)searchString;

@end

@implementation GGPNameSearchViewControllerTests

- (void)setUp {
    [super setUp];
    self.nameSearchViewController = [GGPNameSearchViewController new];
    [self setupMocks];
    [self.nameSearchViewController view];
}

- (void)tearDown {
    self.nameSearchViewController = nil;
    self.nameSearchViewController = nil;
    [self tearDownMocks];
    [super tearDown];
}

- (void)setupMocks {
    id mockNameSearchViewController = OCMPartialMock(self.nameSearchViewController);
    OCMStub([mockNameSearchViewController fetchMalls]);
    self.mockNameSearchViewController = mockNameSearchViewController;
}

- (void)tearDownMocks {
    [self.mockNameSearchViewController stopMocking];
    self.mockNameSearchViewController = nil;
}

- (void)testPerformSearchWithParams {
    id mockMall1 = OCMPartialMock([GGPMall new]);
    id mockMall2 = OCMPartialMock([GGPMall new]);
    
    [OCMStub([mockMall1 name]) andReturn:@"Shake Shack"];
    [OCMStub([mockMall2 name]) andReturn:@"Banana Palace"];
    
    self.nameSearchViewController.malls = @[ mockMall1, mockMall2 ];
    
    [self.nameSearchViewController searchByName:@"a"];
    XCTAssertEqual(self.nameSearchViewController.searchResults.count, 2);
    XCTAssertEqual(self.nameSearchViewController.searchResults[0], mockMall2);
    XCTAssertEqual(self.nameSearchViewController.searchResults[1], mockMall1);
    
    [self.nameSearchViewController searchByName:@"banana"];
    XCTAssertEqual(self.nameSearchViewController.searchResults.count, 1);
    XCTAssertEqual(self.nameSearchViewController.searchResults[0], mockMall2);
    
    [self.nameSearchViewController searchByName:@"sha"];
    XCTAssertEqual(self.nameSearchViewController.searchResults.count, 1);
    XCTAssertEqual(self.nameSearchViewController.searchResults[0], mockMall1);
    
    [self.nameSearchViewController searchByName:@"banana shack"];
    XCTAssertEqual(self.nameSearchViewController.searchResults.count, 2);
    XCTAssertEqual(self.nameSearchViewController.searchResults[0], mockMall2);
    XCTAssertEqual(self.nameSearchViewController.searchResults[1], mockMall1);
    
    [self.nameSearchViewController searchByName:@"notaname"];
    XCTAssertEqual(self.nameSearchViewController.searchResults.count, 0);
}

@end
