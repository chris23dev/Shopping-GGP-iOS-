//
//  GGPUser.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 3/30/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGPTenant;

@interface GGPUser : NSObject

// Data properties
@property (strong, nonatomic) NSDate *birthdate;
@property (assign, nonatomic) NSInteger birthYear;
@property (assign, nonatomic) NSInteger birthMonth;
@property (assign, nonatomic) NSInteger birthDay;
@property (strong, nonatomic) NSString *mallId1;
@property (strong, nonatomic) NSString *mallId2;
@property (strong, nonatomic) NSString *mallId3;
@property (strong, nonatomic) NSString *mallId4;
@property (strong, nonatomic) NSString *mallId5;

// Profile properties
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *mobilePhone;
@property (strong, nonatomic) NSString *originMallId;
@property (strong, nonatomic) NSString *originMallName;
@property (strong, nonatomic) NSString *photoURL;
@property (strong, nonatomic) NSString *loginProvider;
@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) NSMutableArray *favorites;

// Calculated properties
@property (assign, nonatomic) BOOL isEmailSubscribed;
@property (assign, nonatomic) BOOL isSmsSubscribed;
@property (assign, nonatomic) BOOL agreedToTerms;
@property (assign, nonatomic, readonly) BOOL isSocialLogin;
@property (strong, nonatomic, readonly) NSString *genderForDisplay;
@property (strong, nonatomic, readonly) NSString *birthDateForDisplay;
- (NSArray *)preferredMallsListFromAllMalls:(NSArray *)allMalls;

- (instancetype)initWithDictionary:(NSDictionary *)userData;
- (GGPUser *)cloneUser;
- (NSDictionary *)dictionaryForFavorites;
- (NSDictionary *)dictionaryForGigya;
- (NSDictionary *)userProfileDictionary;
- (NSDictionary *)userDataDictionary;
- (void)toggleFavorite:(GGPTenant *)tenant;
- (void)toggleLocalFavorite:(GGPTenant *)tenant;
- (void)sendUpdatedFavorites;

@end
