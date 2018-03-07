//
//  GGPSearchTableViewCellTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPSearchTableViewCell.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "GGPMall.h"

@interface GGPSearchTableViewCellTests : XCTestCase

@property (strong, nonatomic) GGPSearchTableViewCell* cell;

@end

@interface GGPSearchTableViewCell (Testing)

@property (weak, nonatomic) IBOutlet UILabel *mallNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mallDistanceLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *mallLocationLabel;

@end

@implementation GGPSearchTableViewCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[NSBundle mainBundle] loadNibNamed:@"GGPSearchTableViewCell"
                                              owner:self
                                            options:nil].lastObject;
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testConfigureCellWithMallNoDistance {
    NSString *mallName = @"Mall Name";
    BOOL isLastCell = YES;
    GGPMall *mall = OCMPartialMock([GGPMall new]);
    [OCMStub([mall name]) andReturn:mallName];
    [self.cell configureCellWithMall:mall andIsLastCellInSection:isLastCell];
    XCTAssertEqualObjects(self.cell.mallNameLabel.text, mallName);
    XCTAssertTrue(self.cell.mallDistanceLabel.hidden);
    XCTAssertEqual(self.cell.separatorView.hidden, isLastCell);
}

- (void)testConfigureCellWithMallAndDistance {
    NSString *mallName = @"Mall Name";
    float floatDistance = 12.3242;
    NSString *distanceLabelText = [NSString stringWithFormat:@"%.1f miles", floatDistance];
    BOOL isLastCell = NO;
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall name]) andReturn:mallName];
    [OCMStub([mockMall distance]) andReturn:[NSNumber numberWithFloat:floatDistance]];
    [self.cell configureCellWithMall:mockMall andIsLastCellInSection:isLastCell];
    XCTAssertFalse(self.cell.mallDistanceLabel.hidden);
    XCTAssertEqual(self.cell.separatorView.hidden, isLastCell);
    XCTAssertEqualObjects(self.cell.mallNameLabel.text, mallName);
    XCTAssertEqualObjects(self.cell.mallDistanceLabel.text, distanceLabelText);
    
    [mockMall stopMocking];
}

- (void)testConfigureCellWithSearchResultMallWithDistanceOfOneMile {
    NSString *mallName = @"Mall Name";
    float floatDistance = 1;
    BOOL isLastCell = NO;
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall name]) andReturn:mallName];
    [OCMStub([mockMall distance]) andReturn:[NSNumber numberWithFloat:floatDistance]];
    
    [self.cell configureCellWithMall:mockMall andIsLastCellInSection:isLastCell];
    
    XCTAssertFalse(self.cell.mallDistanceLabel.hidden);
    XCTAssertEqual(self.cell.separatorView.hidden, isLastCell);
    XCTAssertEqualObjects(self.cell.mallNameLabel.text, mallName);
    XCTAssertEqualObjects(self.cell.mallDistanceLabel.text, @"1 mile");
}

- (void)testShowMallAddressIfExists {
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall cityStateAddress]) andReturn:@"mock address"];
    
    [self.cell configureCellWithMall:mockMall andIsLastCellInSection:YES];
    
    XCTAssertFalse(self.cell.mallLocationLabel.hidden);
}

- (void)testHideMallAddressIfEmpty {
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall cityStateAddress]) andReturn:@""];
    
    [self.cell configureCellWithMall:mockMall andIsLastCellInSection:YES];
    
    XCTAssertTrue(self.cell.mallLocationLabel.hidden);
}

@end
