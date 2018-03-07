//
//  GGPLogoImageViewTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 2/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPLogoImageView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

@interface GGPLogoImageView ()

@property (strong, nonatomic) UILabel *nameLabel;
- (void)configureNameLabel;

@end

@interface GGPLogoImageViewTests : XCTestCase

@property (strong, nonatomic) GGPLogoImageView *imageView;

@end

@implementation GGPLogoImageViewTests

- (void)setUp {
    [super setUp];
    self.imageView = [GGPLogoImageView new];
}

- (void)tearDown {
    self.imageView = nil;
    [super tearDown];
}

- (void)testConfigureNameLabel {
    [self.imageView configureNameLabel];
    
    XCTAssertNotNil(self.imageView.nameLabel);
    XCTAssertEqual(self.imageView.nameLabel.numberOfLines, 0);
    XCTAssertEqual(self.imageView.nameLabel.superview, self.imageView);
}

- (void)testSetImageHasUrl {
    id mockUrl = OCMClassMock([NSURL class]);
    id mockImageView = OCMPartialMock(self.imageView);
    OCMExpect([mockImageView setImageWithURLRequest:OCMOCK_ANY placeholderImage:nil success:OCMOCK_ANY failure:OCMOCK_ANY]);
    
    [self.imageView configureNameLabel];
    [self.imageView setImageWithURL:mockUrl defaultName:nil andFont:[UIFont ggp_mediumWithSize:10]];
    
    XCTAssertNil(self.imageView.nameLabel.text);
    OCMVerifyAll(mockImageView);
}

- (void)testSetImageWithoutUrlAndIsListView {
    id mockName = @"event name";
    
    [self.imageView configureNameLabel];
    [self.imageView setImageWithURL:nil defaultName:mockName andFont:[UIFont ggp_mediumWithSize:10]];
    
    XCTAssertNil(self.imageView.image);
    
    XCTAssertEqual(self.imageView.nameLabel.font, [UIFont ggp_mediumWithSize:10]);
    XCTAssertEqualObjects(self.imageView.nameLabel.text, [mockName uppercaseString]);
}

- (void)testSetImageWithoutUrlAndIsNotListView {
    id mockName = @"event name";
    
    [self.imageView configureNameLabel];
    [self.imageView setImageWithURL:nil defaultName:mockName];
    
    XCTAssertNil(self.imageView.image);
    XCTAssertEqual(self.imageView.nameLabel.font, [UIFont ggp_regularWithSize:22]);
    XCTAssertEqualObjects(self.imageView.nameLabel.text, [mockName uppercaseString]);
}

@end
