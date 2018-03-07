//
//  GGPCarLocationCellTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 10/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCarLocationCell.h"
#import "GGPParkingCarLocation.h"
#import "GGPParkAssistClient.h"
#import "GGPParkingLevel.h"
#import "GGPParkingSite.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"

@interface GGPCarLocationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *garageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@property (strong, nonatomic) GGPParkingCarLocation *carLocation;
@property (strong, nonatomic) GGPParkingSite *site;

- (void)configureLabels;
- (void)configureMapButton;

@end

@interface GGPCarLocationCellTests : XCTestCase

@property (strong, nonatomic) GGPCarLocationCell *cell;

@end

@implementation GGPCarLocationCellTests

- (void)setUp {
    [super setUp];
    self.cell = [GGPCarLocationCell new];
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testConfigureLabels {
    GGPParkingLevel *mockLevel = [GGPParkingLevel new];
    mockLevel.levelName = @"level 1";
    
    id mockSite = OCMClassMock([GGPParkingSite class]);
    [OCMStub([mockSite levelForZoneName:OCMOCK_ANY fromLevels:OCMOCK_ANY]) andReturn:mockLevel];
    
    id mockLabel = OCMPartialMock([UILabel new]);
    self.cell.locationLabel = mockLabel;
    
    GGPParkingCarLocation *mockLocation = [GGPParkingCarLocation new];
    self.cell.carLocation = mockLocation;
    
    [self.cell configureLabels];
    
    XCTAssertEqualObjects(self.cell.locationLabel.text, @"level 1");
}

- (void)testConfigureMap {
    id mockButton = OCMPartialMock([UIButton new]);
    self.cell.mapButton = mockButton;
    
    GGPParkingCarLocation *mockLocation = [GGPParkingCarLocation new];
    mockLocation.map = @"map";
    
    self.cell.carLocation = mockLocation;
    
    OCMExpect([mockButton ggp_expandVertically]);
    
    [self.cell configureMapButton];
    
    OCMVerifyAll(mockButton);
}

- (void)testConfigureMapNoMap {
    id mockButton = OCMPartialMock([UIButton new]);
    self.cell.mapButton = mockButton;
    
    GGPParkingCarLocation *mockLocation = [GGPParkingCarLocation new];
    mockLocation.map = @"";
    
    self.cell.carLocation = mockLocation;
    
    OCMExpect([mockButton ggp_collapseVertically]);
    
    [self.cell configureMapButton];
    
    OCMVerifyAll(mockButton);
}

@end
