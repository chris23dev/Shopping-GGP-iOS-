//
//  GGPNavigationTitleViewTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPNavigationTitleView.h"
#import "UIFont+GGPAdditions.h"

@interface GGPNavigationTitleView ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@interface GGPNavigationTitleViewTests : XCTestCase

@property (strong, nonatomic) GGPNavigationTitleView *titleView;
@property (strong, nonatomic) UIImage *titleImage;

@end

@implementation GGPNavigationTitleViewTests

- (void)setUp {
    [super setUp];
    self.titleImage = [UIImage new];
    self.titleView = [[GGPNavigationTitleView alloc] initWithImage:self.titleImage andText:@"mock title"];
}

- (void)tearDown {
    self.titleImage = nil;
    self.titleView = nil;
    [super tearDown];
}

- (void)testInitialization {
    XCTAssertEqual(self.titleView.titleImageView.image, self.titleImage);
    XCTAssertEqualObjects(self.titleView.titleLabel.text, @"mock title");
    XCTAssertEqualObjects(self.titleView.titleLabel.font, [UIFont ggp_boldWithSize:16]);
    XCTAssertEqualObjects(self.titleView.titleLabel.textColor, [UIColor whiteColor]);
}

@end
