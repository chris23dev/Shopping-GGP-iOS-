//
//  GGPEmailVerificationClient.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/30/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface GGPEmailVerificationClient : AFHTTPSessionManager

+ (instancetype)shared;

- (void)verifyEmail:(NSString *)email withCompletion:(void(^)(BOOL isValidEmail))onCompletion;

@end
