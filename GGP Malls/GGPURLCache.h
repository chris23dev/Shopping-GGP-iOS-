//
//  GGPURLCache.h
//  GGP Malls
//
//  Created by Chistiaan Kuilman on 1/6/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGPURLCache : NSURLCache

+ (instancetype)shared;
- (void)cacheAppData;

@end
