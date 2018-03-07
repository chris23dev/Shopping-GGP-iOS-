//
//  GGPAccount.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 3/24/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPAccount.h"
#import "GGPUser.h"
#import "GGPMall.h"
#import "GGPTenant.h"
#import "GGPSocialInfo.h"
#import <GigyaSDK/Gigya.h>

NSString *const GGPAccountFacebookProvider = @"facebook";
NSString *const GGPAccountGoogleProvider = @"googleplus";
NSString *const GGPAccountRegistrationToken = @"regToken";
NSInteger const GGPAccountInvalidLoginCredentialsErrorCode = 403042;
NSInteger const GGPAccountEmailDoesNotExistErrorCode = 403047;

static NSString *const kSetAccountInfoMethod = @"accounts.setAccountInfo";
static NSString *const kGetAccountInfoMethod = @"accounts.getAccountInfo";
static NSString *const kInitRegistrationMethod = @"accounts.initRegistration";
static NSString *const kRegisterMethod = @"accounts.register";
static NSString *const kFinalizeRegistrationMethod = @"accounts.finalizeRegistration";
static NSString *const kAccountLoginMethod = @"accounts.login";
static NSString *const kAccountResetPasswordMethod = @"accounts.resetPassword";
static NSString *const kAccountIsAvailableLoginIDMethod = @"accounts.isAvailableLoginID";
static NSString *const kAccountGetConflictingAccount = @"accounts.getConflictingAccount";
static NSString *const kUserIdKey = @"UID";
static NSString *const kValidationErrorsKey = @"validationErrors";
static NSString *const kErrorCodeKey = @"errorCode";
static NSString *const kIsAvailableKey = @"isAvailable";
static NSString *const kProfileKey = @"profile";
static NSString *const kDataKey = @"data";
static NSString *const kLoginProviderKey = @"loginProvider";
static NSString *const kLoginIdKey = @"loginID";
static NSString *const kPasswordKey = @"password";
static NSString *const kNewPasswordKey = @"newPassword";
static NSString *const kEmailKey = @"email";
static NSString *const kFinalizeRegistrationKey = @"finalizeRegistration";
static NSString *const kConflictingAccountKey = @"conflictingAccount";
static NSString *const kRemoveLoginEmailsKey = @"removeLoginEmails";
static NSString *const kRegistrationSourceKey = @"regSource";

#ifdef DEBUG
// ios-qa.ggp.com
static NSString *const kGigyaApiKey = @"3_u2NQyqOcsdqZtf-s6ptQr_jZe9UMpIDGEQKNdJ_ZKsF5FvHyWlAX5A1CrCUsZLd2";
#elif QA
// ios-qa.ggp.com
static NSString *const kGigyaApiKey = @"3_u2NQyqOcsdqZtf-s6ptQr_jZe9UMpIDGEQKNdJ_ZKsF5FvHyWlAX5A1CrCUsZLd2";
#elif PROD
// ios.ggp.com
static NSString *const kGigyaApiKey = @"3_ERycFe8WjKxqXZvssaTTDC716babW4YT3CpJfRapUz_PaCy7BlwsH78mnonCyMgj";
#else
static NSString *const kGigyaApiKey = @"";
#endif

@implementation GGPAccount

+ (instancetype)shared {
    static GGPAccount *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [GGPAccount new];
    });
    
    return instance;
}

+ (void)initWithApplication:(UIApplication *)application andLaunchOptions:(NSDictionary *)launchOptions {
    [Gigya initWithAPIKey:kGigyaApiKey application:application launchOptions:launchOptions];
}

+ (void)applicationDidBecomeActive {
    [Gigya handleDidBecomeActive];
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [Gigya handleOpenURL:url application:application sourceApplication:sourceApplication annotation:annotation];
}

+ (void)saveUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kUserIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)retrieveUserId {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserIdKey];
}

+ (void)clearUserId {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isLoggedIn {
    return [[Gigya session] isValid];
}

+ (NSDictionary *)dictionaryForUser:(GGPUser *)user andRegistrationToken:(NSString *)registrationToken {
    NSDictionary *userDictionary = [user dictionaryForGigya];
    return @{ GGPAccountRegistrationToken : registrationToken,
              kProfileKey : userDictionary[kProfileKey],
              kDataKey : userDictionary[kDataKey] };
}

+ (void)logoutWithCompletion:(void(^)(NSError *error))completion {
    [Gigya logoutWithCompletionHandler:^(GSResponse *response, NSError *error) {
        [self clearUserId];
        [GGPAccount shared].currentUser = nil;
        if (completion) {
            completion(error);
        }
    }];
}

+ (void)loginWithProvider:(NSString *)provider withPresenter:(UIViewController *)presenter onCompletion:(GGPAccountProviderLoginCompletion)completion {
    NSDictionary *parameters = @{ kRegistrationSourceKey: @"ios" };
    [Gigya loginToProvider:provider parameters:parameters over:presenter completionHandler:^(GSUser *user, NSError *error) {
        GGPSocialInfo *socialInfo = [[GGPSocialInfo alloc] initWithGigyaUser:user];
        
        if (!error) {
            [self saveUserId:user.UID];
            [GGPAccount fetchUserDataWithCompletion:^{
                if (completion) {
                    completion(socialInfo, nil, nil);
                }
            }];
        } else if (error.code == GSErrorAccountPendingRegistration && [error.userInfo.allKeys containsObject:GGPAccountRegistrationToken]) {
            if (completion) {
                completion(socialInfo, error.userInfo[GGPAccountRegistrationToken], nil);
            }
        } else {
            if (completion) {
                completion(nil, nil, error);
            }
        }
    }];
}

+ (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(GGPAccountRequestCompletion)completion {
    NSDictionary *params = @{ kLoginIdKey : email,
                              kPasswordKey : password };
    
    GSRequest *request = [GSRequest requestForMethod:kAccountLoginMethod parameters:params];
    
    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) { 
        if (!error) {
            [self saveUserId:[response objectForKey:kUserIdKey]];
            [GGPAccount fetchUserDataWithCompletion:^{
                if (completion) {
                    completion(nil);
                }
            }];
        } else {
            if (completion) {
                completion(error);
            }
        }
    }];
}

+ (void)registerUser:(GGPUser *)user withPassword:(NSString *)password andCompletion:(GGPAccountRequestCompletion)onCompletion {
    GSRequest *request = [GSRequest requestForMethod:kInitRegistrationMethod];
    
    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
        if (!error) {
            NSString *regToken = [response objectForKey:GGPAccountRegistrationToken];
            [GGPAccount completeEmailRegistrationForUser:user withPassword:password registrationToken:regToken andCompletion:onCompletion];
        } else {
            if (onCompletion) {
                onCompletion(error);
            }
        }
    }];
}

+ (void)completeEmailRegistrationForUser:(GGPUser *)user withPassword:(NSString *)password registrationToken:(NSString *)regToken andCompletion:(GGPAccountRequestCompletion)onCompletion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[GGPAccount dictionaryForUser:user andRegistrationToken:regToken]];
    [params addEntriesFromDictionary:@{ kEmailKey: user.email,
                                        kPasswordKey: password,
                                        kFinalizeRegistrationKey: @(YES),
                                        kRegistrationSourceKey: @"ios" }];
    
    GSRequest *request = [GSRequest requestForMethod:kRegisterMethod parameters:params];
    
    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
        if (!error) {
            [self saveUserId:response[kUserIdKey]];
            [GGPAccount fetchUserDataWithCompletion:^{
                if (onCompletion) {
                    onCompletion(error);
                }
            }];
        } else {
            if (onCompletion) {
                onCompletion(error);
            }
        }
    }];
}

+ (void)updateAccountInfoWithParameters:(NSDictionary *)parameters andCompletion:(GGPAccountRequestCompletion)onCompletion {
    [GGPAccount updateAccountInfoWithParameters:parameters shouldRemoveLoginId:YES andCompletion:onCompletion];
}

+ (void)updateAccountInfoWithParameters:(NSDictionary *)parameters shouldRemoveLoginId:(BOOL)shouldRemoveLoginId andCompletion:(GGPAccountRequestCompletion)onCompletion {
    NSString *emailParam = parameters[kProfileKey][kEmailKey];
    if (shouldRemoveLoginId && emailParam && ![emailParam isEqualToString:[GGPAccount shared].currentUser.email]) {
        parameters = [self addRemoveLoginKeyToParameters:parameters];
    }
    
    GSRequest *request = [GSRequest requestForMethod:kSetAccountInfoMethod parameters:parameters];

    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
        if (!error) {
            [GGPAccount fetchUserDataWithCompletion:^{
                if (onCompletion) {
                    onCompletion(nil);
                }
            }];
        } else {
            GGPLogError(@"Error updating account info: %@", error.localizedDescription);
            if (onCompletion) {
                onCompletion(error);
            }
        }
    }];
}

+ (NSDictionary *)addRemoveLoginKeyToParameters:(NSDictionary *)parameters {
    NSMutableDictionary *updatedParams = [parameters mutableCopy];
    [updatedParams setValue:[GGPAccount shared].currentUser.email forKey:kRemoveLoginEmailsKey];
    return updatedParams;
}

+ (void)finalizeRegistrationWithRegistrationToken:(NSString *)registrationToken andCompletion:(GGPAccountRequestCompletion)onCompletion {
    NSDictionary *parameters = @{ GGPAccountRegistrationToken: registrationToken,
                                  kRegistrationSourceKey: @"ios" };
    GSRequest *request = [GSRequest requestForMethod:kFinalizeRegistrationMethod parameters:parameters];
    
    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
        if (!error) {
            [self saveUserId:[response objectForKey:kUserIdKey]];
            [GGPAccount fetchUserDataWithCompletion:^{
                if (onCompletion) {
                    onCompletion(error);
                }
            }];
        } else {
            GGPLogError(@"Error finalizing registration: %@", error.localizedDescription);
            if (onCompletion) {
                onCompletion(error);
            }
        }
    }];
}

+ (void)fetchUserDataWithCompletion:(void(^)())onCompletion {
    GSRequest *request = [GSRequest requestForMethod:kGetAccountInfoMethod];
    
    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *userData = @{ kDataKey: response[kDataKey],
                                        kProfileKey: response[kProfileKey],
                                        kLoginProviderKey: response[kLoginProviderKey] };
            
            GGPUser *user = [[GGPUser alloc] initWithDictionary:userData];
            [GGPAccount shared].currentUser = user;
        } else {
            GGPLogError(@"Error fetching user data: %@", error.localizedDescription);
        }
        
        if (onCompletion) {
            onCompletion();
        }
    }];
}

+ (void)resetPasswordForEmail:(NSString *)email withCompletion:(GGPAccountRequestCompletion)completion {
    NSDictionary *params = @{ kLoginIdKey : email };
    GSRequest *request = [GSRequest requestForMethod:kAccountResetPasswordMethod parameters:params];

    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

+ (void)checkEmailAvailability:(NSString *)email withCompletion:(GGPAccountEmailAvailableCompletion)completion {
    NSDictionary *params = @{ kLoginIdKey : email };
    GSRequest *request = [GSRequest requestForMethod:kAccountIsAvailableLoginIDMethod parameters:params];
    
    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
        if (completion) {
            completion(error, [response[kIsAvailableKey] boolValue]);
        }
    }];
}

+ (void)checkEmailAvailabilityForProvider:(NSString *)provider andRegistrationToken:(NSString *)regToken withCompletion:(GGPAccountEmailAvailableCompletion)completion {
    NSDictionary *params = @{ GGPAccountRegistrationToken : regToken };
    GSRequest *request = [GSRequest requestForMethod:kAccountGetConflictingAccount parameters:params];
    
    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
        if (completion) {
            completion(error, !response[kConflictingAccountKey]);
        }
    }];
}

+ (void)updateCurrentPassword:(NSString *)currentPassword toPassword:(NSString *)updatedPassword withCompletion:(GGPAccountRequestCompletion)completion {
    NSDictionary *params = @{ kPasswordKey : currentPassword,
                              kNewPasswordKey : updatedPassword };
    GSRequest *request = [GSRequest requestForMethod:kSetAccountInfoMethod parameters:params];
    
    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

@end
