//
//  GGPMallResponse.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/9/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface GGPMallResponse : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSArray *malls;

@end
