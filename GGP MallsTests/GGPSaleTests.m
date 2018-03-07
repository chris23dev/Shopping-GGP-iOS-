//
//  GGPSaleTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPSale.h"
#import <Mantle/MTLJSONAdapter.h>

@interface GGPSaleTests : XCTestCase

@property (strong, nonatomic) GGPSale *sale;
@property (strong, nonatomic) NSDictionary *jsonDictionary;

@end

@interface GGPSale (Testing)
@property (strong, nonatomic) NSString *saleImageUrl;
@end

@implementation GGPSaleTests

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"sale" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.sale = (GGPSale *)[MTLJSONAdapter modelOfClass:GGPSale.class fromJSONDictionary:self.jsonDictionary error:nil];
}

- (void)tearDown {
    self.sale = nil;
    self.jsonDictionary = nil;
    [super tearDown];
}

- (void)testSaleProperties {
    XCTAssertNotNil(self.sale);
    XCTAssertNotNil(self.sale.tenant);
    XCTAssertNotNil(self.sale.categories);
    XCTAssertNotEqual(self.sale.tenant.tenantId, 0);
    XCTAssertEqual(self.sale.isFeatured, [self.jsonDictionary[@"featured"] boolValue]);
    XCTAssertEqualObjects(self.sale.type, self.jsonDictionary[@"type"]);
    XCTAssertEqualObjects(self.sale.title, self.jsonDictionary[@"title"]);
    XCTAssertEqualObjects(self.sale.saleDescription, self.jsonDictionary[@"description"]);
    XCTAssertEqualObjects(self.sale.saleImageUrl, self.jsonDictionary[@"imageUrl"]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat  = @"yyyy-MM-dd'T'HH:mm";
    XCTAssertEqualObjects(self.sale.displayDateTime, [dateFormatter dateFromString:self.jsonDictionary[@"displayDateTime"]]);
    XCTAssertEqualObjects(self.sale.startDateTime, [dateFormatter dateFromString:self.jsonDictionary[@"startDateTime"]]);
    XCTAssertEqualObjects(self.sale.endDateTime, [dateFormatter dateFromString:self.jsonDictionary[@"endDateTime"]]);
}

- (void)testSaleImageUrl {
    NSURL *expected = [NSURL URLWithString:@"http://images.shoptopia.com/mcache/{size}/sales/5415/Holiday2015_450x500_Jpegs13.jpg"];
    XCTAssertEqualObjects(expected, self.sale.imageUrl);
}

- (void)testSaleImageUrlNoImageUrl {
    id mockSale = OCMPartialMock(self.sale);
    [OCMStub([mockSale imageUrl]) andReturn:nil];
    XCTAssertNil(self.sale.imageUrl);
}

@end
