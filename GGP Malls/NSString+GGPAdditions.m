//
//  NSString+GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/16/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "NSString+GGPAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (GGPAdditions)

- (NSString *)ggp_toLocalized {
    return [[NSBundle mainBundle] localizedStringForKey:(self) value:@"" table:nil];
}

+ (NSString *)ggp_prettyPrintPhoneNumber:(NSString *)phoneNumber {
    if (!phoneNumber || phoneNumber.length !=10) {
        return nil;
    }
    
    NSMutableString *contact = [NSMutableString stringWithString:phoneNumber];
    [contact insertString:@"-" atIndex:6];
    [contact insertString:@"-" atIndex:3];
    [contact insertString:@"+1-" atIndex:0];
    return contact;
}

- (NSString *)ggp_removeTrailingNewLine {
    NSRange lastNewLine = [self rangeOfString:@"\n" options:NSBackwardsSearch];
    return lastNewLine.length ? [self stringByReplacingCharactersInRange:lastNewLine withString:@""] : self;
}

- (NSString *)ggp_md5Hash {
    const char *pointer = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
    
    NSMutableString *string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [string appendFormat:@"%02x",md5Buffer[i]];
    }
    
    return string;
}

@end
