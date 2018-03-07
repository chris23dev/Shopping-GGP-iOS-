//
//  NSURL+GGPAdditions.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 9/14/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (GGPAdditions)

+ (NSURL *)ggp_urlWithString:(NSString *)string andParameters:(NSDictionary *)parameters;

@end
