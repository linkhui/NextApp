//
//  NSString+UrlEncode.m
//
//  Created by Kevin Renskers on 31-10-13.
//  Copyright (c) 2013 Kevin Renskers. All rights reserved.
//

#import "NSString+UrlEncode.h"

@implementation NSString (UrlEncode)

- (NSString *)filePathEncode {
    return [self stringByReplacingOccurrencesOfString:@"/"
                                           withString:@"."
                                              options:NSLiteralSearch
                                                range:NSMakeRange(0, [self length])];
}

- (NSString *)urlEncode {
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
        NULL, (__bridge CFStringRef)self, NULL, (CFStringRef) @"!*'\"();:@&=+$,/?%#[]% ",
        CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)urlDecode {
    return [self urlDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
        NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)unescapeHTML {
    static struct {
        char *escapeSequence;
        unichar uchar;
    } gAsciiHTMLEscapeMap[] = {{"&gt;", 62},   {"&quot;", 34}, {"&apos;", 39},    {"&#39;", 39},
                               {"&#039;", 39}, {"&amp;", 38},  {"&hellip;", 8230}};
    //    static HTMLEscapeMap gUnicodeHTMLEscapeMap[] = {};

    NSRange range = NSMakeRange(0, [self length]);
    NSRange subrange = [self rangeOfString:@"&" options:NSBackwardsSearch range:range];

    // if no ampersands, we've got a quick way out
    if (subrange.length == 0)
        return self;
    NSMutableString *finalString = [NSMutableString stringWithString:self];
    do {
        NSRange semiColonRange = NSMakeRange(subrange.location, NSMaxRange(range) - subrange.location);
        semiColonRange = [self rangeOfString:@";" options:0 range:semiColonRange];
        range = NSMakeRange(0, subrange.location);
        // if we don't find a semicolon in the range, we don't have a sequence
        if (semiColonRange.location == NSNotFound) {
            continue;
        }
        NSRange escapeRange = NSMakeRange(subrange.location, semiColonRange.location - subrange.location + 1);
        NSString *escapeString = [self substringWithRange:escapeRange];
        NSUInteger length = [escapeString length];
        // a squence must be longer than 3 (&lt;) and less than 11 (&thetasym;)
        if (length > 3 && length < 11) {
            if ([escapeString characterAtIndex:1] == '#') {
                unichar char2 = [escapeString characterAtIndex:2];
                if (char2 == 'x' || char2 == 'X') {
                    // Hex escape squences &#xa3;
                    NSString *hexSequence = [escapeString substringWithRange:NSMakeRange(3, length - 4)];
                    NSScanner *scanner = [NSScanner scannerWithString:hexSequence];
                    unsigned value;
                    if ([scanner scanHexInt:&value] && value < USHRT_MAX && value > 0 &&
                        [scanner scanLocation] == length - 4) {
                        unichar uchar = value;
                        NSString *charString = [NSString stringWithCharacters:&uchar length:1];
                        [finalString replaceCharactersInRange:escapeRange withString:charString];
                    }

                } else {
                    // Decimal Sequences &#123;
                    NSString *numberSequence = [escapeString substringWithRange:NSMakeRange(2, length - 3)];
                    NSScanner *scanner = [NSScanner scannerWithString:numberSequence];
                    int value;
                    if ([scanner scanInt:&value] && value < USHRT_MAX && value > 0 &&
                        [scanner scanLocation] == length - 3) {
                        unichar uchar = value;
                        NSString *charString = [NSString stringWithCharacters:&uchar length:1];
                        [finalString replaceCharactersInRange:escapeRange withString:charString];
                    }
                }
            } else {
                // "standard" sequences
                for (unsigned i = 0; i < sizeof(gAsciiHTMLEscapeMap) / sizeof(gAsciiHTMLEscapeMap[0]); ++i) {
                    if ([escapeString
                            isEqualToString:[NSString stringWithUTF8String:gAsciiHTMLEscapeMap[i].escapeSequence]]) {
                        [finalString
                            replaceCharactersInRange:escapeRange
                                          withString:[NSString stringWithCharacters:&gAsciiHTMLEscapeMap[i].uchar
                                                                             length:1]];
                        break;
                    }
                }
            }
        }
    } while ((subrange = [self rangeOfString:@"&" options:NSBackwardsSearch range:range]).length != 0);
    return finalString;
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
