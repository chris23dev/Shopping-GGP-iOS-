//
//  GGPUserTests.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPMall.h"
#import "GGPTenant.h"
#import "GGPUser.h"
#import "NSDate+GGPAdditions.h"

static NSString *const kProfileKey = @"profile";
static NSString *const kFirstNameKey = @"firstName";
static NSString *const kLastNameKey = @"lastName";
static NSString *const kEmailKey = @"email";
static NSString *const kGenderKey = @"gender";
static NSString *const kBirthdateKey = @"birthdate";
static NSString *const kGigyaZipCodeKey = @"zip";
static NSString *const kOriginMallIdKey = @"originMallId";
static NSString *const kOriginMallNameKey = @"originMallName";
static NSString *const kTermsKey = @"terms";
static NSString *const kMallId1Key = @"MallId1";
static NSString *const kMallId2Key = @"MallId2";
static NSString *const kMallId3Key = @"MallId3";
static NSString *const kMallId4Key = @"MallId4";
static NSString *const kMallId5Key = @"MallId5";

static NSString *const kGigyaBirthYearKey = @"birthYear";
static NSString *const kGigyaBirthMonthKey = @"birthMonth";
static NSString *const kGigyaBirthDayKey = @"birthDay";
static NSString *const kDataKey = @"data";
static NSString *const kEmailSubscribedKey = @"emailSubscribed";
static NSString *const kSMSSubscribedKey = @"smsSubscribed";
static NSString *const kMobilePhoneKey = @"mobilePhone";

@interface GGPUser (Testing)

- (NSMutableArray *)createFavoritesFromData:(NSString *)favoritesData;
- (NSArray *)populatedMallIds;
- (BOOL)hasBirthComponents;
- (NSString *)defaultMallId1;

@end

@interface GGPUserTests : XCTestCase

@end

@implementation GGPUserTests

- (void)testCreateFavorites {
    NSString *favoritesData = @"[100,300]";
    
    GGPUser *user = [GGPUser new];
    user.favorites = [user createFavoritesFromData:favoritesData];
    
    XCTAssertEqual(user.favorites.count, 2);
    XCTAssertTrue([user.favorites containsObject:@(100)]);
    XCTAssertTrue([user.favorites containsObject:@(300)]);
}

- (void)testCreateEmptyFavorites {
    NSString *favoritesData = @"[]";
    
    GGPUser *user = [GGPUser new];
    user.favorites = [user createFavoritesFromData:favoritesData];
    XCTAssertNotNil(user.favorites);
    XCTAssertEqual(user.favorites.count, 0);
}

- (void)testCreateNilFavorites {
    GGPUser *user = [GGPUser new];
    user.favorites = [user createFavoritesFromData:nil];
    XCTAssertNotNil(user.favorites);
    XCTAssertEqual(user.favorites.count, 0);
}

- (void)testDictionaryForFavorite {
    NSArray *favorites = @[@(100), @(300)];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:favorites options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *expectedResult = @{ @"favorite_tenants" : jsonString };
    
    GGPUser *user = OCMPartialMock([GGPUser new]);
    [OCMStub([user favorites]) andReturn:favorites];
    
    NSDictionary *result = [user dictionaryForFavorites];
    
    XCTAssertEqualObjects(result, expectedResult);
}

- (void)testAddFavorite {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant placeWiseRetailerId]) andReturnValue:OCMOCK_VALUE(100)];
    
    GGPUser *user = [GGPUser new];
    user.favorites = [NSMutableArray new];
    
    [user toggleFavorite:mockTenant];
    
    XCTAssertEqual(user.favorites.count, 1);
    XCTAssertTrue([user.favorites containsObject:@(100)]);
}

- (void)testRemoveFavorite {
    id mockTenant = OCMPartialMock([GGPTenant new]);
    [OCMStub([mockTenant placeWiseRetailerId]) andReturnValue:OCMOCK_VALUE(100)];
    [OCMStub([mockTenant isFavorite]) andReturnValue:OCMOCK_VALUE(YES)];
    
    GGPUser *user = [GGPUser new];
    user.favorites = [@[@(100), @(200)] mutableCopy];
    
    [user toggleFavorite:mockTenant];
    
    XCTAssertEqual(user.favorites.count, 1);
    XCTAssertTrue([user.favorites containsObject:@(200)]);
}

- (void)testUserWithSocialLogin {
    GGPUser *user = [GGPUser new];
    user.loginProvider = @"googleplus";
    XCTAssertTrue(user.isSocialLogin);
}

- (void)testUserWithoutSocialLogin {
    GGPUser *user = [GGPUser new];
    user.loginProvider = @"site";
    XCTAssertFalse(user.isSocialLogin);
}

- (void)testSetGender {
    GGPUser *user = [GGPUser new];
    user.gender = @"Female";
    XCTAssertEqualObjects(user.gender, @"f");
    user.gender = @"Male";
    XCTAssertEqualObjects(user.gender, @"m");
    user.gender = @"Unspecified";
    XCTAssertEqualObjects(user.gender, @"u");
}

- (void)testGenderForDisplay {
    GGPUser *user = [GGPUser new];
    user.gender = @"f";
    XCTAssertEqualObjects(user.genderForDisplay, @"Female");
    user.gender = @"m";
    XCTAssertEqualObjects(user.genderForDisplay, @"Male");
    user.gender = @"u";
    XCTAssertEqualObjects(user.genderForDisplay, @"Unspecified");
    user.gender = nil;
    XCTAssertEqualObjects(user.genderForDisplay, @"Unspecified");
}

- (void)testSetBirthdate {
    GGPUser *user = [GGPUser new];
    user.birthdate = [NSDate ggp_createDateWithMinutes:0 hour:0 day:03 month:10 year:1989];
    XCTAssertEqual(user.birthYear, 1989);
    XCTAssertEqual(user.birthMonth, 10);
    XCTAssertEqual(user.birthDay, 03);
}

- (void)testSetEmptyBirthdate {
    GGPUser *user = [GGPUser new];
    user.birthdate = nil;
    XCTAssertEqual(user.birthYear, 0);
    XCTAssertEqual(user.birthMonth, 0);
    XCTAssertEqual(user.birthDay, 0);
}

- (void)testGetBirthdate {
    GGPUser *user = [GGPUser new];
    NSInteger year = 1989;
    NSInteger month = 10;
    NSInteger day = 03;
    NSDate *expectedDate = [NSDate ggp_createDateWithMinutes:0 hour:0 day:day month:month year:year];
    user.birthYear = year;
    user.birthMonth = month;
    user.birthDay = day;
    XCTAssertEqualObjects(user.birthdate, expectedDate);
}

- (void)testBirthdateForDisplay {
    GGPUser *user = [GGPUser new];
    NSString *expectedString = @"Oct 3, 1989";
    user.birthYear = 1989;
    user.birthMonth = 10;
    user.birthDay = 03;
    XCTAssertEqualObjects(user.birthDateForDisplay, expectedString);
}

- (void)testEmptyBirthdateForDisplay {
    GGPUser *user = [GGPUser new];
    NSString *expectedString = @"";
    user.birthYear = 0;
    user.birthMonth = 0;
    user.birthDay = 0;
    XCTAssertEqualObjects(user.birthDateForDisplay, expectedString);
}

- (void)testUserHasDateComponents {
    GGPUser *user = [GGPUser new];
    user.birthYear = 1989;
    user.birthMonth = 10;
    user.birthDay = 03;
    XCTAssertTrue([user hasBirthComponents]);
}

- (void)testUserHasNoDateComponents {
    GGPUser *user = [GGPUser new];
    user.birthYear = 0;
    user.birthMonth = 0;
    user.birthDay = 0;
    XCTAssertFalse([user hasBirthComponents]);
}

- (void)testUserDataDictionary {
    GGPUser *user = [GGPUser new];
    NSDictionary *result = [user userDataDictionary];
    
    NSArray *dataKeys = [result[@"data"] allKeys];
    
    XCTAssertTrue([dataKeys containsObject:kOriginMallIdKey]);
    XCTAssertTrue([dataKeys containsObject:kOriginMallNameKey]);
    XCTAssertTrue([dataKeys containsObject:kEmailSubscribedKey]);
    XCTAssertTrue([dataKeys containsObject:kSMSSubscribedKey]);
    XCTAssertTrue([dataKeys containsObject:kMobilePhoneKey]);
    XCTAssertTrue([dataKeys containsObject:kTermsKey]);
    XCTAssertTrue([dataKeys containsObject:kMallId1Key]);
    XCTAssertTrue([dataKeys containsObject:kMallId2Key]);
    XCTAssertTrue([dataKeys containsObject:kMallId3Key]);
    XCTAssertTrue([dataKeys containsObject:kMallId4Key]);
    XCTAssertTrue([dataKeys containsObject:kMallId5Key]);
}

- (void)testUserProfileDictionary {
    GGPUser *user = [GGPUser new];
    NSDictionary *result = [user userProfileDictionary];
    
    NSArray *profileKeys = [result[@"profile"] allKeys];
    
    XCTAssertTrue([profileKeys containsObject:kFirstNameKey]);
    XCTAssertTrue([profileKeys containsObject:kLastNameKey]);
    XCTAssertTrue([profileKeys containsObject:kGenderKey]);
    XCTAssertTrue([profileKeys containsObject:kEmailKey]);
    XCTAssertTrue([profileKeys containsObject:kGigyaZipCodeKey]);
    XCTAssertTrue([profileKeys containsObject:kGigyaBirthYearKey]);
    XCTAssertTrue([profileKeys containsObject:kGigyaBirthMonthKey]);
    XCTAssertTrue([profileKeys containsObject:kGigyaBirthDayKey]);
}

- (void)testMallIdsForUser {
    GGPUser *user = [GGPUser new];
    user.mallId1 = @"1";
    user.mallId2 = @"2";
    XCTAssertEqual([user populatedMallIds].count, 2);
}

- (void)testPreferredMallsFromAllMalls {
    GGPUser *user = [GGPUser new];
    user.mallId1 = @"1";
    
    id mockMall1 = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall1 mallId]) andReturnValue:@(1)];
    
    id mockMall2 = OCMPartialMock([GGPMall new]);
    [OCMStub([mockMall2 mallId]) andReturnValue:@(2)];
    
    NSArray *allMalls = @[ mockMall1, mockMall2 ];
    XCTAssertEqual([user preferredMallsListFromAllMalls:allMalls].count, 1);
}

- (void)testDefaultMallId1WithMallId {
    GGPUser *user = [GGPUser new];
    user.mallId1 = @"123";
    XCTAssertEqualObjects([user defaultMallId1], @"123");
}

- (void)testDefaultMallId1WithOriginMallId {
    GGPUser *user = [GGPUser new];
    user.mallId1 = @"";
    user.originMallId = @"123";
    XCTAssertEqualObjects([user defaultMallId1], @"123");
}

@end
