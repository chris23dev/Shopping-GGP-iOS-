//
//  GGPParkingInfoViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPParkingInfoViewController.h"
#import "GGPParkingTenantPickerViewController.h"
#import "UIView+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPParkingInfoViewController (Testing)

@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (weak, nonatomic) IBOutlet UILabel *parkingDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *findNearestContainer;
@property (weak, nonatomic) IBOutlet UIView *pickerContainer;
@property (weak, nonatomic) IBOutlet UILabel *findNearestTitle;
@property (weak, nonatomic) IBOutlet UILabel *findNearestInstruction;

@property (strong, nonatomic) GGPMall *mall;

- (void)configurePickerContainer;
- (void)addMapViewToContainer;

@end

@interface GGPParkingInfoViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPParkingInfoViewController *parkingController;

@end

@implementation GGPParkingInfoViewControllerTests

- (void)setUp {
    [super setUp];
    self.parkingController = [GGPParkingInfoViewController new];
    [self.parkingController view];
}

- (void)tearDown {
    self.parkingController = nil;
    [super tearDown];
}

- (void)testConfigurePickerContainerMallHasParking {
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig parkingAvailable]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    id mockController = OCMPartialMock(self.parkingController);
    [OCMStub([mockController pickerContainer]) andReturn:[UIView new]];
    [OCMStub([mockController mall]) andReturn:mockMall];
    OCMExpect([mockController ggp_addChildViewController:[OCMArg isKindOfClass:[GGPParkingTenantPickerViewController class]] toPlaceholderView:self.parkingController.pickerContainer]);
    
    [self.parkingController configurePickerContainer];
    
    OCMVerifyAll(mockController);
    [mockMallManager stopMocking];
}

- (void)testConfigurePickerContainerMallDoesNotHaveParking {
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig parkingAvailable]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    id mockController = OCMPartialMock(self.parkingController);
    [[mockController reject] ggp_addChildViewController:[OCMArg isKindOfClass:[GGPParkingTenantPickerViewController class]] toPlaceholderView:self.parkingController.pickerContainer];
    
    [self.parkingController configurePickerContainer];
    
    OCMVerifyAll(mockController);
    [mockMallManager stopMocking];
}

- (void)testFindNearestParkingHidden {
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig parkingAvailable]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockConfig isParkingAvailabilityEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    id mockFindNearestContainer = OCMPartialMock(self.parkingController.findNearestContainer);
    OCMExpect([mockFindNearestContainer ggp_collapseVertically]);
    
    [self.parkingController configurePickerContainer];
    
    OCMVerifyAll(mockFindNearestContainer);
    [mockMallManager stopMocking];
}

- (void)testFindNearestParkingShown {
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig parkingAvailable]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockConfig isParkingAvailabilityEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockMallManager = OCMPartialMock([GGPMallManager shared]);
    [OCMStub([mockMallManager selectedMall]) andReturn:mockMall];
    
    id mockFindNearestContainer = OCMPartialMock(self.parkingController.findNearestContainer);
    [[mockFindNearestContainer reject] ggp_collapseVertically];
    
    [self.parkingController configurePickerContainer];
    
    OCMVerifyAll(mockFindNearestContainer);
    [mockMallManager stopMocking];
}

- (void)testAddMapToViewController {
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig isParkingAvailabilityEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockViewController = OCMPartialMock(self.parkingController);
    id mockMapContainer = OCMPartialMock(self.parkingController.mapContainer);
    
    [OCMStub([mockViewController mall]) andReturn:mockMall];
    
    OCMExpect([mockMapContainer ggp_collapseVertically]);
    
    [self.parkingController addMapViewToContainer];
    
    OCMVerifyAll(mockMapContainer);
}

@end
