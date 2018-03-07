//
//  GGPAddressTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/15/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Mantle/MTLJSONAdapter.h>
#import "GGPAddress.h"

@interface GGPAddressTests : XCTestCase

@property (strong, nonatomic) GGPAddress *address;
@property (strong, nonatomic) NSDictionary *jsonDictionary;

@end

@implementation GGPAddressTests

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"address" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.address = (GGPAddress *)[MTLJSONAdapter modelOfClass:GGPAddress.class fromJSONDictionary:self.jsonDictionary error:nil];
}

- (void)tearDown {
    self.address = nil;
    self.jsonDictionary = nil;
    [super tearDown];
}

- (void)testAddressProperties {
    XCTAssertNotNil(self.address);
    XCTAssertNotNil(self.address.line1);
    XCTAssertEqual(self.address.line1, self.jsonDictionary[@"line1"]);
    XCTAssertEqual(self.address.line2, self.jsonDictionary[@"line2"]);
    XCTAssertEqual(self.address.line3, self.jsonDictionary[@"line3"]);
    XCTAssertEqual(self.address.city, self.jsonDictionary[@"city"]);
    XCTAssertEqual(self.address.state, self.jsonDictionary[@"state"]);
    XCTAssertEqual(self.address.zip, self.jsonDictionary[@"zip"]);
}

- (void)testFullAddressAllLines {
    NSString *expectedAddress = @"123 Apple St Unit 1 Part 2\nChicago,\u00a0IL\u00a060601";
    
    GGPAddress *mockAddress = OCMPartialMock([GGPAddress new]);
    [OCMStub([mockAddress line1]) andReturn:@"123 Apple St"];
    [OCMStub([mockAddress line2]) andReturn:@"Unit 1"];
    [OCMStub([mockAddress line3]) andReturn:@"Part 2"];
    [OCMStub([mockAddress city]) andReturn:@"Chicago"];
    [OCMStub([mockAddress state]) andReturn:@"IL"];
    [OCMStub([mockAddress zip]) andReturn:@"60601"];
    
    NSString *result = mockAddress.fullAddress;
    
    XCTAssertEqualObjects(result, expectedAddress);
}

- (void)testFullAddressOneLine {
    NSString *expectedAddress = @"123 Apple St\nChicago,\u00a0IL\u00a060601";
    
    GGPAddress *mockAddress = OCMPartialMock([GGPAddress new]);
    [OCMStub([mockAddress line1]) andReturn:@"123 Apple St"];
    [OCMStub([mockAddress city]) andReturn:@"Chicago"];
    [OCMStub([mockAddress state]) andReturn:@"IL"];
    [OCMStub([mockAddress zip]) andReturn:@"60601"];
    
    NSString *result = mockAddress.fullAddress;
    
    XCTAssertEqualObjects(result, expectedAddress);
}

@end
