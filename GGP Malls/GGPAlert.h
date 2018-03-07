//
//  GGPAlert.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 1/26/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface GGPAlert : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic, readonly) NSInteger alertId;
@property (strong, nonatomic, readonly) NSDate *effectiveStartDateTime;
@property (strong, nonatomic, readonly) NSDate *effectiveEndDateTime;
@property (strong, nonatomic, readonly) NSString *message;

- (BOOL)isValidStartDate;

@end
