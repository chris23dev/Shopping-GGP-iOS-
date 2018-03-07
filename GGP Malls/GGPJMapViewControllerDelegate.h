//
//  GGPJMapViewControllerDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 2/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GGPTenant;

@protocol GGPJMapViewControllerDelegate <NSObject>

- (GGPTenant *)tenantFromLeaseId:(NSString *)leaseId;

@end
