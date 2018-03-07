//
//  GGPWayfindingRouteDetailTableViewCellTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPWayfindingRouteDetailTableViewCell.h"
#import <JMap/JMap.h>
#import <XCTest/XCTest.h>

@interface GGPWayfindingRouteDetailTableViewCellTests : XCTestCase

@property GGPWayfindingRouteDetailTableViewCell *cell;

@end

@interface GGPWayfindingRouteDetailTableViewCell (Testing)

@property (weak, nonatomic) IBOutlet UIImageView *directionImageView;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (strong, nonatomic) NSDictionary *instructionImageDictionary;

@end

@implementation GGPWayfindingRouteDetailTableViewCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[NSBundle mainBundle] loadNibNamed:@"GGPWayfindingRouteDetailTableViewCell" owner:self options:nil][0];
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testOutlets {
    XCTAssertNotNil(self.cell.directionImageView);
    XCTAssertNotNil(self.cell.directionLabel);
}

- (void)testConfigureWithDirectionInstruction {
    JMapTextDirectionInstruction *mockDirectionInstruction = OCMClassMock(JMapTextDirectionInstruction.class);
    [OCMStub([mockDirectionInstruction output]) andReturn:@"Turn Left"];
    [self.cell configureCellWithDirectionInstruction:mockDirectionInstruction];
    XCTAssertEqualObjects(self.cell.directionLabel.text, mockDirectionInstruction.output);
}

@end
