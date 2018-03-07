//
//  GGPEventTests.m
//  GGP Malls
//
//  Created by Janet Lin on 1/19/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPEvent.h"
#import "GGPExternalEventLink.h"
#import "GGPMall.h"
#import "GGPMallManager.h"
#import "GGPMappings.h"
#import "GGPTenant.h"
#import <Mantle/MTLJSONAdapter.h>

@interface GGPEvent (Testing)

@property (strong, nonatomic, readonly) NSString *eventImageUrl;
@property (strong, nonatomic, readonly) NSString *defaultImageUrl;
@property (strong, nonatomic, readonly) GGPMappings *mappings;
@property (strong, nonatomic) GGPTenant *tenant;

- (NSURL *)imageUrl;

@end

@interface GGPEventTests : XCTestCase

@property (strong, nonatomic) GGPEvent *event;
@property (strong, nonatomic) NSDictionary *jsonDictionary;

@end

@implementation GGPEventTests

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"event" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.event = (GGPEvent *)[MTLJSONAdapter modelOfClass:GGPEvent.class fromJSONDictionary:self.jsonDictionary error:nil];
}

- (void)tearDown {
    self.event = nil;
    self.jsonDictionary = nil;
    [super tearDown];
}

- (void)testEventProperties {
    NSDictionary *mappings = self.jsonDictionary[@"mappings"][0];
    XCTAssertNotNil(self.event);
    XCTAssertEqual(self.event.eventId, [self.jsonDictionary[@"id"] integerValue]);
    XCTAssertEqual(self.event.mallId, [mappings[@"mallId"] integerValue]);
    XCTAssertEqual(self.event.tenantId, [mappings[@"storeIds"][0] integerValue]);
    XCTAssertEqual(self.event.isFeatured, [self.jsonDictionary[@"isFeatured"] boolValue]);
    XCTAssertEqualObjects(self.event.title, self.jsonDictionary[@"name"]);
    XCTAssertEqualObjects(self.event.location, self.jsonDictionary[@"location"]);
    XCTAssertEqualObjects(self.event.eventDescription, self.jsonDictionary[@"description"]);
    XCTAssertEqualObjects(self.event.teaserDescription, self.jsonDictionary[@"teaserDescription"]);
    XCTAssertEqualObjects(self.event.eventImageUrl, self.jsonDictionary[@"imageUrl"]);
    XCTAssertEqualObjects(self.event.externalLinks, self.jsonDictionary[@"externalLinks"]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat  = @"yyyy-MM-dd'T'HH:mm";
    XCTAssertEqualObjects(self.event.startDateTime, [dateFormatter dateFromString:self.jsonDictionary[@"startDateTime"]]);
    XCTAssertEqualObjects(self.event.endDateTime, [dateFormatter dateFromString:self.jsonDictionary[@"endDateTime"]]);
}

- (void)testEventWithEventImageUrl {
    NSURL *expected = [NSURL URLWithString:self.event.eventImageUrl];
    XCTAssertEqualObjects(expected, self.event.imageUrl);
}

- (void)testeventImageUrlNoEventImageUrlWithTenantImage {
    id mockEvent = OCMPartialMock([GGPEvent new]);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    NSURL *expected = [NSURL URLWithString:self.event.eventImageUrl];
    
    
    [OCMStub([mockTenant nonSvgLogoUrl]) andReturn:self.event.eventImageUrl];
    [OCMStub([mockEvent eventImageUrl]) andReturn:nil];
    [OCMStub([mockEvent tenant]) andReturn:mockTenant];
    
    XCTAssertEqualObjects(expected, [mockEvent imageUrl]);
}

- (void)testeventImageUrlNoImageUrlNoTenant {
    id mockEvent = OCMPartialMock([GGPEvent new]);
    id mockTenant = OCMPartialMock([GGPTenant new]);
    
    [OCMStub([mockEvent eventImageUrl]) andReturn:nil];
    [OCMStub([mockTenant nonSvgLogoUrl]) andReturn:nil];
    [OCMStub([mockEvent tenant]) andReturn:mockTenant];
    
    XCTAssertNil([mockEvent imageUrl]);
}

@end
