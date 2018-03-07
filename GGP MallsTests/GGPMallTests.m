//
//  GGPMallTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/15/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "GGPExceptionHours.h"
#import "GGPHours.h"
#import "GGPHours+Tests.h"
#import "GGPMall.h"
#import "GGPSocialMedia.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import <Mantle/MTLJSONAdapter.h>

static NSInteger const kFashionShowMallId = 1091;
static NSInteger const kPrinceKuhioPlazaMallId = 1115;
static NSInteger const kGrandCanalMallId = 1077;

@interface GGPMallTests : XCTestCase

@property (strong, nonatomic) GGPMall *mall;
@property (strong, nonatomic) NSDictionary *jsonDictionary;

@end

@interface GGPMall (Testing)

- (NSString *)formattedOpenHoursString;
- (BOOL)isOpenOnDate:(NSDate *)date;

@end

@implementation GGPMallTests

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"mall" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.mall = (GGPMall *)[MTLJSONAdapter modelOfClass:GGPMall.class fromJSONDictionary:self.jsonDictionary error:nil];
}

- (void)tearDown {
    self.mall = nil;
    self.jsonDictionary = nil;
    [super tearDown];
}

- (void)testMallProperties {
    XCTAssertNotNil(self.mall);
    XCTAssertEqual(self.mall.mallId, [self.jsonDictionary[@"id"] integerValue]);
    XCTAssertEqual(self.mall.name, self.jsonDictionary[@"name"]);
    XCTAssertEqual(self.mall.phoneNumber, self.jsonDictionary[@"phoneNumber"]);
    XCTAssertEqual(self.mall.logoUrl, self.jsonDictionary[@"logoUrl"]);
    XCTAssertEqual(self.mall.nonSvgLogoUrl, self.jsonDictionary[@"nonSvgLogoUrl"]);
    XCTAssertEqual(self.mall.websiteUrl, self.jsonDictionary[@"websiteUrl"]);
    XCTAssertEqual(self.mall.parkingDescription, self.jsonDictionary[@"parkingDescription"]);
    XCTAssertEqual(self.mall.distance, self.jsonDictionary[@"distanceFromSearchLocation"]);
    XCTAssertNotNil(self.mall.address);
    XCTAssertNotNil(self.mall.socialMedia);
    XCTAssertTrue(self.mall.hasTheater);
    XCTAssertEqual(self.mall.status, self.jsonDictionary[@"status"]);
    
    NSNumber *expectedLatitude = @([self.jsonDictionary[@"latitude"] floatValue]);
    NSNumber *expectedLongitude = @([self.jsonDictionary[@"longitude"] floatValue]);
    XCTAssertEqualObjects(self.mall.latitude, expectedLatitude);
    XCTAssertEqualObjects(self.mall.longitude, expectedLongitude);
}

- (void)testSocialMediaProperties {
    GGPSocialMedia *socialMedia = self.mall.socialMedia;
    XCTAssertTrue([[socialMedia.twitterUrl absoluteString] containsString:@"twitter"]);
    XCTAssertTrue([[socialMedia.facebookUrl absoluteString] containsString:@"facebook"]);
    XCTAssertTrue([[socialMedia.instagramUrl absoluteString] containsString:@"instagram"]);
    XCTAssertTrue([[socialMedia.pinterestUrl absoluteString] containsString:@"pinterest"]);
}

- (void)testTodaysHoursNoValidException {
    GGPHours *todaysHours = [GGPHours createTodayOperatingHours];
    GGPHours *yesterdayHours = [GGPHours createYesterdayOperatingHours];
    
    id mockMall = OCMPartialMock(self.mall);
    id mockExceptionHours = OCMPartialMock([GGPExceptionHours new]);
    
    [OCMStub([todaysHours isOpen]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockExceptionHours isOpen]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockExceptionHours isValidForDate:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(NO)];
    
    [OCMStub([mockMall exceptionHours]) andReturn:@[mockExceptionHours]];
    [OCMStub([mockMall operatingHours]) andReturn:@[yesterdayHours, todaysHours]];
    
    XCTAssertEqualObjects(self.mall.todaysHours, @[todaysHours]);
}

- (void)testTodaysHoursHasValidException {
    GGPHours *todaysHours = [GGPHours createTodayOperatingHours];
    GGPHours *yesterdayHours = [GGPHours createYesterdayOperatingHours];
    
    id mockMall = OCMPartialMock(self.mall);
    id mockExceptionHours = OCMPartialMock([GGPExceptionHours new]);
    [OCMStub([mockExceptionHours isOpen]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockExceptionHours isValidForDate:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(YES)];
    
    [OCMStub([mockMall exceptionHours]) andReturn:@[mockExceptionHours]];
    [OCMStub([mockMall operatingHours]) andReturn:@[yesterdayHours, todaysHours]];
    
    XCTAssertEqualObjects(self.mall.todaysHours, @[mockExceptionHours]);
}

- (void)testTodaysHoursNoValidExceptionIsClosed {
    GGPHours *todaysHours = [GGPHours createTodayOperatingHours];
    GGPHours *yesterdayHours = [GGPHours createYesterdayOperatingHours];
    
    id mockMall = OCMPartialMock(self.mall);
    id mockExceptionHours = OCMPartialMock([GGPExceptionHours new]);
    [OCMStub([mockExceptionHours isValidForDate:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(NO)];
    
    [OCMStub([mockMall exceptionHours]) andReturn:@[mockExceptionHours]];
    [OCMStub([mockMall operatingHours]) andReturn:@[yesterdayHours, todaysHours]];
    
    XCTAssertNil(self.mall.todaysHours);
}

- (void)testTodaysHoursHasValidExceptionIsClosed {
    GGPHours *todaysHours = [GGPHours createTodayOperatingHours];
    GGPHours *yesterdayHours = [GGPHours createYesterdayOperatingHours];
    
    id mockMall = OCMPartialMock(self.mall);
    id mockExceptionHours = OCMPartialMock([GGPExceptionHours new]);
    [OCMStub([mockExceptionHours isValidForDate:OCMOCK_ANY]) andReturnValue:OCMOCK_VALUE(YES)];
    
    [OCMStub([mockMall exceptionHours]) andReturn:@[mockExceptionHours]];
    [OCMStub([mockMall operatingHours]) andReturn:@[yesterdayHours, todaysHours]];
    
    XCTAssertNil(self.mall.todaysHours);
}

- (void)testIsEqual {
    XCTAssertFalse([[GGPMall new] isEqual:nil]);
    XCTAssertFalse([[GGPMall new] isEqual:[GGPHours new]]);
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall mallId]) andReturnValue:OCMOCK_VALUE(1234)];
    XCTAssertFalse([[GGPMall new] isEqual:mockMall]);
}

- (void)testIsInactiveWhenDispositioning {
    id mockMall = OCMPartialMock(self.mall);
    [OCMStub([mockMall status]) andReturn:@"DISPOSITIONING"];
    XCTAssertTrue([mockMall isInactive]);
}

- (void)testIsInactiveWhenDispositioned {
    id mockMall = OCMPartialMock(self.mall);
    [OCMStub([mockMall status]) andReturn:@"DISPOSITIONED"];
    XCTAssertTrue([mockMall isInactive]);
}

- (void)testCoordinates {
    XCTAssertEqual(self.mall.latitude.floatValue, self.mall.coordinates.latitude);
    XCTAssertEqual(self.mall.longitude.floatValue, self.mall.coordinates.longitude);
    XCTAssertFalse(CLLocationCoordinate2DIsValid([GGPMall new].coordinates));
}

- (void)testFormattedTodaysHoursStringOpenNow {
    id mockMall = OCMPartialMock([GGPMall new]);
    NSString *mockHours = @"9am - 10pm";
    
    [OCMStub([mockMall isOpenNow]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockMall formattedOpenHoursString]) andReturn:mockHours];
    
    NSString *result = [mockMall formattedTodaysHoursString];
    NSString *expected = [NSString stringWithFormat:@"%@: %@", [@"MORE_WERE_OPEN" ggp_toLocalized], mockHours];
    
    XCTAssertEqualObjects(result, expected);
}

- (void)testFormattedTodaysHoursStringOpenToday {
    id mockMall = OCMPartialMock([GGPMall new]);
    NSString *mockHours = @"9am - 10pm";
    
    [OCMStub([mockMall isOpenNow]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockMall isOpenToday]) andReturnValue:OCMOCK_VALUE(YES)];
    [OCMStub([mockMall formattedOpenHoursString]) andReturn:mockHours];
    
    NSString *result = [mockMall formattedTodaysHoursString];
    NSString *expected = [NSString stringWithFormat:@"%@: %@", [@"MORE_TODAYS_HOURS" ggp_toLocalized], mockHours];
    
    XCTAssertEqualObjects(result, expected);
}

- (void)testFormattedTodaysHoursStringClosed {
    id mockMall = OCMPartialMock([GGPMall new]);
    NSString *mockHours = @"9am - 10pm";
    
    [OCMStub([mockMall isOpenNow]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockMall isOpenToday]) andReturnValue:OCMOCK_VALUE(NO)];
    [OCMStub([mockMall formattedOpenHoursString]) andReturn:mockHours];
    
    NSString *result = [mockMall formattedTodaysHoursString];
    NSString *expected = [@"MORE_CLOSED" ggp_toLocalized];
    
    XCTAssertEqualObjects(result, expected);
}

- (void)testMallIsOpenNow {
    id mockHour = OCMPartialMock([GGPHours new]);
    id mockMall = OCMPartialMock([GGPMall new]);
    id mockOpenDate = [NSDate ggp_createDateWithMinutes:0 hour:11 day:6 month:3 year:2016];
    id mockBeforeOpenHoursDate = [NSDate ggp_createDateWithMinutes:0 hour:2 day:6 month:3 year:2016];
    id mockAfterOpenHoursDate = [NSDate ggp_createDateWithMinutes:0 hour:22 day:6 month:3 year:2016];
    
    [OCMStub([mockHour openTime]) andReturn:@"10:00"];
    [OCMStub([mockHour closeTime]) andReturn:@"21:00"];
    [OCMStub([mockMall todaysHours]) andReturn:@[mockHour]];
    
    XCTAssertTrue([mockMall isOpenOnDate:mockOpenDate]);
    XCTAssertFalse([mockMall isOpenOnDate:mockBeforeOpenHoursDate]);
    XCTAssertFalse([mockMall isOpenOnDate:mockAfterOpenHoursDate]);
}

- (void)testLoadingMallImage {
    GGPMall *mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall mallId]) andReturnValue:OCMOCK_VALUE(kPrinceKuhioPlazaMallId)];
    XCTAssertEqualObjects([mockMall loadingImage], [UIImage imageNamed:@"ggp_loadscreen_prince_kuhio"]);
    
    mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall mallId]) andReturnValue:OCMOCK_VALUE(kGrandCanalMallId)];
    XCTAssertEqualObjects([mockMall loadingImage], [UIImage imageNamed:@"ggp_loadscreen_grand_canal"]);
    
    mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall mallId]) andReturnValue:OCMOCK_VALUE(kFashionShowMallId)];
    XCTAssertEqualObjects([mockMall loadingImage], [UIImage imageNamed:@"ggp_loadscreen_fashion_show"]);
    
    mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall mallId]) andReturnValue:OCMOCK_VALUE(1234)];
    XCTAssertEqualObjects([mockMall loadingImage], [UIImage imageNamed:@"ggp_onboarding_background"]);
}

- (void)testHasWayinding {
    id mockConfig = OCMPartialMock([GGPMallConfig new]);
    [OCMStub([mockConfig wayfindingEnabled]) andReturnValue:OCMOCK_VALUE(YES)];
    
    id mockMall = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall config]) andReturn:mockConfig];
    
    XCTAssertTrue([mockMall hasWayFinding]);
}

@end
