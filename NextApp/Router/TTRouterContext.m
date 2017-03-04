//
//  TTRouterContext.m
//  Pods
//
//  Created by Li Jianfeng on 15/12/2.
//
//

#import "TTRouterContext.h"

@implementation TTRouterContext
+(TTRouterContext *)contextWithUrl:(NSURL *)url matchPaths:(NSArray *)matchPaths queryParam:(NSDictionary *)queryParams{
    TTRouterContext *c = [TTRouterContext new];
    c.url= url;
    c.matchPaths = matchPaths;
    c.queryParams = queryParams;
    return c;
}
@end
