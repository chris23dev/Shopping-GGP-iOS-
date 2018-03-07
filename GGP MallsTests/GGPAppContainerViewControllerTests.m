//
//  GGPAppContainerViewControllerTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 5/16/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAppContainerViewController.h"
#import "GGPBannerViewController.h"
#import "GGPClient.h"
#import "GGPNotificationConstants.h"
#import "GGPOverlayImageController.h"
#import "UIViewController+GGPAdditions.h"

@interface GGPAppContainerViewControllerTests : XCTestCase

@property (strong, nonatomic) GGPAppContainerViewController *appContainerViewController;

@end

@interface GGPAppContainerViewController (Testing)

@property IBOutlet UIView *bannerContainer;

@property GGPBannerViewController *networkBanner;
@property GGPOverlayImageController *overlayImageController;

- (void)appDidBecomeActive;
- (void)handleMallChanged:(NSNotification *)notification;

@end

@implementation GGPAppContainerViewControllerTests

- (void)setUp {
    [super setUp];
    self.appContainerViewController = [GGPAppContainerViewController new];
    self.appContainerViewController.overlayImageController = [[GGPOverlayImageController alloc] initWithOverlayImageView:[UIImageView new]];
}

- (void)tearDown {
    self.appContainerViewController = nil;
    [super tearDown];
}

- (void)testLaunchImageDisplaysOnAppStart {
    id mockViewController = OCMPartialMock(self.appContainerViewController);
    id mockOverlayController = OCMPartialMock(self.appContainerViewController.overlayImageController);
    
    OCMExpect([mockOverlayController displayLaunchOverlayImage]);
    
    [mockViewController appDidBecomeActive];
    
    OCMVerify(mockOverlayController);
}

- (void)testLaunchImageDoesNotDisplayOnAppResume {
    id mockViewController = OCMPartialMock(self.appContainerViewController);
    id mockOverlayController = OCMPartialMock(self.appContainerViewController.overlayImageController);
    
    OCMReject([mockOverlayController displayLaunchOverlayImage]);
    
    [mockViewController appDidBecomeActive];
    
    OCMVerify(mockOverlayController);
}

- (void)testLoadingScreenDisplaysOnMallSelectionNotInitialMallSelection {
    id mockOverlayController = OCMPartialMock(self.appContainerViewController.overlayImageController);
    id mockNotification = OCMPartialMock([[NSNotification alloc] initWithName:GGPMallManagerMallChangedNotification object:nil userInfo:@{ GGPIsInitialMallSelectionUserInfoKey: @(NO) }]);
    
    OCMExpect([mockOverlayController displayLoadingOverlayImage]);
    
    [self.appContainerViewController handleMallChanged:mockNotification];
    
    OCMVerifyAll(mockOverlayController);
}

- (void)testLoadingScreenDisplaysOnMallSelectionIsInitialMallSelection {
    id mockOverlayController = OCMPartialMock(self.appContainerViewController.overlayImageController);
    id mockNotification = OCMPartialMock([[NSNotification alloc] initWithName:GGPMallManagerMallChangedNotification object:nil userInfo:@{ GGPIsInitialMallSelectionUserInfoKey: @(YES) }]);
    
    [[mockOverlayController reject] displayLoadingOverlayImage];
    
    [self.appContainerViewController handleMallChanged:mockNotification];
    
    OCMVerifyAll(mockOverlayController);
}

@end
