//
//  JMapSelectedLocation.h
//  JMapSDK
//
//  Created by Sean Batson on 2015-06-26.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * JMap JMapLocations Model data model
 */
@interface JMapSelectedLocation : NSObject

@property (retain, nonatomic) NSNumber *projectId;
@property (retain, nonatomic) NSString *locationName;
@property (retain, nonatomic) NSString *clientProjectId;

@end