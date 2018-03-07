//
//  GGPOverlayImageControllerTests.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 5/17/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPOverlayImageController.h"

@interface GGPOverlayImageControllerTests : XCTestCase
@property (strong, nonatomic) GGPOverlayImageController *overlayController;
@end

@implementation GGPOverlayImageControllerTests

- (void)setUp {
    [super setUp];
    self.overlayController = [[GGPOverlayImageController alloc] initWithOverlayImageView:[UIImageView new]];
}

- (void)tearDown {
    self.overlayController = nil;
    [super tearDown];
}

@end
