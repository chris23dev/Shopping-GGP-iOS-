//
//  GGPTenantPromotionCellTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPTenantPromotionCell.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "GGPSale.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface GGPTenantPromotionCellTests : XCTestCase
@property (strong, nonatomic) GGPTenantPromotionCell *cell;
@end

@interface GGPTenantPromotionCell (Testing)
@property (weak, nonatomic) IBOutlet UIImageView *promoImageView;
@property (weak, nonatomic) IBOutlet UILabel *promoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoDateLabel;
@end

@implementation GGPTenantPromotionCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[[NSBundle mainBundle] loadNibNamed:@"GGPTenantPromotionCell" owner:self options:nil] lastObject];
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testOutletsInitialized {
    XCTAssertEqual(self.cell.selectionStyle, UITableViewCellSelectionStyleNone);
    XCTAssertNotNil(self.cell.promoImageView);
    XCTAssertNotNil(self.cell.promoTitleLabel);
    XCTAssertNotNil(self.cell.promoDateLabel);
}

- (void)testSetupTextStyling {
    XCTAssertEqualObjects(self.cell.promoTitleLabel.font, [UIFont ggp_boldWithSize:16]);
    XCTAssertEqualObjects(self.cell.promoTitleLabel.textColor, [UIColor ggp_blue]);
    
    XCTAssertEqualObjects(self.cell.promoDateLabel.font, [UIFont ggp_lightWithSize:16]);
    XCTAssertEqualObjects(self.cell.promoDateLabel.textColor, [UIColor blackColor]);
}

- (void)testConfigureCellWithPromotion {
    NSString *saleTitle = @"Sale Title";
    NSString *saleDate = @"Dec 24";
    NSURL *saleImageUrl = [NSURL URLWithString:@"some.website.url"];
    
    id mockSale = OCMClassMock(GGPSale.class);
    [OCMStub([mockSale title]) andReturn:saleTitle];
    [OCMStub([mockSale promotionDates]) andReturn:saleDate];
    [OCMStub([mockSale imageUrl]) andReturn:saleImageUrl];

    id mockSaleImageView = OCMPartialMock(self.cell.promoImageView);
    OCMStub([mockSaleImageView image]);
    OCMExpect([mockSaleImageView setImageWithURL:OCMOCK_ANY]);
    id mockCellView = OCMPartialMock(self.cell);
    [OCMStub([mockCellView promoImageView]) andReturn:mockSaleImageView];
    
    [self.cell configureCellWithPromotion:mockSale isFirstCell:NO];
    
    [mockSaleImageView stopMocking];
    [mockSale stopMocking];
    [mockCellView stopMocking];
}

@end
