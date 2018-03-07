//
//  GGPTenantDetailRibbonCellTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/8/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantDetailRibbonCellData.h"
#import "GGPTenantDetailRibbonCell.h"

@interface GGPTenantDetailRibbonCell (Testing)

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *rightBorder;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@interface GGPTenantDetailRibbonCellTests : XCTestCase

@property (strong, nonatomic) GGPTenantDetailRibbonCell *cell;

@end

@implementation GGPTenantDetailRibbonCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[[NSBundle mainBundle] loadNibNamed:@"GGPTenantDetailRibbonCell" owner:self options:nil] lastObject];
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testOutlets {
    XCTAssertNotNil(self.cell.textLabel);
    XCTAssertNotNil(self.cell.rightBorder);
    XCTAssertNotNil(self.cell.imageView);
}

- (void)testConfigureCellWithCellDataNotLastCell {
    GGPTenantDetailRibbonCellData *mockData = OCMClassMock(GGPTenantDetailRibbonCellData.class);
    [OCMStub([mockData title]) andReturn:@"Title"];
    [OCMStub([mockData image]) andReturn:[UIImage new]];
    
    [self.cell configureCellWithCellData:mockData isLastCell:NO];
    
    XCTAssertEqualObjects(self.cell.textLabel.text, mockData.title);
    XCTAssertEqualObjects(self.cell.imageView.image, mockData.image);
    XCTAssertFalse(self.cell.rightBorder.hidden);
}

- (void)testConfigureCellWithCellDataIsLastCell {
    GGPTenantDetailRibbonCellData *mockData = OCMClassMock(GGPTenantDetailRibbonCellData.class);
    [self.cell configureCellWithCellData:mockData isLastCell:YES];
    XCTAssertTrue(self.cell.rightBorder.hidden);
}

@end
