//
//  GGPFadedImageViewTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 7/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFadedImageView.h"

@interface GGPFadedImageView ()

@property (strong, nonatomic) CAGradientLayer *imageGradientLayer;
@property (strong, nonatomic) UIImage *fullSizeImage;
@property (strong, nonatomic) UIImage *originalImage;

- (BOOL)shouldShowGradientForImage:(UIImage *)image;
- (void)adjustImageSize;

@end

@interface GGPFadedImageViewTests : XCTestCase

@property (strong, nonatomic) GGPFadedImageView *imageView;
@property (assign, nonatomic) CGRect imageViewRect;

@end

@implementation GGPFadedImageViewTests

- (void)setUp {
    [super setUp];
    self.imageViewRect = CGRectMake(0, 0, 300, 200);
    self.imageView = [[GGPFadedImageView alloc] initWithFrame:self.imageViewRect];
}

- (void)tearDown {
    self.imageView = nil;
    [super tearDown];
}

- (void)testShouldShowGradient {
    UIImage *mockTallImage = OCMPartialMock([UIImage new]);
    UIImage *mockShortImage = OCMPartialMock([UIImage new]);
    
    [OCMStub([mockTallImage size]) andReturnValue:OCMOCK_VALUE(CGSizeMake(100, 400))];
    [OCMStub([mockShortImage size]) andReturnValue:OCMOCK_VALUE(CGSizeMake(400, 100))];
    
    XCTAssertTrue([self.imageView shouldShowGradientForImage:mockTallImage]);
    XCTAssertFalse([self.imageView shouldShowGradientForImage:mockShortImage]);
}

- (void)testLayoutSubviewsImageNotSized {
    id mockImageView = OCMPartialMock(self.imageView);
    
    [OCMStub([mockImageView originalImage]) andReturn:[UIImage new]];
    [OCMStub([mockImageView fullSizeImage]) andReturn:nil];
    
    OCMExpect([mockImageView adjustImageSize]);
    
    [self.imageView layoutSubviews];
    
    OCMVerifyAll(mockImageView);
}

- (void)testLayoutSubviewsImageAlreadySized {
    id mockImageView = OCMPartialMock(self.imageView);
    
    [OCMStub([mockImageView originalImage]) andReturn:[UIImage new]];
    [OCMStub([mockImageView fullSizeImage]) andReturn:[UIImage new]];
    
    [[mockImageView reject] adjustImageSize];
    
    [self.imageView layoutSubviews];
    
    OCMVerifyAll(mockImageView);
}

- (void)testLayoutSubviewsImageNotLoaded {
    id mockImageView = OCMPartialMock(self.imageView);
    
    [OCMStub([mockImageView originalImage]) andReturn:nil];
    [OCMStub([mockImageView fullSizeImage]) andReturn:nil];
    
    [[mockImageView reject] adjustImageSize];
    
    [self.imageView layoutSubviews];
    
    OCMVerifyAll(mockImageView);
}

@end
