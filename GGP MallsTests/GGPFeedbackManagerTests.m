//
//  GGPFeedbackManagerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/23/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFeedbackManager.h"

@interface GGPFeedbackManager (Testing)

@property (strong, nonatomic) UIViewController *presenter;
@property (assign, nonatomic) NSInteger actionsRequiredForFeedbackAlert;

+ (instancetype)shared;
+ (BOOL)isEligibleForFeedbackAlert;
+ (NSInteger)feedbackActionCount;
+ (void)updateFeedbackActionCount:(NSInteger)count;
- (void)displayInitialFeedbackAlert;

@end

@interface GGPFeedbackManagerTests : XCTestCase

@end

@implementation GGPFeedbackManagerTests

- (void)testConfigureWithPresenter {
    UIViewController *mockPresenter = [UIViewController new];
    [GGPFeedbackManager configureWithPresenter:mockPresenter];
    
    XCTAssertEqual([GGPFeedbackManager shared].presenter, mockPresenter);
}

- (void)testTrackActionNotEligible {
    id mockManager = OCMClassMock([GGPFeedbackManager class]);
    [OCMStub([mockManager isEligibleForFeedbackAlert]) andReturnValue:OCMOCK_VALUE(NO)];
    
    [[mockManager reject] feedbackActionCount];
    
    [GGPFeedbackManager trackAction];
    
    OCMVerifyAll(mockManager);
    
    [mockManager stopMocking];
}

- (void)testTrackActionIsEligibleRequiredActionsNotMet {
    id mockManager = OCMClassMock([GGPFeedbackManager class]);
    [OCMStub([mockManager isEligibleForFeedbackAlert]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockManager feedbackActionCount]) andReturnValue:OCMOCK_VALUE(2)];
    
    OCMExpect([mockManager updateFeedbackActionCount:3]);
    [[mockManager reject] displayInitialFeedbackAlert];
    
    [GGPFeedbackManager trackAction];
    
    OCMVerifyAll(mockManager);
    
    [mockManager stopMocking];
}

- (void)testTrackActionIsEligibleRequiredActionsMet {
    id mockManager = OCMClassMock([GGPFeedbackManager class]);
   
    [OCMStub([mockManager shared]) andReturn:mockManager];
    [OCMStub([mockManager actionsRequiredForFeedbackAlert]) andReturnValue:OCMOCK_VALUE(7)];
    [OCMStub([mockManager isEligibleForFeedbackAlert]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockManager feedbackActionCount]) andReturnValue:OCMOCK_VALUE(6)];
    
    OCMExpect([mockManager updateFeedbackActionCount:7]);
    OCMExpect([mockManager displayInitialFeedbackAlert]);
    
    [GGPFeedbackManager trackAction];
    
    OCMVerifyAll(mockManager);
    
    [mockManager stopMocking];
}

@end
