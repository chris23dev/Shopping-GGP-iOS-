//
//  GGPEmailVerificationClient.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/30/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPEmailVerificationClient.h"
#import <Overcoat/Overcoat.h>

static NSString *const kBriteVerifyApiKey = @"80b2f35b-d37d-4e72-8e35-8d51b266923d";
static NSString *const kBaseURL = @"https://bpi.briteverify.com/";
static NSString *const kVerifyURL = @"emails.json";
static NSString *const kAddressParam = @"address";
static NSString *const kApiKeyParam = @"apikey";
static NSString *const kStatusKey = @"status";
static NSString *const kInvalidStatus = @"invalid";

@implementation GGPEmailVerificationClient

+ (instancetype)shared {
    static GGPEmailVerificationClient *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[GGPEmailVerificationClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    
    return instance;
}

- (void)verifyEmail:(NSString *)email withCompletion:(void(^)(BOOL isValidEmail))onCompletion {
    NSDictionary *params = @{ kAddressParam: email,
                              kApiKeyParam: kBriteVerifyApiKey };
    
    [self GET:kVerifyURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        BOOL isValid = YES;
        if ([responseObject isKindOfClass:NSDictionary.class]) {
            NSString *status = responseObject[kStatusKey];
            isValid = ![status isEqualToString:kInvalidStatus];
        }
        if (onCompletion) {
            onCompletion(isValid);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (onCompletion) {
            onCompletion(YES);
        }
    }];
}

@end
