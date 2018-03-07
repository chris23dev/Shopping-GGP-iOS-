//
//  GGPAccountViewControllerTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/21/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccountViewController.h"
#import "GGPLogoImageView.h"
#import "GGPUser.h"
#import "UIFont+GGPAdditions.h"
#import "UIView+GGPAdditions.h"
#import <XCTest/XCTest.h>

@interface GGPAccountViewControllerTests : XCTestCase

@property GGPAccountViewController *accountViewController;

@end

@interface GGPAccountViewController (Testing)

@property IBOutlet GGPLogoImageView *avatarImageView;
@property IBOutlet UILabel *greetingLabel;

- (void)configureStateForUser:(GGPUser *)user;
- (NSString *)firstCharacterOfName:(NSString *)firstName;

@end

@implementation GGPAccountViewControllerTests

- (void)setUp {
    [super setUp];
    self.accountViewController = [GGPAccountViewController new];
    [self.accountViewController view];
}

- (void)tearDown {
    self.accountViewController = nil;
    [super tearDown];
}

- (void)testTabBarHidden {
    id mockTabController = OCMPartialMock([UITabBarController new]);
    id mockController = OCMPartialMock(self.accountViewController);
    
    [OCMStub([mockController tabBarController]) andReturn:mockTabController];
    
    [self.accountViewController viewWillAppear:NO];
    
    XCTAssertTrue(self.accountViewController.tabBarController.tabBar.hidden);
}

- (void)testFirstCharacterOfNameForUser {
    XCTAssertEqualObjects([self.accountViewController firstCharacterOfName:@"test"], @"T");
    XCTAssertNotEqualObjects([self.accountViewController firstCharacterOfName:@"jest"], @"T");
}

- (void)testConfigureStateForUser {
    GGPUser *testUser = [[GGPUser alloc] initWithDictionary:@{ @"profile" : @{
                                                                       @"photoURL":@"",
                                                                       @"firstName": @"Test"
                                                                       }
                                                              }];
    
    id mockImageLogoView = OCMPartialMock(self.accountViewController.avatarImageView);
    
    OCMExpect([mockImageLogoView setImageWithURL:[NSURL URLWithString:testUser.photoURL] defaultName:[self.accountViewController firstCharacterOfName:testUser.firstName] andFont:[UIFont ggp_boldWithSize:40]]);
    
    [self.accountViewController configureStateForUser:testUser];
    
    OCMVerifyAll(mockImageLogoView);
    XCTAssertEqualObjects(self.accountViewController.greetingLabel.text, @"Hello, Test!");
}

@end
