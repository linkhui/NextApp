//
//  TTRouter+Load.m
//  Pods
//
//  Created by Li Jianfeng on 15/12/29.
//
//

#import "TTRouter+Load.h"

@implementation TTRouter (Load)
+ (void)loadAllScheme{
    NSArray * array = [[NSBundle mainBundle]pathsForResourcesOfType:@"plist" inDirectory:@"."];
    NSMutableArray *schemes = [NSMutableArray arrayWithCapacity:5];
    for (NSString *path  in array) {
        if ([path hasSuffix:@"scheme_url.plist"]) {
            [schemes addObject:path];
        }
    }
    for (NSString *path  in schemes) {
        [self loadSchemeForDic:  [NSDictionary dictionaryWithContentsOfFile: path]];
    }
    return;
}
+(void)loadSchemeForDic:(NSDictionary *)dic{
    for (NSString* scheme in dic) {
        NSArray* array = [dic objectForKey:scheme];
        for (NSDictionary* dic in array) {
            NSAssert(dic, @"dic is null");
            NSAssert([dic isKindOfClass:[NSDictionary class]], @"dic not NSDictionary");
            if (!dic || ![dic isKindOfClass:[NSDictionary class]] ) {
                continue;
            }
            NSString* pattern = dic[@"pattern"];
            NSString* classname = dic[@"class"];
            NSString* sel = dic[@"selector"];
            if (pattern && classname && sel ) {
                [[TTRouter defaultRouter]addPattern:pattern withHandlerClassName:classname selectorName:sel forScheme:scheme];
            }
        }
    }
    
}
@end
