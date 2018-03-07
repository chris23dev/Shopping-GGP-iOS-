//
//  GGPBenefitsViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPBenefitsItemViewController.h"
#import "GGPBenefitsViewController.h"
#import "GGPMall.h"
#import "GGPMallConfig.h"
#import "GGPMallManager.h"
#import "GGPSweepstakes.h"

@interface GGPBenefitsViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSArray *benefitItemControllers;

@property (strong, nonatomic) GGPSweepstakes *sweepstakes;
- (NSArray *)createBenefitItemControllers;

@end

@interface GGPBenefitsViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPBenefitsViewController *benefitsController;

@end

@implementation GGPBenefitsViewControllerTests

- (void)setUp {
    [super setUp];
    self.benefitsController = [GGPBenefitsViewController new];
}

- (void)tearDown {
    self.benefitsController = nil;
    [super tearDown];
}

- (void)testCreateBenefitItemControllersWayfindingEnabledHasSweepstakes {
    id mockMall = OCMPartialMock([GGPMall new]);
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    id mockMallManager = OCMClassMock([GGPMallManager class]);
    id mockController = OCMPartialMock(self.benefitsController);
    
    [OCMStub([mockController sweepstakes]) andReturn:[GGPSweepstakes new]];
    [OCMStub([mockMallManager shared]) andReturn:mockMallManager];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockMall config]) andReturn:mockConfig];
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    NSArray *result = [self.benefitsController createBenefitItemControllers];
    
    XCTAssertEqual(result.count, 5);
    
    [mockMallManager stopMocking];
}

- (void)testCreateBenefitItemControllersWayfindingEnabledNoSweepstakes {
    id mockMall = OCMPartialMock([GGPMall new]);
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    id mockMallManager = OCMClassMock([GGPMallManager class]);
    
    [OCMStub([mockMallManager shared]) andReturn:mockMallManager];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockMall config]) andReturn:mockConfig];
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    NSArray *result = [self.benefitsController createBenefitItemControllers];
    
    XCTAssertEqual(result.count, 4);
    
    [mockMallManager stopMocking];
}

- (void)testCreateBenefitItemControllersWayfindingDisabledHasSweepstakes {
    id mockMall = OCMPartialMock([GGPMall new]);
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    id mockMallManager = OCMClassMock([GGPMallManager class]);
    id mockController = OCMPartialMock(self.benefitsController);
    
    [OCMStub([mockController sweepstakes]) andReturn:[GGPSweepstakes new]];
    [OCMStub([mockMallManager shared]) andReturn:mockMallManager];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockMall config]) andReturn:mockConfig];
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    
    NSArray *result = [self.benefitsController createBenefitItemControllers];
    
    XCTAssertEqual(result.count, 4);
    
    [mockMallManager stopMocking];
}

- (void)testCreateBenefitItemControllersWayfindingDisabledNoSweepstakes {
    id mockMall = OCMPartialMock([GGPMall new]);
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    id mockMallManager = OCMClassMock([GGPMallManager class]);
    
    [OCMStub([mockMallManager shared]) andReturn:mockMallManager];
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockMall config]) andReturn:mockConfig];
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    
    NSArray *result = [self.benefitsController createBenefitItemControllers];
    
    XCTAssertEqual(result.count, 3);
    
    [mockMallManager stopMocking];
}

@end
