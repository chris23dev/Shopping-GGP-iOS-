//
//  GGPWebViewControllerTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPWebViewController.h"
#import "GGPAccessibilityIdentifierConstants.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import <AFNetworking/UIWebView+AFNetworking.h>

@interface GGPWebViewControllerTests : XCTestCase
@property (strong, nonatomic) GGPWebViewController *webViewController;
@end

@interface GGPWebViewController (Testing) <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *closeButtonContainerView;
@property (strong, nonatomic) NSURL *webViewUrl;
- (void)configureNavigationStyling;
- (void)configureAccessibilityIdentifiers;
- (IBAction)closeButtonTapped:(id)sender;
@end

@implementation GGPWebViewControllerTests

static NSString* const kWebViewUrl = @"website.url";

- (void)setUp {
    [super setUp];
    self.webViewController = [[GGPWebViewController alloc] initWithUrlString:kWebViewUrl];
    [self.webViewController view];
}

- (void)tearDown {
    self.webViewController = nil;
    [super tearDown];
}

- (void)testViewDidLoad {
    XCTAssertFalse(self.webViewController.webView.scrollView.bounces);
    XCTAssertEqual(self.webViewController.webView.delegate, self.webViewController);
    XCTAssertEqualObjects(self.webViewController.webViewUrl, [NSURL URLWithString:kWebViewUrl]);
}

- (void)testConfigureNavigationStyling {
    XCTAssertEqualObjects(self.webViewController.closeButtonContainerView.backgroundColor, [UIColor ggp_colorFromHexString:@"#0054a4"]);
    
    XCTAssertEqualObjects(self.webViewController.closeButton.titleLabel.font, [UIFont ggp_lightWithSize:15]);
    XCTAssertEqualObjects(self.webViewController.closeButton.currentTitleColor, [UIColor whiteColor]);
    XCTAssertEqualObjects(self.webViewController.closeButton.currentTitle, [@"NAV_MENU_CLOSE_BUTTON" ggp_toLocalized]);
}

- (void)testConfigureAccessibilityIdentifiers {
    self.webViewController.webView.accessibilityIdentifier = GGPWebViewControllerWebViewId;
    self.webViewController.closeButton.accessibilityIdentifier = GGPWebViewControllerCloseButtonId;
}

- (void)testCloseButtonTapped {
    id mockWebViewController = OCMPartialMock(self.webViewController);
    OCMExpect([mockWebViewController dismissViewControllerAnimated:YES completion:nil]);
    
    [mockWebViewController closeButtonTapped:nil];
    
    OCMVerifyAll(mockWebViewController);
    [mockWebViewController stopMocking];
}

- (void)testOpensURLToExternalInWebView {
    id mockUIApplication = OCMPartialMock([UIApplication sharedApplication]);
    OCMExpect([mockUIApplication openURL:OCMOCK_ANY]);
    
    id mockNSURLRequest = OCMClassMock(NSURLRequest.class);
    
    XCTAssertFalse([self.webViewController webView:self.webViewController.webView shouldStartLoadWithRequest:mockNSURLRequest navigationType:UIWebViewNavigationTypeLinkClicked]);
    
    OCMVerifyAll(mockUIApplication);
    [mockUIApplication stopMocking];
    [mockNSURLRequest stopMocking];
}

- (void)testDoesNotOpenToExternalInOtherInteractions {
    id mockUIApplication = OCMPartialMock([UIApplication sharedApplication]);
    [[mockUIApplication reject] openURL:OCMOCK_ANY];
    
    id mockNSURLRequest = OCMClassMock(NSURLRequest.class);
    
    XCTAssertTrue([self.webViewController webView:self.webViewController.webView shouldStartLoadWithRequest:mockNSURLRequest navigationType:UIWebViewNavigationTypeOther]);
    
    OCMVerifyAll(mockUIApplication);
    [mockUIApplication stopMocking];
    [mockNSURLRequest stopMocking];
}

@end
