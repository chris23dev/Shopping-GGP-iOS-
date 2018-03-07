//
//  GGPMallManager.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 7/27/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPMall.h"
#import <Foundation/Foundation.h>

@interface GGPMallManager : NSObject

+ (instancetype)shared;

@property (strong, nonatomic) GGPMall *selectedMall;
@property (strong, nonatomic) NSArray *recentMalls;

@end
