//
//  NSString+UrlEncode.h
//
//  Created by Kevin Renskers on 31-10-13.
//  Copyright (c) 2013 Kevin Renskers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UrlEncode)

- (NSString *)filePathEncode;

- (NSString *)urlEncode;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)urlDecode;
- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)unescapeHTML;

- (NSString *)trim;

@end
