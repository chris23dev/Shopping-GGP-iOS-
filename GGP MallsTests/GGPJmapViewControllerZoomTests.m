//
//  GGPJmapViewControllerZoomTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPJMapViewController+Zoom.h"
#import "GGPLevelSelectorCollectionViewController.h"
#import <JMap/JMap.h>

@interface GGPJmapViewControllerZoomTests : XCTestCase

@property (strong, nonatomic) GGPJMapViewController *mapController;

@end

@interface GGPJMapViewController (Testing)

@property (strong, nonatomic) JMapContainerView *mapView;

- (void)increaseZoomLevel;

@end

@implementation GGPJmapViewControllerZoomTests

- (void)setUp {
    [super setUp];
    self.mapController = [GGPJMapViewController new];
}

- (void)tearDown {
    self.mapController = nil;
    [super tearDown];
}

- (void)testIncreaseZoomLevel {
    id mockMapView = OCMPartialMock(self.mapController.mapView);
    OCMExpect([mockMapView setZoomScale:1.75 animated:YES]);
    [self.mapController increaseZoomLevel];
    OCMVerifyAll(mockMapView);
}

@end
