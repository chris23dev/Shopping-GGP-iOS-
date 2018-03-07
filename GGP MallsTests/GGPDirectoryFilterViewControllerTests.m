//
//  GGPDirectoryFilterViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 11/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBrand.h"
#import "GGPProduct.h"
#import "GGPTenant.h"
#import "GGPFilterItem.h"
#import "GGPDirectoryFilterViewController.h"

@interface GGPDirectoryFilterViewControllerTests : XCTestCase

@property GGPDirectoryFilterViewController *filterViewController;

@end

@interface GGPDirectoryFilterViewController (Testing)

@property (assign, nonatomic) BOOL shouldShowFilterDescriptionLabel;
@property (strong, nonatomic) id<GGPFilterItem> selectedFilter;;

@end

@implementation GGPDirectoryFilterViewControllerTests

- (void)setUp {
    [super setUp];
    self.filterViewController = [GGPDirectoryFilterViewController new];
}

- (void)tearDown {
    self.filterViewController = nil;
    [super tearDown];
}

- (void)testShouldShowFilterDescriptionLabel {
    id mockFilter = OCMPartialMock([GGPBrand new]);
    [OCMStub([mockFilter filteredItems]) andReturn:@[[GGPTenant new], [GGPTenant new]]];
    self.filterViewController.selectedFilter = mockFilter;
    
    XCTAssertTrue(self.filterViewController.shouldShowFilterDescriptionLabel);
    
    mockFilter = OCMPartialMock([GGPProduct new]);
    [OCMStub([mockFilter filteredItems]) andReturn:@[[GGPTenant new], [GGPTenant new]]];
    self.filterViewController.selectedFilter = mockFilter;
    
    XCTAssertTrue(self.filterViewController.shouldShowFilterDescriptionLabel);
}

@end
