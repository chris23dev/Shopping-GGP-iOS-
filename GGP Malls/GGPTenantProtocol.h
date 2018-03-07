//
//  GGPTenantProtocol.h
//  GGP Malls
//
//  Created by Janet Lin on 12/23/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPBrand.h"

@protocol GGPTenantProtocol <NSObject>

@property (assign, nonatomic, readonly) NSInteger tenantId;
@property (assign, nonatomic, readonly) NSInteger mallId;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *phoneNumber;
@property (strong, nonatomic, readonly) NSString *websiteUrl;
@property (strong, nonatomic, readonly) NSString *tenantDescription;
@property (strong, nonatomic, readonly) NSString *tenantLogoUrl;

@end
