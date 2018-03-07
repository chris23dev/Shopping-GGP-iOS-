//
//  UIView+GGPAdditionsTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/17/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+GGPAdditions.h"

@interface UIView (GGPAdditionsTests)

- (NSLayoutConstraint *)ggp_topMarginConstraint;
- (NSLayoutConstraint *)ggp_leadingMarginConstraint;
- (NSLayoutConstraint *)ggp_heightConstraint;
- (NSLayoutConstraint *)ggp_widthConstraint;
- (void)ggp_addBorderRadius:(float)radius;
- (void)ggp_addBorderWithWidth:(float)width andColor:(UIColor *)color;
- (BOOL)ggp_isCollapsed;

@end

@interface UIViewGGPAdditionsTests : XCTestCase

@property UIView *subView;
@property UIView *superView;

@end

@implementation UIViewGGPAdditionsTests

- (void)setUp {
    [super setUp];
    self.subView  = [UIView new];
    self.superView = [UIView new];
}

- (void)tearDown {
    self.subView = nil;
    self.superView = nil;
    [super tearDown];
}

- (void)testAddConstraintsToFillSuperviewFillsSuperView {
    [self.superView addSubview:self.subView];
    [self.subView ggp_addConstraintsToFillSuperview];
    
    XCTAssertEqual(self.superView.constraints.count, 4);
    
    NSLayoutConstraint *top = (NSLayoutConstraint *)self.superView.constraints[0];
    NSLayoutConstraint *bottom = (NSLayoutConstraint *)self.superView.constraints[1];
    NSLayoutConstraint *leading = (NSLayoutConstraint *)self.superView.constraints[2];
    NSLayoutConstraint *trailing = (NSLayoutConstraint *)self.superView.constraints[3];
    
    XCTAssertEqual(top.firstAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(top.secondAttribute, NSLayoutAttributeTop);
    
    XCTAssertEqual(bottom.firstAttribute, NSLayoutAttributeBottom);
    XCTAssertEqual(bottom.secondAttribute, NSLayoutAttributeBottom);
    
    XCTAssertEqual(leading.firstAttribute, NSLayoutAttributeLeading);
    XCTAssertEqual(leading.secondAttribute, NSLayoutAttributeLeading);
    
    XCTAssertEqual(trailing.firstAttribute, NSLayoutAttributeTrailing);
    XCTAssertEqual(trailing.secondAttribute, NSLayoutAttributeTrailing);
    
    for (NSLayoutConstraint *constraint in self.superView.constraints) {
        XCTAssertEqualObjects(constraint.firstItem, self.subView);
        XCTAssertEqualObjects(constraint.secondItem, self.superView);
        XCTAssertEqual(constraint.constant, 0);
        XCTAssertEqual(constraint.multiplier, 1);
    }
}

- (void)testAddConstraintsToFillSuperviewSetsTranslatesAutoresizingMaskIntoConstraintsToNo {
    [self.superView addSubview:self.subView];
    [self.subView ggp_addConstraintsToFillSuperview];
    
    XCTAssertFalse(self.subView.translatesAutoresizingMaskIntoConstraints);
}

- (void)testAddConstraintsToFillSuperviewShouldNotCrashWithNoSuperView {
    [self.subView ggp_addConstraintsToFillSuperview];
}

- (void)testAddShadowWithRadius {
    float radius = 3;
    float opacity = 0.5;
    [self.subView ggp_addShadowWithRadius:radius andOpacity:opacity];
    XCTAssertFalse(self.subView.clipsToBounds);
    XCTAssertEqual(self.subView.layer.shadowColor, [UIColor blackColor].CGColor);
    XCTAssertEqual(self.subView.layer.shadowOpacity, opacity);
    XCTAssertEqual(self.subView.layer.shadowRadius, radius);
    XCTAssertEqual(self.subView.layer.shadowOffset.width, 0);
    XCTAssertEqual(self.subView.layer.shadowOffset.height, 0);
}

- (void)testAddBorderRadius {
    float radius = 4;
    [self.subView ggp_addBorderRadius:radius];
    XCTAssertEqual(self.subView.layer.cornerRadius, radius);
}

- (void)testAddBorderWidthAndColor {
    float width = 1;
    UIColor *color = [UIColor grayColor];
    [self.subView ggp_addBorderWithWidth:width andColor:color];
    XCTAssertEqual(self.subView.layer.borderWidth, width);
    XCTAssertEqual(self.subView.layer.borderColor, color.CGColor);
}

- (void)testCollapseVertically {
    UIView *mockView = OCMPartialMock([UIView new]);
    NSLayoutConstraint *mockTopConstraint = OCMPartialMock([NSLayoutConstraint new]);
    NSLayoutConstraint *mockHeightConstraint = OCMPartialMock([NSLayoutConstraint new]);
    
    mockView.frame = CGRectMake(0, 0, 50, 50);
    mockTopConstraint.constant = 5;
    mockHeightConstraint.constant = 50;
    
    [OCMStub([mockView ggp_isCollapsed]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockView ggp_topMarginConstraint]) andReturn:mockTopConstraint];
    [OCMStub([mockView ggp_heightConstraint]) andReturn:mockHeightConstraint];
    
    [mockView ggp_collapseVertically];
    
    XCTAssertEqualObjects(mockView.originalTopMargin, @(5));
    XCTAssertEqualObjects(mockView.originalHeight, @(50));
    XCTAssertEqual(mockTopConstraint.constant, 0);
    XCTAssertEqual(mockHeightConstraint.constant, 0);
}

- (void)testCollapseVerticallyAlreadyCollapsed {
    id mockView = OCMPartialMock([UIView new]);
    
    [OCMStub([mockView ggp_isCollapsed]) andReturnValue:OCMOCK_VALUE(YES)];
    [[mockView reject] originalTopMargin];
    
    [mockView ggp_collapseVertically];
    
    OCMVerify(mockView);
}

- (void)testCollapseHorizontally {
    UIView *mockView = OCMPartialMock([UIView new]);
    NSLayoutConstraint *mockLeadingConstraint = OCMPartialMock([NSLayoutConstraint new]);
    NSLayoutConstraint *mockWidthConstraint = OCMPartialMock([NSLayoutConstraint new]);
    
    mockView.frame = CGRectMake(0, 0, 50, 50);
    mockLeadingConstraint.constant = 5;
    mockWidthConstraint.constant = 50;
    
    [OCMStub([mockView ggp_isCollapsed]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockView ggp_leadingMarginConstraint]) andReturn:mockLeadingConstraint];
    [OCMStub([mockView ggp_widthConstraint]) andReturn:mockWidthConstraint];
    
    [mockView ggp_collapseHorizontally];
    
    XCTAssertEqualObjects(mockView.originalLeadingMargin, @(5));
    XCTAssertEqualObjects(mockView.originalWidth, @(50));
    XCTAssertEqual(mockLeadingConstraint.constant, 0);
    XCTAssertEqual(mockWidthConstraint.constant, 0);
}

- (void)testCollapseHorizontallyAlreadyCollapsed {
    id mockView = OCMPartialMock([UIView new]);
    
    [OCMStub([mockView ggp_isCollapsed]) andReturnValue:OCMOCK_VALUE(YES)];
    [[mockView reject] originalLeadingMargin];
    
    [mockView ggp_collapseHorizontally];
    
    OCMVerify(mockView);
}

- (void)testExpandVertically {
    UIView *mockView = OCMPartialMock([UIView new]);
    NSLayoutConstraint *mockTopConstraint = OCMPartialMock([NSLayoutConstraint new]);
    NSLayoutConstraint *mockHeightConstraint = OCMPartialMock([NSLayoutConstraint new]);
    
    [OCMStub([mockView ggp_isCollapsed]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockView ggp_topMarginConstraint]) andReturn:mockTopConstraint];
    [OCMStub([mockView ggp_heightConstraint]) andReturn:mockHeightConstraint];
    
    mockView.originalTopMargin = @(10);
    mockView.originalHeight = @(20);
    
    [mockView ggp_expandVertically];
    
    XCTAssertEqual(mockTopConstraint.constant, 10);
    XCTAssertEqual(mockHeightConstraint.constant, 20);
}

- (void)testExpandVerticallyAlreadyExpanded {
    id mockView = OCMPartialMock([UIView new]);
    
    [OCMStub([mockView ggp_isCollapsed]) andReturnValue:OCMOCK_VALUE(NO)];
    [[mockView reject] ggp_topMarginConstraint];
    
    [mockView ggp_expandVertically];
    
    OCMVerify(mockView);
}

- (void)testExpandHorizontally {
    UIView *mockView = OCMPartialMock([UIView new]);
    NSLayoutConstraint *mockLeadingConstraint = OCMPartialMock([NSLayoutConstraint new]);
    NSLayoutConstraint *mockWidthConstraint = OCMPartialMock([NSLayoutConstraint new]);
    
    [OCMStub([mockView ggp_isCollapsed]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockView ggp_leadingMarginConstraint]) andReturn:mockLeadingConstraint];
    [OCMStub([mockView ggp_widthConstraint]) andReturn:mockWidthConstraint];
    
    mockView.originalLeadingMargin = @(10);
    mockView.originalWidth = @(20);
    
    [mockView ggp_expandHorizontally];
    
    XCTAssertEqual(mockLeadingConstraint.constant, 10);
    XCTAssertEqual(mockWidthConstraint.constant, 20);
}

- (void)testExpandHorizontallyAlreadyExpanded {
    id mockView = OCMPartialMock([UIView new]);
    
    [OCMStub([mockView ggp_isCollapsed]) andReturnValue:OCMOCK_VALUE(NO)];
    [[mockView reject] ggp_leadingMarginConstraint];
    
    [mockView ggp_expandVertically];
    
    OCMVerify(mockView);
}

- (void)testTopMarginConstraint {
    NSArray *superviewConstraints = [self createSuperviewMockConstraints];
    
    [self.superView addSubview:self.subView];
    [self.superView addConstraints:superviewConstraints];
    
    XCTAssertEqual([self.subView ggp_topMarginConstraint], superviewConstraints[0]);
}

- (void)testLeadingMarginConstraint {
    NSArray *superviewConstraints = [self createSuperviewMockConstraints];
    
    [self.superView addSubview:self.subView];
    [self.superView addConstraints:superviewConstraints];
    
    XCTAssertEqual([self.subView ggp_leadingMarginConstraint], superviewConstraints[1]);
}

- (void)testHeightConstraint {
    NSArray *subviewConstraints = [self createSubviewMockConstraints];
    
    [self.subView addConstraints:subviewConstraints];
    
    XCTAssertEqual([self.subView ggp_heightConstraint], subviewConstraints[0]);
}

- (void)testHeightConstraintDoesntInitiallyExist {
    XCTAssertNotNil([self.subView ggp_heightConstraint]);
}

- (void)testWidthConstraint {
    NSArray *subviewConstraints = [self createSubviewMockConstraints];
    
    [self.subView addConstraints:subviewConstraints];
    
    XCTAssertEqual([self.subView ggp_widthConstraint], subviewConstraints[1]);
}

- (void)testWidthConstraintDoesntInitallyExist {
    XCTAssertNotNil([self.subView ggp_widthConstraint]);
}

- (NSArray *)createSuperviewMockConstraints {
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superView attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.subView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superView attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.superView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.subView attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    
    return @[topConstraint, leadingConstraint, bottomConstraint];
}

- (NSArray *)createSubviewMockConstraints {
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
    
    return @[heightConstraint, widthConstraint];
}

@end
