//
//  GGPCrashReporting.m
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/13/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCrashReporting.h"
#import "GGPMallManager.h"

static NSString *const kApplicationToken = @"AAfddee451970262c02384fd6a16ce1745a59d5b24";
static NSString *const kMall = @"mall";
static NSString *const kTenant = @"tenant";

@implementation GGPCrashReporting

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static GGPCrashReporting *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [GGPCrashReporting new];
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(mallChanged) name:GGPMallManagerMallChangedNotification object:nil];
    });
    return instance;
}

- (void)start {
    // Note: New Relic also runs a script to upload dSYM files.
    // This is handled in the Build Phases section of the target(s)
    
    [NewRelicAgent startWithApplicationToken:kApplicationToken];
}

- (void)mallChanged {
    GGPMall *mall = [GGPMallManager shared].selectedMall;
    if (mall) {
        [NewRelic setAttribute:kMall value:mall.name];
    }
}

- (void)trackTenant:(NSString *)tenant {
    [NewRelic setAttribute:kTenant value:tenant];
}

@end
