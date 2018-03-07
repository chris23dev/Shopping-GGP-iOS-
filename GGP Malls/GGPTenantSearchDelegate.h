//
//  GGPTenantSearchDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/11/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGPTenant;

@protocol GGPTenantSearchDelegate <NSObject>

- (void)didSelectTenant:(GGPTenant *)tenant;

@end
