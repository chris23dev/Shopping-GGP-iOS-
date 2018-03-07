//
//  GGPAddress.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/9/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface GGPAddress : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic, readonly) NSString *line1;
@property (strong, nonatomic, readonly) NSString *line2;
@property (strong, nonatomic, readonly) NSString *line3;
@property (strong, nonatomic, readonly) NSString *city;
@property (strong, nonatomic, readonly) NSString *state;
@property (strong, nonatomic, readonly) NSString *zip;

- (NSString *)fullAddress;

@end
