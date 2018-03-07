//
//  GGPShoppingTableViewCellTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/20/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPShoppingTableViewCell.h"
#import "GGPTenant.h"
#import "NSString+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"

@interface GGPShoppingTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *tenantLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@end

@interface GGPShoppingTableViewCellTests : XCTestCase
@property (strong, nonatomic) GGPShoppingTableViewCell *cell;
@end

@implementation GGPShoppingTableViewCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[[NSBundle mainBundle] loadNibNamed:@"GGPShoppingTableViewCell" owner:self options:nil] lastObject];
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testConfigureCellWithSale {
    NSString *salesDate = @"OCT 20 - DEC 18";
    NSString *saleTitle = @"this is a sale!";
    NSString *saleTenant = @"tenant name";
    
    id mockTenant = OCMPartialMock([GGPTenant new]);
    
    id mockSale = OCMClassMock(GGPSale.class);
    [OCMStub([mockSale promotionDates]) andReturn:salesDate];
    [OCMStub([mockSale title]) andReturn:saleTitle];
    [OCMStub([mockSale tenantName]) andReturn:saleTenant];
    [OCMStub([mockSale tenant]) andReturn:mockTenant];
    
    [self.cell configureCellWithSale:mockSale];
    
    XCTAssertEqualObjects(self.cell.titleLabel.text, saleTitle);
    XCTAssertEqualObjects(self.cell.tenantLabel.text, saleTenant);
    XCTAssertEqualObjects(self.cell.dateLabel.text, salesDate);
    XCTAssertNotNil(self.cell.logoImageView);

}

@end
