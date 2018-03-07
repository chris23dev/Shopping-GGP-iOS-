//
//  NSProcessInfo+GGPAdditions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/10/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSProcessInfo (GGPAdditions)

+ (BOOL)ggp_isRunningUnitTests;

@end
