//
//  GGPSocialInfo.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPSocialInfo.h"
#import <GigyaSDK/Gigya.h>

@implementation GGPSocialInfo

- (instancetype)initWithGigyaUser:(GSUser *)user {
    self = [super init];
    if (self) {
        self.email = user.email;
        self.firstName = user.firstName;
        self.lastName = user.lastName;
    }
    return self;
}

@end
