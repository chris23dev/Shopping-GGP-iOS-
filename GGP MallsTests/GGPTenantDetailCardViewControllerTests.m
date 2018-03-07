//
//  GGPMapTenantDetailCardViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/3/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPJMapManager.h"
#import "GGPJMapViewController.h"
#import "GGPLogoImageView.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPTenant.h"
#import "GGPTenant.h"
#import "GGPTenantDetailCardViewController.h"
#import "GGPTenantDetailViewController.h"
#import "GGPWayfindingViewController.h"

@interface GGPTenantDetailCardViewController ()

@property (strong, nonatomic) GGPTenantDetailCardViewController *tenantDetailCardViewController;

@end

@interface GGPTenantDetailCardViewController (Testing)

@property (weak, nonatomic) IBOutlet UIView *backgroundContainer;
@property (weak, nonatomic) IBOutlet UILabel *tenantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenantDescriptionLabel;
@property (weak, nonatomic) IBOutlet GGPLogoImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *guideMeContainer;
@property (weak, nonatomic) IBOutlet UIImageView *guideMeImageView;

@property (strong, nonatomic) GGPTenant *tenant;

- (void)configureShadow;
- (void)configureGuideMe;
- (void)configureImage;
- (void)configureTextStyling;
- (void)configureLabels;
- (void)configureGestures;
- (void)configureSlideUpAnimation;
- (void)displayTenantDetail;
- (void)displayWayfinding;
- (void)resetMapView;

@end

@interface GGPTenantDetailCardViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPTenantDetailCardViewController *tenantDetailCardViewController;

@end

static NSString *const kMockTenantName = @"Test Name";
static NSString *const kMockTenantCategory = @"Mock Category";


@implementation GGPTenantDetailCardViewControllerTests

- (void)setUp {
    [super setUp];
    self.tenantDetailCardViewController = [[GGPTenantDetailCardViewController alloc] initWithTenant:[self mockTenant]];
}

- (void)tearDown {
    self.tenantDetailCardViewController = nil;
    [super tearDown];
}

- (void)testViewDidLoad {
    id mockTenantDetailCardViewController = OCMPartialMock(self.tenantDetailCardViewController);
    
    OCMExpect([mockTenantDetailCardViewController configureShadow]);
    OCMExpect([mockTenantDetailCardViewController configureGuideMe]);
    OCMExpect([mockTenantDetailCardViewController configureImage]);
    OCMExpect([mockTenantDetailCardViewController configureTextStyling]);
    OCMExpect([mockTenantDetailCardViewController configureLabels]);
    OCMExpect([mockTenantDetailCardViewController configureGestures]);
    
    [self.tenantDetailCardViewController viewDidLoad];
    
    OCMVerifyAll(mockTenantDetailCardViewController);
}

- (void)testConfigureGestures {
    id mockView = OCMPartialMock([UIView new]);
    
    OCMExpect([mockView addGestureRecognizer:[OCMArg isKindOfClass:UITapGestureRecognizer.class]]);
    OCMExpect([mockView addGestureRecognizer:[OCMArg isKindOfClass:UISwipeGestureRecognizer.class]]);
    
    [self.tenantDetailCardViewController configureGestures];
    
    OCMVerify(mockView);
}

- (void)testConfigureGuideMeWayfindingEnabledNotClosed {
    [self.tenantDetailCardViewController view];
    
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockTenantDetailCardViewController = OCMPartialMock(self.tenantDetailCardViewController);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    id mockManager = OCMPartialMock([GGPMallManager shared]);
    id mockContainer = OCMPartialMock(self.tenantDetailCardViewController.guideMeContainer);
    
    [OCMStub([mockTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockTenantDetailCardViewController tenant]) andReturn:mockTenant];
    
    [[mockContainer reject] setHidden:YES];
    
    [self.tenantDetailCardViewController configureGuideMe];
    
    OCMVerifyAll(mockContainer);
    
    [mockManager stopMocking];
}

- (void)testConfigureGuideMeWayfindingDisabledNotClosed {
    [self.tenantDetailCardViewController view];
    
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockTenantDetailCardViewController = OCMPartialMock(self.tenantDetailCardViewController);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    id mockManager = OCMPartialMock([GGPMallManager shared]);
    id mockContainer = OCMPartialMock(self.tenantDetailCardViewController.guideMeContainer);
    
    [OCMStub([mockTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockTenantDetailCardViewController tenant]) andReturn:mockTenant];
    
    OCMExpect([mockContainer setHidden:YES]);
    
    [self.tenantDetailCardViewController configureGuideMe];
    
    OCMVerifyAll(mockContainer);
    
    [mockManager stopMocking];
}

- (void)testConfigureGuideMeWayfindingEnabledClosed {
    [self.tenantDetailCardViewController view];
    
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockTenantDetailCardViewController = OCMPartialMock(self.tenantDetailCardViewController);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    id mockManager = OCMPartialMock([GGPMallManager shared]);
    id mockContainer = OCMPartialMock(self.tenantDetailCardViewController.guideMeContainer);
    
    [OCMStub([mockTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockTenantDetailCardViewController tenant]) andReturn:mockTenant];
    
    OCMExpect([mockContainer setHidden:YES]);
    
    [self.tenantDetailCardViewController configureGuideMe];
    
    OCMVerifyAll(mockContainer);
    
    [mockManager stopMocking];
}

- (void)testConfigureGuideMeWayfindingDisabledClosed {
    [self.tenantDetailCardViewController view];
    
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(NO)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    id mockTenantDetailCardViewController = OCMPartialMock(self.tenantDetailCardViewController);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    id mockManager = OCMPartialMock([GGPMallManager shared]);
    id mockContainer = OCMPartialMock(self.tenantDetailCardViewController.guideMeContainer);
    
    [OCMStub([mockTenant temporarilyClosed]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockManager selectedMall]) andReturn:mockMall];
    [OCMStub([mockTenantDetailCardViewController tenant]) andReturn:mockTenant];
    
    OCMExpect([mockContainer setHidden:YES]);
    
    [self.tenantDetailCardViewController configureGuideMe];
    
    OCMVerifyAll(mockContainer);
    
    [mockManager stopMocking];
}

- (void)testDisplayTenantDetail {
    id mockTenantDetailCardViewController = OCMPartialMock(self.tenantDetailCardViewController);
    id mockTenantDetailViewController = OCMPartialMock([GGPTenantDetailViewController new]);
    id mockTenant = OCMClassMock(GGPTenant.class);
    
    OCMExpect([mockTenantDetailViewController initWithTenantDetails:mockTenant]);
    OCMExpect([mockTenantDetailCardViewController configureSlideUpAnimation]);
    OCMExpect([mockTenantDetailCardViewController resetMapView]);
    
    [self.tenantDetailCardViewController displayTenantDetail];
    
    OCMVerify(mockTenantDetailViewController);
    OCMVerifyAll(mockTenantDetailCardViewController);
}

- (void)testDisplayWayfinding {
    id mockTenantDetailCardViewController = OCMPartialMock(self.tenantDetailCardViewController);
    id mockNavController = OCMPartialMock([UINavigationController new]);
    [OCMStub([mockTenantDetailCardViewController navigationController]) andReturn:mockNavController];
    
    OCMExpect([mockTenantDetailCardViewController configureSlideUpAnimation]);
    OCMExpect([mockTenantDetailCardViewController resetMapView]);
    OCMExpect([mockNavController pushViewController:[OCMArg isKindOfClass:[GGPWayfindingViewController class]] animated:NO]);
    
    [self.tenantDetailCardViewController displayWayfinding];
    
    OCMVerifyAll(mockTenantDetailCardViewController);
    OCMVerify(mockNavController);
}

- (void)testConfigureImage {
    id mockGGPImageView = OCMClassMock(GGPLogoImageView.class);
    
    OCMExpect([mockGGPImageView setImageWithURL:OCMOCK_ANY defaultName:OCMOCK_ANY]);

    [self.tenantDetailCardViewController view];
    [self.tenantDetailCardViewController configureImage];
    
    XCTAssertNotNil(self.tenantDetailCardViewController.logoImageView);
    OCMVerify(mockGGPImageView);
}

- (void)testConfigureLabels {
    [self.tenantDetailCardViewController view];
    [self.tenantDetailCardViewController configureLabels];
    
    XCTAssertEqualObjects(self.tenantDetailCardViewController.tenantDescriptionLabel.text, kMockTenantCategory);
    XCTAssertEqualObjects(self.tenantDetailCardViewController.tenantNameLabel.text, kMockTenantName);
}

- (void)testHandleResetMapView {
    id mockJMapViewController = OCMPartialMock([GGPJMapManager shared].mapViewController);
    self.tenantDetailCardViewController.tenantDetailCardDelegate = mockJMapViewController;
    
    OCMExpect([mockJMapViewController resetMapView]);
    
    [self.tenantDetailCardViewController resetMapView];
    
    OCMVerifyAll(mockJMapViewController);
}

- (id)mockTenant {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant name]) andReturn:kMockTenantName];
    [OCMStub([mockTenant prettyPrintCategories]) andReturn:kMockTenantCategory];
    return mockTenant;
}

@end
