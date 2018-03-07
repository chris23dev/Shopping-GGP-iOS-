//
//  GGPLevelCellTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPLevelCell.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import <JMap/JMap.h>
#import <XCTest/XCTest.h>

@interface GGPLevelCellTests : XCTestCase

@property GGPLevelCell *cell;

@end

@interface GGPLevelCell (Testing)

@property (weak, nonatomic) IBOutlet UIView *filterCountView;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

@property IBOutlet UILabel *label;
@property IBOutlet UIImageView *imageView;
@property IBOutlet UIView *topBorder;
@property IBOutlet UIView *rightBorder;
@property IBOutlet UIView *bottomBorder;
@property IBOutlet UIView *leftBorder;

@property JMapFloor *floor;
@property NSInteger filterCount;
@property BOOL isActive;
@property BOOL hasFilterCount;

- (void)configureIconForFloor;
- (BOOL)floorIsStartFloor;
- (BOOL)floorIsEndFloor;
- (BOOL)shouldShowStartIcon;
- (BOOL)shouldShowEndIcon;

@end

@implementation GGPLevelCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[[NSBundle mainBundle] loadNibNamed:@"GGPLevelCell" owner:self options:nil] lastObject];
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testOutlets {
    XCTAssertNotNil(self.cell.label);
    XCTAssertNotNil(self.cell.imageView);
    XCTAssertNotNil(self.cell.topBorder);
    XCTAssertNotNil(self.cell.rightBorder);
    XCTAssertNotNil(self.cell.bottomBorder);
    XCTAssertNotNil(self.cell.leftBorder);
    
}

- (void)testConfigureCell {
    XCTAssertEqualObjects(self.cell.label.font, [UIFont ggp_regularWithSize:14]);
    XCTAssertNotNil(self.cell.bottomBorder);
    XCTAssertEqualObjects(self.cell.bottomBorder.backgroundColor, [UIColor blackColor]);
}

- (void)testConfigureCellWithLongFloorDescription {
    JMapFloor *mockFloor = OCMPartialMock([JMapFloor new]);
    
    [OCMStub([mockFloor description]) andReturn:@"Mockfloor description"];
    
    [self.cell configureCellWithFloor:mockFloor filterText:nil isActive:YES andIsBottomCell:NO];
    XCTAssertEqual(self.cell.label.text.length, 6);
}

- (void)testConfigureCellWithFilterCountInactive {
    JMapFloor *mockFloor = OCMPartialMock([JMapFloor new]);
    NSInteger filterCount = 1;
    NSString *expectedFilterLabel = [NSString stringWithFormat:@"%ld", (long)filterCount];
    
    [self.cell configureCellWithFloor:mockFloor filterText:expectedFilterLabel isActive:NO andIsBottomCell:NO];
    
    XCTAssertEqualObjects(self.cell.filterLabel.text, expectedFilterLabel);
    XCTAssertFalse(self.cell.filterCountView.hidden);
    XCTAssertFalse(self.cell.filterLabel.hidden);
}

- (void)testConfigureCellWithFilterCountActive {
    JMapFloor *mockFloor = OCMPartialMock([JMapFloor new]);
    NSInteger filterCount = 1;
    NSString *expectedFilterLabel = [NSString stringWithFormat:@"%ld", (long)filterCount];
    
    [self.cell configureCellWithFloor:mockFloor filterText:expectedFilterLabel isActive:YES andIsBottomCell:NO];
    
    XCTAssertEqualObjects(self.cell.filterLabel.text, expectedFilterLabel);
    XCTAssertTrue(self.cell.filterCountView.hidden);
}

- (void)testConfigureCellNoFilterCount {
    JMapFloor *mockFloor = OCMPartialMock([JMapFloor new]);
    
    [self.cell configureCellWithFloor:mockFloor filterText:nil isActive:YES andIsBottomCell:NO];
    
    XCTAssertTrue(self.cell.filterCountView.hidden);
    XCTAssertTrue(self.cell.filterLabel.hidden);
}

- (void)testActiveStyle {
    JMapFloor *mockFloor = OCMPartialMock([JMapFloor new]);
    [self.cell configureCellWithFloor:mockFloor filterText:nil isActive:YES andIsBottomCell:NO];
    XCTAssertEqualObjects(self.cell.label.backgroundColor, [UIColor ggp_blue]);
    XCTAssertEqualObjects(self.cell.label.textColor, [UIColor whiteColor]);
}

- (void)testInActiveStyle {
    JMapFloor *mockFloor = OCMPartialMock([JMapFloor new]);
    [self.cell configureCellWithFloor:mockFloor filterText:nil isActive:NO andIsBottomCell:NO];
    XCTAssertEqualObjects(self.cell.label.backgroundColor, [UIColor ggp_colorFromHexString:@"#FEFEFE" andAlpha:0.85]);
    XCTAssertEqualObjects(self.cell.label.textColor, [UIColor ggp_colorFromHexString:@"#333333"]);
}

- (void)testShouldShowStartIcon {
    id mockCell = OCMPartialMock(self.cell);
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    JMapFloor *mockStartFloor = OCMPartialMock([JMapFloor new]);
    JMapFloor *mockCellFloor = OCMPartialMock([JMapFloor new]);
    
    [OCMStub([mockMapController wayfindingStartFloor]) andReturn:mockStartFloor];
    [OCMStub([mockStartFloor mapId]) andReturn:@(123)];
    [OCMStub([mockCellFloor mapId]) andReturn:@(123)];
    
    OCMExpect([mockCell shouldShowStartIcon]);
    
    self.cell.floor = mockCellFloor;
    self.cell.isActive = NO;
    
    XCTAssertTrue([self.cell floorIsStartFloor]);
    XCTAssertFalse([self.cell floorIsEndFloor]);
    
    [self.cell configureIconForFloor];
    
    OCMVerifyAll(mockCell);
    [mockMapController stopMocking];
}

- (void)testShouldShowEndIcon {
    id mockCell = OCMPartialMock(self.cell);
    id mockMapController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    JMapFloor *mockEndFloor = OCMPartialMock([JMapFloor new]);
    JMapFloor *mockStartFloor = OCMPartialMock([JMapFloor new]);
    JMapFloor *mockCellFloor = OCMPartialMock([JMapFloor new]);
    
    [OCMStub([mockStartFloor mapId]) andReturn:@(133)];
    [OCMStub([mockEndFloor mapId]) andReturn:@(123)];
    [OCMStub([mockCellFloor mapId]) andReturn:@(123)];
    [OCMStub([mockMapController wayfindingEndFloor]) andReturn:mockEndFloor];
    
    OCMExpect([mockCell shouldShowEndIcon]);
    
    self.cell.floor = mockCellFloor;
    self.cell.isActive = NO;
    
    XCTAssertTrue([self.cell floorIsEndFloor]);
    XCTAssertFalse([self.cell floorIsStartFloor]);
    
    [self.cell configureIconForFloor];
    
    OCMVerifyAll(mockCell);
    [mockMapController stopMocking];
}

@end
