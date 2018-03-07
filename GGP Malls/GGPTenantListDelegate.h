//
//  GGPDirectoryListDelegate.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 12/30/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPTenant.h"

@protocol GGPTenantListDelegate <NSObject>

- (void)selectedTenant:(GGPTenant *)tenant;

@end
