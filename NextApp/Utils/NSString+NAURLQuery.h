//
//  NSString+ALMURLQuery.h
//  AliMusicWeex
//
//  Created by  on 16/7/6.
//  Copyright © 2016年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NAURLQuery)

+ (NSString *)makeQueryFromQuery:(NSString *)query
                   withAppending:(NSString *)appending;

+ (NSDictionary *)makeQueryAsDictionary:(NSString *)query;

/**
 给URL字符串增加query字段，没有？则用？链接，有？则用&连接
 */
- (NSString *)addURLQueryWithQuery:(NSString *)query;

@end
