//
//  GGPParkingGarageLevelViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingGarageLevelViewController.h"
#import "GGPParkingLevel.h"
#import "GGPParkingZone.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "NSString+GGPAdditions.h"

@interface GGPParkingGarageLevelViewController ()

@property (weak, nonatomic) IBOutlet UILabel *levelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *availableProgressView;
@property (weak, nonatomic) IBOutlet UIView *occupiedProgressView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (strong, nonatomic) GGPParkingLevel *level;
@property (strong, nonatomic) GGPParkingZone *zone;

- (CGFloat)progressViewConstraintMultiplier;

@end

@interface GGPParkingGarageLevelViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPParkingGarageLevelViewController *viewController;

@end

@implementation GGPParkingGarageLevelViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPParkingGarageLevelViewController new];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testConfigureControlsSpotsAvailable {
    id mockLevel = OCMPartialMock([GGPParkingLevel new]);
    id mockZone = OCMPartialMock([GGPParkingZone new]);
    
    [OCMStub([mockLevel levelName]) andReturn:@"level 1"];
    
    [OCMStub([mockZone availableSpots]) andReturnValue:OCMOCK_VALUE(10)];
    [OCMStub([mockZone occupiedSpots]) andReturnValue:OCMOCK_VALUE(5)];
    
    self.viewController.level = mockLevel;
    self.viewController.zone = mockZone;
    
    [self.viewController view];
    
    XCTAssertEqualObjects(self.viewController.levelNameLabel.text, @"level 1");
    XCTAssertEqualObjects(self.viewController.countLabel.textColor, [UIColor ggp_green]);
    XCTAssertEqualObjects(self.viewController.countLabel.text, @"10");
    XCTAssertEqualObjects(self.viewController.separatorView.backgroundColor, [UIColor whiteColor]);
}

- (void)testConfigureControlsLotFull {
    id mockLevel = OCMPartialMock([GGPParkingLevel new]);
    id mockZone = OCMPartialMock([GGPParkingZone new]);
    
    [OCMStub([mockLevel levelName]) andReturn:@"level 1"];
    [OCMStub([mockLevel levelDescription]) andReturn:@"entrance"];
    
    [OCMStub([mockZone availableSpots]) andReturnValue:OCMOCK_VALUE(0)];
    [OCMStub([mockZone occupiedSpots]) andReturnValue:OCMOCK_VALUE(5)];
    
    self.viewController.level = mockLevel;
    self.viewController.zone = mockZone;
    
    [self.viewController view];
    
    XCTAssertEqualObjects(self.viewController.levelNameLabel.text, @"level 1*");
    XCTAssertEqualObjects(self.viewController.countLabel.textColor, [UIColor ggp_darkRed]);
    XCTAssertEqualObjects(self.viewController.countLabel.text, [@"PARKING_GARAGE_FULL" ggp_toLocalized]);
    XCTAssertEqualObjects(self.viewController.separatorView.backgroundColor, [UIColor ggp_manateeGray]);
}

- (void)testProgressViewConstraintMultiplier {
    id mockZone = OCMPartialMock([GGPParkingZone new]);
    
    [OCMStub([mockZone availableSpots]) andReturnValue:OCMOCK_VALUE(15)];
    [OCMStub([mockZone occupiedSpots]) andReturnValue:OCMOCK_VALUE(5)];
    
    self.viewController.zone = mockZone;
    
    CGFloat result = [self.viewController progressViewConstraintMultiplier];
    
    XCTAssertEqual(result, 0.25f);
}

@end
