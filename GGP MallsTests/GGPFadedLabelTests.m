//
//  GGPFadedLabelTests.m
//  GGP Malls
//
//  Created by Janet Lin on 2/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFadedLabel.h"

@interface GGPFadedLabelTests : XCTestCase
@property (strong, nonatomic) GGPFadedLabel *label;
@end

@interface GGPFadedLabel (Testing)
@property (strong, nonatomic) CAGradientLayer* descriptionGradientLayer;
- (void)labelTapped:(UITapGestureRecognizer *)recognizer;
@end

@implementation GGPFadedLabelTests

- (void)setUp {
    [super setUp];
    self.label = [[GGPFadedLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
}

- (void)tearDown {
    self.label = nil;
    [super tearDown];
}

- (void)testDrawRectAddsGestureRecognizer {
    [self.label drawRect:CGRectMake(0, 0, 12, 12)];
    XCTAssertTrue([(UIGestureRecognizer *)self.label.gestureRecognizers[0] isKindOfClass:UITapGestureRecognizer.class]);
}

- (void)testAddWhiteFadeAtBottomYOffset {
    CGFloat fadeHeight = self.label.frame.size.height/2;
    [self.label addWhiteFadeAtBottomYOffset:self.label.frame.size.height];
    XCTAssertNotNil(self.label.descriptionGradientLayer);
    XCTAssertNotNil(self.label.descriptionGradientLayer.superlayer);
    XCTAssertEqual(self.label.descriptionGradientLayer.frame.origin.x, self.label.frame.origin.x);
    XCTAssertEqual(self.label.descriptionGradientLayer.frame.origin.y, self.label.frame.origin.y + self.label.frame.size.height - fadeHeight);
    XCTAssertEqual(self.label.descriptionGradientLayer.frame.size.width, self.label.frame.size.width);
    XCTAssertEqual(self.label.descriptionGradientLayer.frame.size.height, fadeHeight);
}

- (void)testLabelTapped {
    id mockProtocol = OCMProtocolMock(@protocol(GGPFadedLabelDelegate));
    OCMExpect([mockProtocol fadedLabelTapped:self.label]);
    self.label.labelDelegate = mockProtocol;
    
    [self.label labelTapped:nil];
    XCTAssertNil(self.label.descriptionGradientLayer.superlayer);
    OCMVerify(mockProtocol);
}

@end
