//
//  GGPAccount.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 3/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const GGPAccountFacebookProvider;
extern NSString *const GGPAccountGoogleProvider;
extern NSString *const GGPAccountRegistrationToken;
extern NSInteger const GGPAccountInvalidLoginCredentialsErrorCode;
extern NSInteger const GGPAccountEmailDoesNotExistErrorCode;

@class GGPUser;
@class GGPTenant;
@class GGPSocialInfo;

typedef void (^GGPAccountProviderLoginCompletion) (GGPSocialInfo *socialInfo, NSString *registrationToken, NSError *error);
typedef void (^GGPAccountRequestCompletion) (NSError *error);
typedef void (^GGPAccountEmailAvailableCompletion) (NSError *error, BOOL emailAvailable);

@interface GGPAccount : NSObject

@property (strong, nonatomic) GGPUser *currentUser;

+ (instancetype)shared;

+ (void)initWithApplication:(UIApplication *)application andLaunchOptions:(NSDictionary *)launchOptions;
+ (void)applicationDidBecomeActive;
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

+ (BOOL)isLoggedIn;
+ (void)saveUserId:(NSString *)userId;
+ (NSString *)retrieveUserId;

+ (NSDictionary *)dictionaryForUser:(GGPUser *)user andRegistrationToken:(NSString *)registrationToken;

+ (void)loginWithProvider:(NSString *)provider withPresenter:(UIViewController *)presenter onCompletion:(GGPAccountProviderLoginCompletion)completion;
+ (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(GGPAccountRequestCompletion)completion;
+ (void)logoutWithCompletion:(void(^)(NSError *error))completion;

+ (void)registerUser:(GGPUser *)user withPassword:(NSString *)password andCompletion:(GGPAccountRequestCompletion)onCompletion;
+ (void)finalizeRegistrationWithRegistrationToken:(NSString *)registrationToken andCompletion:(GGPAccountRequestCompletion)onCompletion;

+ (void)fetchUserDataWithCompletion:(void(^)())onCompletion;
+ (void)updateAccountInfoWithParameters:(NSDictionary *)parameters andCompletion:(GGPAccountRequestCompletion)onCompletion;
+ (void)updateAccountInfoWithParameters:(NSDictionary *)parameters shouldRemoveLoginId:(BOOL)shouldRemoveLoginId andCompletion:(GGPAccountRequestCompletion)onCompletion;
+ (void)updateCurrentPassword:(NSString *)currentPassword toPassword:(NSString *)updatedPassword withCompletion:(GGPAccountRequestCompletion)completion;
+ (void)resetPasswordForEmail:(NSString *)email withCompletion:(GGPAccountRequestCompletion)completion;

+ (void)checkEmailAvailability:(NSString *)email withCompletion:(GGPAccountEmailAvailableCompletion)completion;
+ (void)checkEmailAvailabilityForProvider:(NSString *)provider andRegistrationToken:(NSString *)regToken withCompletion:(GGPAccountEmailAvailableCompletion)completion;

@end
