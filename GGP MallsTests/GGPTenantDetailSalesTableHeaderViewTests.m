//
//  GGPTenantPromotionsTableHeaderViewTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GGPTenantDetailListHeaderView.h"
#import "NSString+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"

@interface GGPTenantPromotionsTableHeaderViewTests : XCTestCase
@property (strong, nonatomic) GGPTenantDetailListHeaderView *headerView;
@end

@interface GGPTenantDetailListHeaderView (Testing)
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation GGPTenantPromotionsTableHeaderViewTests

- (void)setUp {
    [super setUp];
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"GGPTenantDetailListHeaderView" owner:self options:nil] lastObject];
}

- (void)tearDown {
    self.headerView = nil;
    [super tearDown];
}

- (void)testAwakeFromNib {
    XCTAssertEqualObjects(self.headerView.titleLabel.font, [UIFont ggp_boldWithSize:16]);
    XCTAssertEqualObjects(self.headerView.titleLabel.textColor, [UIColor blackColor]);
}

- (void)testConfigureWithTitle {
    NSString *expectedTitle = @"Expected title";
    [self.headerView configureWithTitle:expectedTitle];
    XCTAssertEqualObjects(expectedTitle, self.headerView.titleLabel.text);
}

@end
