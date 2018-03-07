//
//  JMapsYouAreHere.h
//  JMapSDK
//
//  Created by developer on 2015-04-27.
//  Copyright (c) 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMapFloor;

/**
 * Welcome to the JMapsYouAreHere object
 * currentFloor, position & orientation objects determine the path routing starting source for path finding.
 */
@interface JMapsYouAreHere : NSObject 
/**
 * Current floor
 * The current where the user is standing or wish to commence routing from.
 */
@property (nonatomic, strong) JMapFloor *currentFloor;
/**
 * The x,y position in screen coordinates of where user is standing in relation to the map.
 */
@property (nonatomic, strong) NSValue  *position;
/**
 * The heading in which the user is standing
 */
@property (nonatomic, strong) NSNumber *orientation;

@end
