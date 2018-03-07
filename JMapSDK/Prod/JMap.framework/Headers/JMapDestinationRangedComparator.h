//
//  JMapDestinationRangedComparator.h
//  JMap
//
//  Created by Bryan Hayes on 2015-10-16.
//  Copyright © 2015 jibestream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMapDestinationRangedMeasurment;

@interface JMapDestinationRangedComparator : JMapDestinationRangedMeasurment

-(int)compare:(JMapDestinationRangedMeasurment *)o1 to:(JMapDestinationRangedMeasurment *)o2;

@end
