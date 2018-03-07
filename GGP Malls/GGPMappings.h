//
//  GGPMappings.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface GGPMappings : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic, readonly) NSInteger mallId;
@property (strong, nonatomic, readonly) NSArray *tenantIds;

@end
