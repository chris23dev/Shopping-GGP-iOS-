//
//  GGPWayfindingDetailCardViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapManager.h"
#import "GGPJMapViewController+Wayfinding.h"
#import "GGPTenant.h"
#import "GGPWayfindingDetailCardViewController.h"
#import "GGPWayfindingFloor.h"
#import "UIView+GGPAdditions.h"
#import <JMap/JMap.h>

@interface GGPWayfindingDetailCardViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPWayfindingDetailCardViewController *detailCardViewController;
@property GGPTenant *fromTenant;
@property GGPTenant *toTenant;

@end

@interface GGPWayfindingDetailCardViewController (Testing)

@property (weak, nonatomic) IBOutlet UIView *backgroundContainer;
@property (weak, nonatomic) IBOutlet UIView *iconContainer;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *actionIconLabel;
@property (weak, nonatomic) IBOutlet UIImageView *instructionImageView;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIView *separator;

@property (assign, nonatomic) NSInteger currentFloorOrder;

- (void)configureWithInstruction:(JMapTextDirectionInstruction *)instruction;
- (void)configurePreviousButtonForWayfindingFloor:(GGPWayfindingFloor *)wayfindingFloor;
- (void)configureNextButtonAsVisible:(BOOL)shouldShowNextButton;
- (IBAction)previousButtonTapped:(id)sender;
- (void)nextButtonTapped;
- (BOOL)isStartingFloor:(GGPWayfindingFloor *)wayfindingFloor;
- (BOOL)isMoverInstruction:(JMapTextDirectionInstruction *)instruction;

@end

@implementation GGPWayfindingDetailCardViewControllerTests

- (void)setUp {
    [super setUp];
    self.detailCardViewController = [GGPWayfindingDetailCardViewController new];
    [self.detailCardViewController view];
}

- (void)tearDown {
    self.detailCardViewController = nil;
    [super tearDown];
}

- (void)testOutlets {
    XCTAssertNotNil(self.detailCardViewController.backgroundContainer);
    XCTAssertNotNil(self.detailCardViewController.iconContainer);
    XCTAssertNotNil(self.detailCardViewController.iconImageView);
    XCTAssertNotNil(self.detailCardViewController.actionIconLabel);
    XCTAssertNotNil(self.detailCardViewController.instructionImageView);
    XCTAssertNotNil(self.detailCardViewController.instructionLabel);
    XCTAssertNotNil(self.detailCardViewController.previousButton);
    XCTAssertNotNil(self.detailCardViewController.separator);
}

- (void)testConfigureWithInstructionMoverType {
    id mockController = OCMPartialMock(self.detailCardViewController);
    JMapTextDirectionInstruction *mockInstruction = OCMPartialMock([JMapTextDirectionInstruction new]);
    
    [OCMStub([mockInstruction output]) andReturn:@"mock output"];
    [OCMStub([mockController isMoverInstruction:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(YES)];
    
    OCMExpect([mockController configureNextButtonAsVisible:YES]);
    
    [self.detailCardViewController configureWithInstruction:mockInstruction];
    
    XCTAssertEqualObjects(self.detailCardViewController.instructionLabel.text, @"mock output");
    
    OCMVerifyAll(mockController);
}

- (void)testConfigureNextButtonAsVisible {
    [self.detailCardViewController configureNextButtonAsVisible:YES];
    
    XCTAssertFalse(self.detailCardViewController.iconContainer.hidden);
    XCTAssertFalse(self.detailCardViewController.actionIconLabel.hidden);
    
    [self.detailCardViewController configureNextButtonAsVisible:NO];
    
    XCTAssertTrue(self.detailCardViewController.iconContainer.hidden);
    XCTAssertTrue(self.detailCardViewController.actionIconLabel.hidden);
}

- (void)testConfigurePreviousButtonForWayfindingFloorIsStartingFloor {
    id mockFloor = OCMPartialMock([GGPWayfindingFloor new]);
    id mockController = OCMPartialMock(self.detailCardViewController);
    id mockButton = OCMPartialMock(self.detailCardViewController.previousButton);
    
    [OCMStub([mockController isStartingFloor:mockFloor]) andReturnValue:OCMOCK_VALUE(YES)];
    
    OCMExpect([mockButton ggp_collapseHorizontally]);
    
    [self.detailCardViewController configurePreviousButtonForWayfindingFloor:mockFloor];
    
    XCTAssertTrue(self.detailCardViewController.separator.hidden);
    OCMVerifyAll(mockButton);
}

- (void)testConfigurePreviousButtonForWayfindingFloorIsNotStartingFloor {
    id mockFloor = OCMPartialMock([GGPWayfindingFloor new]);
    id mockController = OCMPartialMock(self.detailCardViewController);
    id mockButton = OCMPartialMock(self.detailCardViewController.previousButton);
    
    [OCMStub([mockController isStartingFloor:mockFloor]) andReturnValue:OCMOCK_VALUE(NO)];
    
    OCMExpect([mockButton ggp_expandHorizontally]);
    
    [self.detailCardViewController configurePreviousButtonForWayfindingFloor:mockFloor];
    
    XCTAssertFalse(self.detailCardViewController.separator.hidden);
    OCMVerifyAll(mockButton);
}

- (void)testIsStartingFloor {
    id mockFloor1 = OCMPartialMock([GGPWayfindingFloor new]);
    id mockFloor2 = OCMPartialMock([GGPWayfindingFloor new]);
    
    [OCMStub([mockFloor1 order]) andReturnValue:OCMOCK_VALUE(0)];
    [OCMStub([mockFloor2 order]) andReturnValue:OCMOCK_VALUE(1)];
    
    XCTAssertTrue([self.detailCardViewController isStartingFloor:mockFloor1]);
    XCTAssertFalse([self.detailCardViewController isStartingFloor:mockFloor2]);
}

- (void)testIsMoverInstruction {
    JMapTextDirectionInstruction *mockInstruction1 = OCMPartialMock([JMapTextDirectionInstruction new]);
    JMapTextDirectionInstruction *mockInstruction2 = OCMPartialMock([JMapTextDirectionInstruction new]);
    
    [OCMStub([mockInstruction1 type]) andReturn:@"mover"];
    [OCMStub([mockInstruction2 type]) andReturn:@"not a mover"];
    
    XCTAssertTrue([self.detailCardViewController isMoverInstruction:mockInstruction1]);
    XCTAssertFalse([self.detailCardViewController isMoverInstruction:mockInstruction2]);
}

@end
