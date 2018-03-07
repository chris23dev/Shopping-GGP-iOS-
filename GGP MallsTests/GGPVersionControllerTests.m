//
//  GGPLaunchViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "NSString+GGPAdditions.h"
#import "GGPAppConfig.h"
#import "UIViewController+GGPAdditions.h"
#import "GGPVersionController.h"

@interface GGPVersionController ()

@property (assign, nonatomic) BOOL isAlertVisible;

+ (BOOL)isAppUpdateRequiredForMinVersion:(NSString *)minVersion;

@end

@interface GGPVersionControllerTests : XCTestCase

@property (strong, nonatomic) GGPVersionController *versionController;

@end

@implementation GGPVersionControllerTests

- (void)testAppUpdateRequiredForMinVersion {
    id mockBundle = OCMPartialMock([NSBundle mainBundle]);
    [OCMStub([mockBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]) andReturn:@"1.5.0"];
    
    XCTAssertFalse([GGPVersionController isAppUpdateRequiredForMinVersion:@"1.3"]);
    XCTAssertFalse([GGPVersionController isAppUpdateRequiredForMinVersion:@"0.5"]);
    XCTAssertFalse([GGPVersionController isAppUpdateRequiredForMinVersion:@"1.5.0"]);
    XCTAssertTrue([GGPVersionController isAppUpdateRequiredForMinVersion:@"1.5.01"]);
    XCTAssertTrue([GGPVersionController isAppUpdateRequiredForMinVersion:@"2.3"]);
    XCTAssertTrue([GGPVersionController isAppUpdateRequiredForMinVersion:@"1.5.4"]);
    
    [mockBundle stopMocking];
}

- (void)testHasUpdatedSincePreviousLaunchNoPrevious {
    id mockBundle = OCMPartialMock([NSBundle mainBundle]);
    [OCMStub([mockBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]) andReturn:@"1.5.0"];
    
    id mockDefaults = OCMPartialMock([NSUserDefaults standardUserDefaults]);
    [OCMStub([mockDefaults objectForKey:@"GGPPreviousAppLaunchVersionKey"]) andReturn:nil];
    OCMStub([mockDefaults setObject:OCMOCK_ANY forKey:OCMOCK_ANY]);
    
    XCTAssertTrue([GGPVersionController hasUpdatedSincePreviousLaunch]);
  
    [mockBundle stopMocking];
    [mockDefaults stopMocking];
}

- (void)testHasUpdatedSincePreviousLaunchSameVersion {
    id mockBundle = OCMPartialMock([NSBundle mainBundle]);
    [OCMStub([mockBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]) andReturn:@"1.5.0"];
    
    id mockDefaults = OCMPartialMock([NSUserDefaults standardUserDefaults]);
    [OCMStub([mockDefaults objectForKey:@"GGPPreviousAppLaunchVersionKey"]) andReturn:@"1.5.0"];
    OCMStub([mockDefaults setObject:OCMOCK_ANY forKey:OCMOCK_ANY]);
    
    XCTAssertFalse([GGPVersionController hasUpdatedSincePreviousLaunch]);
    
    [mockBundle stopMocking];
    [mockDefaults stopMocking];
}

- (void)testHasUpdatedSincePreviousLaunchDifferentVersion {
    id mockBundle = OCMPartialMock([NSBundle mainBundle]);
    [OCMStub([mockBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]) andReturn:@"1.5.0"];
    
    id mockDefaults = OCMPartialMock([NSUserDefaults standardUserDefaults]);
    [OCMStub([mockDefaults objectForKey:@"GGPPreviousAppLaunchVersionKey"]) andReturn:@"1.6.0"];
    OCMStub([mockDefaults setObject:OCMOCK_ANY forKey:OCMOCK_ANY]);
    
    XCTAssertTrue([GGPVersionController hasUpdatedSincePreviousLaunch]);
    
    [mockBundle stopMocking];
    [mockDefaults stopMocking];
}

@end
