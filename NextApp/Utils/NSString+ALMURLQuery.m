//
//  NSString+ALMURLQuery.m
//  AliMusicWeex
//
//  Created by DjangoZhang on 16/7/6.
//  Copyright © 2016年 Taobao lnc. All rights reserved.
//

#import "NSString+ALMURLQuery.h"

@implementation NSString (ALMURLQuery)

+ (NSString *)makeQueryFromQuery:(NSString *)query
                   withAppending:(NSString *)appending {
    if (query.length == 0) {
        return appending;
    }
    
    return [query stringByAppendingFormat:@"&%@", appending];
}

+ (NSDictionary *)makeQueryAsDictionary:(NSString *)query {
    NSArray *queryArray = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSString *queryItem in queryArray) {
        NSArray *queryItemComponent = [queryItem componentsSeparatedByString:@"="];
        if (queryItemComponent.count == 2) {
            [dictionary setObject:queryItemComponent[1] forKey:queryItemComponent[0]];
        }
    }
    
    return dictionary;
}

- (NSString *)addURLQueryWithQuery:(NSString *)query {
    if (query.length == 0) {
        return self;
    }
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return [[self stringByAppendingString:@"?"] stringByAppendingString:query];
    } else {
        return [[self stringByAppendingString:@"&"] stringByAppendingString:query];
    }
}
@end
