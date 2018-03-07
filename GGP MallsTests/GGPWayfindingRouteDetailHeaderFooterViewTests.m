//
//  GGPWayfindingRouteDetailHeaderFooterViewTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/18/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenant.h"
#import "GGPWayfindingRouteDetailHeaderFooterView.h"
#import <XCTest/XCTest.h>

@interface GGPWayfindingRouteDetailHeaderFooterViewTests : XCTestCase

@property GGPWayfindingRouteDetailHeaderFooterView *headerFooterview;
@property GGPTenant *tenant;

@end

@interface GGPWayfindingRouteDetailHeaderFooterView (Testing)

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *tenantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenantLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;
@property (strong, nonatomic) GGPTenant *tenant;
@property (assign, nonatomic) BOOL isFooterView;

- (void)configureLabels;

@end

@implementation GGPWayfindingRouteDetailHeaderFooterViewTests

- (void)setUp {
    [super setUp];
    self.tenant = [[GGPTenant alloc] initWithDictionary:@{ @"name": @"Mock tenant" } error:nil];
    self.headerFooterview = [[NSBundle mainBundle] loadNibNamed:@"GGPWayfindingRouteDetailHeaderFooterView" owner:self options:nil][0];
}

- (void)tearDown {
    self.headerFooterview = nil;
    [super tearDown];
}

- (void)testOutlets {
    [self.headerFooterview configureWithTenant:self.tenant isFooterView:NO];
    XCTAssertNotNil(self.headerFooterview.iconImageView);
    XCTAssertNotNil(self.headerFooterview.tenantNameLabel);
    XCTAssertNotNil(self.headerFooterview.tenantLevelLabel);
    XCTAssertNotNil(self.headerFooterview.disclaimerLabel);
    XCTAssertEqual(self.headerFooterview.tenant, self.tenant);
    XCTAssertFalse(self.headerFooterview.isFooterView);
}

- (void)testLabelsNotFooterView {
    [self.headerFooterview configureWithTenant:self.tenant isFooterView:YES];
    [self.headerFooterview configureLabels];
    XCTAssertTrue(self.headerFooterview.disclaimerLabel.hidden);
    XCTAssertEqual(self.headerFooterview.disclaimerLabel.numberOfLines, 0);
    XCTAssertEqualObjects(self.headerFooterview.tenantNameLabel.text, self.tenant.name);
}

- (void)testLabelsIsFooterview {
    [self.headerFooterview configureWithTenant:self.tenant isFooterView:YES];
    [self.headerFooterview configureLabels];
    XCTAssertTrue(self.headerFooterview.isFooterView);
    XCTAssertNotNil(self.headerFooterview.disclaimerLabel.text);
}

@end
