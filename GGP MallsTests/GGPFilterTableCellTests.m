//
//  GGPFilterTableCellTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/23/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPFilterTableCell.h"
#import "GGPFilterTableCellData.h"
#import "UIFont+GGPAdditions.h"
#import <Foundation/Foundation.h>

@interface GGPFilterTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@interface GGPFilterTableCellTests : XCTestCase

@property (strong, nonatomic) GGPFilterTableCell *cell;

@end

@implementation GGPFilterTableCellTests

- (void)setUp {
    [super setUp];
    self.cell = [GGPFilterTableCell new];
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testConfigureWithFilterCategory {
    NSString *mockName = @"mockName";
    NSString *expectedText = mockName;
    
    id mockCellData = OCMPartialMock([GGPFilterTableCellData new]);
    [OCMStub([mockCellData title]) andReturn:mockName];
    [OCMStub([mockCellData hasChildItems]) andReturnValue:OCMOCK_VALUE(NO)];
    
    [self.cell configureWithCellData:mockCellData];
    XCTAssertNotNil(self.cell.textLabel);
    XCTAssertEqual(self.cell.selectionStyle, UITableViewCellSelectionStyleNone);
    XCTAssertEqual(self.cell.accessoryType, UITableViewCellAccessoryNone);
    XCTAssertEqualObjects(self.cell.textLabel.text, expectedText);
}

- (void)testConfigureWithFilterCategoryHasSubCategories {
    NSString *mockName = @"mockName";
    NSString *expectedText = [NSString stringWithFormat:@"%@%@", mockName, @" (1)"];
    
    GGPCategory *mockFilterItem = OCMPartialMock([GGPCategory new]);
    GGPCategory *mockChildItem = OCMPartialMock([GGPCategory new]);
    [OCMStub([mockFilterItem childFilters]) andReturn:@[ mockChildItem ]];
    [OCMStub([mockFilterItem count]) andReturnValue:@(1)];
    
    id mockCellData = OCMPartialMock([GGPFilterTableCellData new]);
    [OCMStub([mockCellData title]) andReturn:mockName];
    [OCMStub([mockCellData filterItem]) andReturn:mockFilterItem];
    [OCMStub([mockCellData hasChildItems]) andReturnValue:OCMOCK_VALUE(YES)];
    
    [self.cell configureWithCellData:mockCellData];
    
    XCTAssertNotNil(self.cell.textLabel);
    XCTAssertEqual(self.cell.selectionStyle, UITableViewCellSelectionStyleNone);
    XCTAssertEqual(self.cell.accessoryType, UITableViewCellAccessoryDisclosureIndicator);
    XCTAssertEqualObjects(self.cell.textLabel.text, expectedText);
}

@end
