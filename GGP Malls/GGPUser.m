//
//  GGPUser.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 3/30/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPMall.h"
#import "GGPTenant.h"
#import "GGPUser.h"
#import "NSArray+GGPAdditions.h"
#import "NSDate+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import <GigyaSDK/Gigya.h>

static NSInteger const kMaxUserMalls = 5;

// Data keys
static NSString *const kDataKey = @"data";
static NSString *const kEmailSubscribedKey = @"emailSubscribed";
static NSString *const kSMSSubscribedKey = @"smsSubscribed";
static NSString *const kMobilePhoneKey = @"mobilePhone";
static NSString *const kOriginMallIdKey = @"originMallId";
static NSString *const kOriginMallNameKey = @"originMallName";
static NSString *const kTermsKey = @"terms";
static NSString *const kMallId1Key = @"MallId1";
static NSString *const kMallId2Key = @"MallId2";
static NSString *const kMallId3Key = @"MallId3";
static NSString *const kMallId4Key = @"MallId4";
static NSString *const kMallId5Key = @"MallId5";

// Profile keys
static NSString *const kProfileKey = @"profile";
static NSString *const kFirstNameKey = @"firstName";
static NSString *const kLastNameKey = @"lastName";
static NSString *const kEmailKey = @"email";
static NSString *const kGenderKey = @"gender";
static NSString *const kBirthdateKey = @"birthdate";
static NSString *const kGigyaZipCodeKey = @"zip";

static NSString *const kGigyaBirthYearKey = @"birthYear";
static NSString *const kGigyaBirthMonthKey = @"birthMonth";
static NSString *const kGigyaBirthDayKey = @"birthDay";
static NSString *const kLoginProviderKey = @"loginProvider";
static NSString *const kFavoriteTenantsKey = @"favorite_tenants";
static NSString *const kPhotoUrlKey = @"photoURL";

static NSString *const kGenderMaleSingleCharacter = @"m";
static NSString *const kGenderFemaleSingleCharacter = @"f";
static NSString *const kGenderUnspecifiedSingleCharacter = @"u";
static NSString *const kSiteLoginProvider = @"site";

@implementation GGPUser

- (instancetype)initWithDictionary:(NSDictionary *)userData {
    self = [super init];
    if (self) {
        NSDictionary *data = userData[kDataKey];
        NSDictionary *profile = userData[kProfileKey];
        
        self.mobilePhone = data[kMobilePhoneKey];
        self.isEmailSubscribed = [data[kEmailSubscribedKey] boolValue];
        self.isSmsSubscribed = [data[kSMSSubscribedKey] boolValue];
        self.agreedToTerms = [data[kTermsKey] boolValue];
        self.originMallId = data[kOriginMallIdKey];
        self.originMallName = data[kOriginMallNameKey];
        
        self.mallId1 = data[kMallId1Key] ? data[kMallId1Key] : self.originMallId;
        self.mallId2 = data[kMallId2Key];
        self.mallId3 = data[kMallId3Key];
        self.mallId4 = data[kMallId4Key];
        self.mallId5 = data[kMallId5Key];
        
        self.favorites = [self createFavoritesFromData:data[kFavoriteTenantsKey]];
        self.loginProvider = userData[kLoginProviderKey];
        
        self.birthYear = profile[kGigyaBirthYearKey] != [NSNull null] ? [profile[kGigyaBirthYearKey] integerValue] : 0;
        self.birthMonth = profile[kGigyaBirthMonthKey] != [NSNull null] ? [profile[kGigyaBirthMonthKey] integerValue] : 0;
        self.birthDay = profile[kGigyaBirthDayKey] != [NSNull null] ? [profile[kGigyaBirthDayKey] integerValue] : 0;
        self.email = profile[kEmailKey];
        self.firstName = profile[kFirstNameKey];
        self.gender = profile[kGenderKey];
        self.zipCode = profile[kGigyaZipCodeKey];
        self.lastName = profile[kLastNameKey];
        self.photoURL = profile[kPhotoUrlKey];
    }
    return self;
}

- (GGPUser *)cloneUser {
    return [[GGPUser alloc] initWithDictionary:[self dictionaryForGigya]];
}

- (void)setGender:(NSString *)gender {
        _gender = (id)gender != [NSNull null] && gender.length ? [self genderForGigya:gender] : nil;
}

- (NSString *)genderForGigya:(NSString *)gender {
    if (gender.length == 1) {
        return gender;
    } else if ([gender isEqualToString:[@"USER_INFO_GENDER_MALE" ggp_toLocalized]]) {
        return kGenderMaleSingleCharacter;
    } else if ([gender isEqualToString:[@"USER_INFO_GENDER_FEMALE" ggp_toLocalized]]){
        return kGenderFemaleSingleCharacter;
    } else {
        return kGenderUnspecifiedSingleCharacter;
    }
}

- (NSString *)genderForDisplay {
    if ([self.gender isEqualToString:kGenderFemaleSingleCharacter]) {
        return [@"USER_INFO_GENDER_FEMALE" ggp_toLocalized];
    } else if ([self.gender isEqualToString:kGenderMaleSingleCharacter]) {
        return [@"USER_INFO_GENDER_MALE" ggp_toLocalized];
    } else {
        return [@"USER_INFO_GENDER_UNSPECIFIED" ggp_toLocalized];
    }
}

- (void)setBirthdate:(NSDate *)birthdate {
    self.birthYear = birthdate ? [birthdate ggp_integerYear] : 0;
    self.birthMonth = birthdate ? [birthdate ggp_integerMonth] : 0;
    self.birthDay = birthdate ? [birthdate ggp_integerDay] : 0;
}

- (NSDate *)birthdate {
    return [NSDate ggp_createDateWithMinutes:0 hour:0 day:self.birthDay month:self.birthMonth year:self.birthYear];
}

- (NSString *)birthDateForDisplay {
    return [self hasBirthComponents] ? [self.birthdate ggp_formatUserBirthday] : @"";
}

- (BOOL)hasBirthComponents {
    return self.birthYear > 0 && self.birthMonth > 0 && self.birthDay > 0;
}

- (NSMutableArray *)createFavoritesFromData:(NSString *)favoritesData {
    if ([self isValidFavoritesData:favoritesData]) {
        NSData *jsonData = [favoritesData dataUsingEncoding:NSUTF8StringEncoding];
        return [[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil] mutableCopy];
    }
    return [NSMutableArray array];
}

- (BOOL)isValidFavoritesData:(NSString *)favoritesData {
    return favoritesData && [favoritesData isKindOfClass:NSString.class];
}

- (NSDictionary *)dictionaryForFavorites {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.favorites options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return @{ kFavoriteTenantsKey : jsonString };
}

- (NSDictionary *)userDataDictionary {
    NSDictionary *data = @{ kOriginMallIdKey: self.originMallId ? self.originMallId : [NSNull null],
                            kOriginMallNameKey: self.originMallName ? self.originMallName : [NSNull null],
                            kEmailSubscribedKey: @(self.isEmailSubscribed),
                            kSMSSubscribedKey: @(self.isSmsSubscribed),
                            kTermsKey: @(self.agreedToTerms),
                            kMobilePhoneKey: self.mobilePhone.length ? self.mobilePhone : [NSNull null],
                            kMallId1Key: [self defaultMallId1],
                            kMallId2Key: self.mallId2.length ? self.mallId2 : @"",
                            kMallId3Key: self.mallId3.length ? self.mallId3 : @"",
                            kMallId4Key: self.mallId4.length ? self.mallId4 : @"",
                            kMallId5Key: self.mallId5.length ? self.mallId5 : @"" };
    
    return @{ kDataKey: data };
}

- (NSString *)defaultMallId1 {
    NSString *mallId1 = self.mallId1.length ? self.mallId1 : @"";
    NSString *originMallId = self.originMallId.length ? self.originMallId : @"";
    return mallId1.length ? mallId1 : originMallId;
}

- (NSDictionary *)userProfileDictionary {
    NSDictionary *profile = @{ kFirstNameKey: self.firstName.length ? self.firstName : [NSNull null],
                               kLastNameKey: self.lastName.length ? self.lastName : [NSNull null],
                               kGenderKey: self.gender.length ? self.gender : [NSNull null],
                               kEmailKey: self.email.length ? self.email : [NSNull null],
                               kGigyaZipCodeKey: self.zipCode.length ? self.zipCode : [NSNull null],
                               kGigyaBirthYearKey: self.birthYear ? @(self.birthYear) : [NSNull null],
                               kGigyaBirthMonthKey: self.birthMonth ? @(self.birthMonth) : [NSNull null],
                               kGigyaBirthDayKey: self.birthDay ? @(self.birthDay) : [NSNull null] };
    
    return @{ kProfileKey: profile };
}

- (NSDictionary *)dictionaryForGigya {
    NSMutableDictionary *gigyaDictionary = [NSMutableDictionary new];
    [gigyaDictionary addEntriesFromDictionary:[self userDataDictionary]];
    [gigyaDictionary addEntriesFromDictionary:[self userProfileDictionary]];
    return gigyaDictionary;
}

- (void)toggleFavorite:(GGPTenant *)tenant {
    [self toggleLocalFavorite:tenant];
    [self sendUpdatedFavorites];
}

- (void)toggleLocalFavorite:(GGPTenant *)tenant {
    if (tenant.isFavorite) {
        [self.favorites removeObject:@(tenant.placeWiseRetailerId)];
    } else {
        [self.favorites addObject:@(tenant.placeWiseRetailerId)];
    }
}

- (void)sendUpdatedFavorites {
    NSDictionary *data = @{ kDataKey : [self dictionaryForFavorites] };
    [GGPAccount updateAccountInfoWithParameters:data andCompletion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:GGPUserFavoritesUpdatedNotification object:nil];
}

- (BOOL)isSocialLogin {
    return ![self.loginProvider isEqualToString:kSiteLoginProvider];
}

- (NSArray *)populatedMallIds {
    NSMutableArray *mallIds = [NSMutableArray new];
    for (int mallId = 1; mallId <= kMaxUserMalls; mallId++) {
        NSString *mallIdString = [NSString stringWithFormat:@"mallId%d", mallId];
        if ([self valueForKey:mallIdString] != nil) {
            [mallIds addObject:[self valueForKey:mallIdString]];
        }
    }
    return mallIds;
}

- (NSArray *)preferredMallsListFromAllMalls:(NSArray *)allMalls {
    NSArray *mallIds = [self populatedMallIds];
    
    return [allMalls ggp_arrayWithFilter:^BOOL(GGPMall *mall) {
        return [mallIds containsObject:[NSString stringWithFormat:@"%ld", (long)mall.mallId]];
    }];
}

@end
