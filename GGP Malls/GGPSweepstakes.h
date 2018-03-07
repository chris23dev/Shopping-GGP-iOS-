//
//  GGPSweepstakes.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 9/12/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GGPSweepstakes : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *sweepstakesDescription;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@property (assign, nonatomic) BOOL isValid;
@property (strong, nonatomic) UIImage *image;

@end
