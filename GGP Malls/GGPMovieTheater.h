//
//  GGPMovieTheater.h
//  GGP Malls
//
//  Created by Janet Lin on 12/11/15.
//  Copyright (c) 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPTenant.h"

@interface GGPMovieTheater : GGPTenant

@property (assign, nonatomic, readonly) NSInteger theatreId;
@property (strong, nonatomic, readonly) NSArray *movies;
@property (strong, nonatomic, readonly) NSString *tmsId;

@end
