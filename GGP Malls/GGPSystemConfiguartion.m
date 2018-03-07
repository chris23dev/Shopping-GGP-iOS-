//
//  GGPSystemConfiguartion.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/15/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#include <ifaddrs.h>
#include <arpa/inet.h>

#import "GGPSystemConfiguartion.h"

static NSString *const kiOSWifi = @"en0";
static NSString *const kiOSCellular = @"pdp_ip0";

@implementation GGPSystemConfiguartion

+ (NSString *)ipAddress {
    NSString *address = @"0.0.0.0";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    if (getifaddrs(&interfaces) == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
            if(temp_addr->ifa_addr->sa_family == AF_INET && ([name isEqualToString:kiOSWifi] || [name isEqualToString:kiOSCellular])) {
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    return address;
}

@end
