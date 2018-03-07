//
//  UIViewController+GGPAdditionsTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPWebViewController.h"
#import "NSString+GGPAdditions.h"
#import "UIViewController+GGPAdditions.h"
#import <UIKit/UIKit.h>

@interface UIViewControllerGGPAdditionsTests : XCTestCase

@property UIViewController *parentViewController;
@property UIViewController *childViewController;
@property UIView *placeHolderView;

@end

@implementation UIViewControllerGGPAdditionsTests

- (void)setUp {
    [super setUp];
    self.parentViewController = [UIViewController new];
    self.childViewController = [UIViewController new];
    self.placeHolderView = [UIView new];
    
    [self.parentViewController ggp_addChildViewController:self.childViewController toPlaceholderView:self.placeHolderView];
}

- (void)tearDown {
    self.parentViewController = nil;
    self.childViewController = nil;
    self.placeHolderView = nil;
    [super tearDown];
}

- (void)testAddChildViewControllerAddsToParentViewController {
    XCTAssertEqualObjects(self.childViewController.parentViewController, self.parentViewController);
}

- (void)testAddChildViewControllerAddsChildViewToPlaceholderView {
    XCTAssertEqualObjects(self.childViewController.view.superview, self.placeHolderView);
}

- (void)testAddChildViewControllerConstraintsFillsSuperView {
    XCTAssertEqual(self.placeHolderView.constraints.count, 4);
    NSLayoutConstraint *top = (NSLayoutConstraint *)self.placeHolderView.constraints[0];
    NSLayoutConstraint *bottom = (NSLayoutConstraint *)self.placeHolderView.constraints[1];
    NSLayoutConstraint *leading = (NSLayoutConstraint *)self.placeHolderView.constraints[2];
    NSLayoutConstraint *trailing = (NSLayoutConstraint *)self.placeHolderView.constraints[3];
    
    XCTAssertEqual(top.firstAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(top.secondAttribute, NSLayoutAttributeTop);
    
    XCTAssertEqual(bottom.firstAttribute, NSLayoutAttributeBottom);
    XCTAssertEqual(bottom.secondAttribute, NSLayoutAttributeBottom);
    
    XCTAssertEqual(leading.firstAttribute, NSLayoutAttributeLeading);
    XCTAssertEqual(leading.secondAttribute, NSLayoutAttributeLeading);
    
    XCTAssertEqual(trailing.firstAttribute, NSLayoutAttributeTrailing);
    XCTAssertEqual(trailing.secondAttribute, NSLayoutAttributeTrailing);
    
    for (NSLayoutConstraint *constraint in self.placeHolderView.constraints) {
        XCTAssertEqualObjects(constraint.firstItem, self.childViewController.view);
        XCTAssertEqualObjects(constraint.secondItem, self.placeHolderView);
        XCTAssertEqual(constraint.constant, 0);
        XCTAssertEqual(constraint.multiplier, 1);
    }
}

- (void)testChildViewControllersContainObjectOfClass {
    UIViewController *testController = [UIViewController new];
    XCTAssertFalse([testController ggp_childViewControllersContainViewControllerOfClass:GGPWebViewController.class]);
    [testController addChildViewController:[UIViewController new]];
    XCTAssertFalse([testController ggp_childViewControllersContainViewControllerOfClass:GGPWebViewController.class]);
    [testController addChildViewController:[GGPWebViewController new]];
    XCTAssertTrue([testController ggp_childViewControllersContainViewControllerOfClass:GGPWebViewController.class]);
    [testController addChildViewController:[UIViewController new]];
    XCTAssertTrue([testController ggp_childViewControllersContainViewControllerOfClass:GGPWebViewController.class]);
}

- (void)testBackButtonTappedHasChanges {
    UIViewController *viewController = [UIViewController new];
    id mockController = OCMPartialMock(viewController);
    
    OCMExpect([mockController ggp_displayAlertWithTitle:[@"ALERT_UNSAVED_CHANGES_TITLE" ggp_toLocalized] message:[@"ALERT_UNSAVED_CHANGES_TEXT" ggp_toLocalized] actionTitle:[@"ALERT_UNSAVED_CHANGES_LEAVE" ggp_toLocalized] actionCompletion:OCMOCK_ANY cancelTitle:[@"ALERT_UNSAVED_CHANGES_STAY" ggp_toLocalized] cancelCompletion:OCMOCK_ANY]);
    
    [viewController ggp_accountBackButtonPressedForState:YES];
    
    OCMVerifyAll(mockController);
}

- (void)testBackButtonTappedNoChanges {
    UIViewController *viewController = [UIViewController new];
    id mockController = OCMPartialMock(viewController);
    id mockNavController = OCMPartialMock([UINavigationController new]);
    
    [OCMStub([mockController navigationController]) andReturn:mockNavController];
    OCMExpect([mockNavController popViewControllerAnimated:YES]);
    
    [viewController ggp_accountBackButtonPressedForState:NO];
    
    OCMVerifyAll(mockNavController);
}

@end
