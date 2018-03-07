//
//  GGPEventLinks.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 2/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface GGPExternalEventLink : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic, readonly) NSURL *url;
@property (strong, nonatomic, readonly) NSString *displayText;

@end
