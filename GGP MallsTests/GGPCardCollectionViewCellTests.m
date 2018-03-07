//
//  GGPCardCollectionViewCellTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCardCollectionViewCell.h"
#import "GGPJMapManager.h"
#import "GGPMall.h"
#import "GGPMallConfig.h"
#import "GGPMallManager.h"
#import "GGPTenant.h"


@interface GGPCardCollectionViewCellTests : XCTestCase

@property GGPCardCollectionViewCell *cell;

@end

@interface GGPCardCollectionViewCell (Testing)

@property IBOutlet UIView *guideMeContainer;

- (void)configureGuideMe;

@end

@implementation GGPCardCollectionViewCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[NSBundle mainBundle] loadNibNamed:@"GGPCardCollectionViewCell" owner:self options:nil].firstObject;
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testConfigureGuideMeWayfindingDisabled {
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    id mockJMapManager = OCMPartialMock([GGPJMapManager shared]);
    [OCMStub([mockJMapManager wayfindingAvailableForTenant:OCMOCK_ANY]) andReturnValue:@NO];
    
    id mockTenant = OCMPartialMock([GGPTenant new]);
    
    [self.cell configureWithTenant:mockTenant];
    
    XCTAssertTrue(self.cell.guideMeContainer.hidden);
    
    [mockMallManager stopMocking];
    [mockJMapManager stopMocking];
}

- (void)testConfigureGuideMeWayfindingEnabled {
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    id mockJMapManager = OCMPartialMock([GGPJMapManager shared]);
    [OCMStub([mockJMapManager wayfindingAvailableForTenant:OCMOCK_ANY]) andReturnValue:@YES];
    
    id mockTenant = OCMPartialMock([GGPTenant new]);
    
    [self.cell configureWithTenant:mockTenant];
    
    XCTAssertFalse(self.cell.guideMeContainer.hidden);
    
    [mockMallManager stopMocking];
    [mockJMapManager stopMocking];
}

@end
