//
//  GGPShoppingRefineSortViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPRefineSortType.h"
#import "GGPShoppingRefineSortViewController.h"

static NSInteger const kEndDateRow = 0;
static NSInteger const kAlphaRow = 1;
static NSInteger const kReverseAlphaRow = 2;

@interface GGPShoppingRefineSortViewControllerTests : XCTestCase

@property GGPShoppingRefineSortViewController *sortViewController;

@end

@interface GGPShoppingRefineSortViewController (Testing)

- (GGPRefineSortType)sortTypeForRow:(NSInteger)row;

@end

@implementation GGPShoppingRefineSortViewControllerTests

- (void)setUp {
    [super setUp];
    self.sortViewController = [GGPShoppingRefineSortViewController new];
}

- (void)tearDown {
    self.sortViewController = nil;
    [super tearDown];
}

- (void)testSortTypeForRow {
    XCTAssertEqual([self.sortViewController sortTypeForRow:kEndDateRow], GGPRefineSortByEndDate);
    XCTAssertEqual([self.sortViewController sortTypeForRow:kAlphaRow], GGPRefineSortByAlpha);
    XCTAssertEqual([self.sortViewController sortTypeForRow:kReverseAlphaRow], GGPRefineSortByReverseAlpha);
}

@end
