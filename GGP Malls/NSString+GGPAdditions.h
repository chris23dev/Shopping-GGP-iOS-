//
//  NSString+GGPAdditions.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/16/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (GGPAdditions)

- (NSString *)ggp_toLocalized;
+ (NSString *)ggp_prettyPrintPhoneNumber:(NSString *)phoneNumber;
- (NSString *)ggp_removeTrailingNewLine;
- (NSString *)ggp_md5Hash;

@end
