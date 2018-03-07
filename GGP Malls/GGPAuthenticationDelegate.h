//
//  GGPAuthenticationDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 4/22/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GGPAuthenticationDelegate <NSObject>

@optional

- (void)authenticationCompleted;
- (void)authenticationCanceled;

@end
