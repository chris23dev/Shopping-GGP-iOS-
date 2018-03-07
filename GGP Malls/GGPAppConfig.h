//
//  GGPAppConfig.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/9/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLJSONAdapter.h>
#import <Mantle/MTLModel.h>

@interface GGPAppConfig : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic, readonly) NSString *minIosVersion;
@property (assign, nonatomic, readonly) NSInteger iosFeedbackActionCount;

@end
