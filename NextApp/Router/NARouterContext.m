//
//  NARouterContext.m
//  Pods
//
//  Created by  on 15/12/2.
//
//

#import "NARouterContext.h"

@implementation NARouterContext
+(NARouterContext *)contextWithUrl:(NSURL *)url matchPaths:(NSArray *)matchPaths queryParam:(NSDictionary *)queryParams{
    NARouterContext *c = [NARouterContext new];
    c.url= url;
    c.matchPaths = matchPaths;
    c.queryParams = queryParams;
    return c;
}
@end
