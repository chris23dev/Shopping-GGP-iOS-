//
//  GGPTenantDetailCardDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/4/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GGPTenant;

@protocol GGPTenantDetailCardDelegate <NSObject>

- (void)tenantCardWasDismissed;

@end
