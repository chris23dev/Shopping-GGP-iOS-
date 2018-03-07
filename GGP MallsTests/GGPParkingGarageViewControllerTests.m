//
//  GGPParkingGarageViewControllerTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 10/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPParkingGarageViewController.h"
#import "UIColor+GGPAdditions.h"
#import "UIView+GGPAdditions.h"

@interface GGPParkingGarageViewController (Testing)

@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupiedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableCountLabel;
@property (weak, nonatomic) IBOutlet UIView *progressDividerView;
@property (weak, nonatomic) IBOutlet UILabel *entranceLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionsLabel;
@property (strong, nonatomic) GGPParkingGarage *garage;

+ (NSInteger)totalAvailableSpotsFromZones:(NSArray *)zones;
+ (NSInteger)totalOccupiedSpotsFromZones:(NSArray *)zones;
+ (NSDictionary *)createLevelToZoneLookupWithLevels:(NSArray *)levels andZones:(NSArray *)zones;
- (void)configureProgressView;
- (NSLayoutConstraint *)progressWidthConstraintForOccupiedSpots:(NSInteger)occupiedSpots andAvailableSpots:(NSInteger)availableSpots;
- (void)configureEntranceLabel;
- (void)configureDirections;

@end

@interface GGPParkingGarageViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPParkingGarageViewController *viewController;

@end

@implementation GGPParkingGarageViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [GGPParkingGarageViewController new];
}

- (void)tearDown {
    self.viewController = nil;
    [super tearDown];
}

- (void)testTotalAvailableSpots {
    GGPParkingZone *zone1 = [GGPParkingZone new];
    GGPParkingZone *zone2 = [GGPParkingZone new];
    zone1.availableSpots = 1;
    zone2.availableSpots = 2;
    
    NSInteger spots = [GGPParkingGarageViewController totalAvailableSpotsFromZones:@[zone1, zone2]];
    XCTAssertEqual(3, spots);
    
    spots = [GGPParkingGarageViewController totalAvailableSpotsFromZones:@[]];
    XCTAssertEqual(0, spots);
    
    spots = [GGPParkingGarageViewController totalAvailableSpotsFromZones:nil];
    XCTAssertEqual(0, spots);
}

- (void)testTotalOccupiedSpots {
    GGPParkingZone *zone1 = [GGPParkingZone new];
    GGPParkingZone *zone2 = [GGPParkingZone new];
    zone1.occupiedSpots = 5;
    zone2.occupiedSpots = 20;
    
    NSInteger spots = [GGPParkingGarageViewController totalOccupiedSpotsFromZones:@[zone1, zone2]];
    XCTAssertEqual(25, spots);
    
    spots = [GGPParkingGarageViewController totalOccupiedSpotsFromZones:@[]];
    XCTAssertEqual(0, spots);
    
    spots = [GGPParkingGarageViewController totalOccupiedSpotsFromZones:nil];
    XCTAssertEqual(0, spots);
}

- (void)testCreateLevelToZoneLookup {
    GGPParkingLevel *level1 = [GGPParkingLevel new];
    GGPParkingLevel *level2 = [GGPParkingLevel new];
    GGPParkingLevel *level3 = [GGPParkingLevel new];
    level1.levelId = 1;
    level2.levelId = 2;
    level3.levelId = 3;
    level1.zoneName = @"zone1";
    level2.zoneName = @"zone2";
    
    GGPParkingZone *zone1 = [GGPParkingZone new];
    GGPParkingZone *zone2 = [GGPParkingZone new];
    zone1.zoneName = @"zone1";
    zone2.zoneName = @"zone2";
    
    NSArray *levels = @[level1, level2, level3];
    NSArray *zones = @[zone1, zone2];
    NSDictionary *lookup = [GGPParkingGarageViewController createLevelToZoneLookupWithLevels:levels andZones:zones];
    
    XCTAssertEqual(2, lookup.count);
    XCTAssertEqualObjects(zone1, lookup[@(level1.levelId)]);
    XCTAssertEqualObjects(zone2, lookup[@(level2.levelId)]);
}

- (void)testConfigureProgressViewSpotsAvailable {
    id mockController = OCMClassMock([GGPParkingGarageViewController class]);
    
    [OCMStub([mockController totalAvailableSpotsFromZones:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(10)];
    [OCMStub([mockController totalOccupiedSpotsFromZones:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(20)];
    
    [self.viewController view];
    
    XCTAssertEqualObjects(self.viewController.availableLabel.textColor, [UIColor ggp_green]);
    XCTAssertEqualObjects(self.viewController.occupiedCountLabel.text, @"20");
    XCTAssertEqualObjects(self.viewController.availableCountLabel.text, @"10");
    XCTAssertEqualObjects(self.viewController.availableCountLabel.textColor, [UIColor ggp_green]);
    XCTAssertEqualObjects(self.viewController.progressDividerView.backgroundColor, [UIColor whiteColor]);
    
    [mockController stopMocking];
}

- (void)testConfigureProgressViewGarageFull {
    id mockController = OCMClassMock([GGPParkingGarageViewController class]);
    
    [OCMStub([mockController totalAvailableSpotsFromZones:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(0)];
    [OCMStub([mockController totalOccupiedSpotsFromZones:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(20)];
    
    [self.viewController view];
    
    XCTAssertEqualObjects(self.viewController.availableLabel.textColor, [UIColor ggp_darkRed]);
    XCTAssertEqualObjects(self.viewController.occupiedCountLabel.text, @"20");
    XCTAssertEqualObjects(self.viewController.availableCountLabel.text, @"FULL");
    XCTAssertEqualObjects(self.viewController.availableCountLabel.textColor, [UIColor ggp_darkRed]);
    XCTAssertEqualObjects(self.viewController.progressDividerView.backgroundColor, [UIColor ggp_manateeGray]);
    
    [mockController stopMocking];
}

- (void)testConfigureEntranceExists {
    id mockGarage = OCMPartialMock([GGPParkingGarage new]);
    [OCMStub([mockGarage garageDescription]) andReturn:@"a garage"];
    
    id mockLabel = OCMPartialMock([UILabel new]);
    id mockController = OCMPartialMock(self.viewController);
    [OCMStub([mockController entranceLabel]) andReturn:mockLabel];
    [OCMStub([mockController garage]) andReturn:mockGarage];
    
    [[mockLabel reject] ggp_collapseVertically];
    
    [self.viewController configureEntranceLabel];
    
    OCMVerifyAll(mockLabel);
}

- (void)testConfigureEntranceDoesntExists {
    id mockGarage = OCMPartialMock([GGPParkingGarage new]);
    [OCMStub([mockGarage garageDescription]) andReturn:@""];
    
    id mockLabel = OCMPartialMock([UILabel new]);
    id mockController = OCMPartialMock(self.viewController);
    [OCMStub([mockController entranceLabel]) andReturn:mockLabel];
    [OCMStub([mockController garage]) andReturn:mockGarage];
    
    OCMExpect([mockLabel ggp_collapseVertically]);
    
    [self.viewController configureEntranceLabel];
    
    OCMVerifyAll(mockLabel);
}

- (void)testConfigureDirectionsExists {
    id mockGarage = OCMPartialMock([GGPParkingGarage new]);
    [OCMStub([mockGarage latitude]) andReturn:@(10)];
    [OCMStub([mockGarage longitude]) andReturn:@(10)];
    
    id mockLabel = OCMPartialMock([UILabel new]);
    id mockController = OCMPartialMock(self.viewController);
    [OCMStub([mockController directionsLabel]) andReturn:mockLabel];
    [OCMStub([mockController garage]) andReturn:mockGarage];
    
    [[mockLabel reject] ggp_collapseVertically];
    
    [self.viewController configureDirections];
    
    OCMVerifyAll(mockLabel);
}

- (void)testConfigureDirectionsDoesntExist {
    id mockGarage = OCMPartialMock([GGPParkingGarage new]);
    [OCMStub([mockGarage latitude]) andReturn:@(10)];
    [OCMStub([mockGarage longitude]) andReturn:nil];
    
    id mockLabel = OCMPartialMock([UILabel new]);
    id mockController = OCMPartialMock(self.viewController);
    [OCMStub([mockController directionsLabel]) andReturn:mockLabel];
    [OCMStub([mockController garage]) andReturn:mockGarage];
    
    OCMExpect([mockLabel ggp_collapseVertically]);
    
    [self.viewController configureDirections];
    
    OCMVerifyAll(mockLabel);
}

@end
