//
//  NARouter+Load.m
//  Pods
//
//  Created by  on 15/12/29.
//
//

#import "NARouter+Load.h"

@implementation NARouter (Load)
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
                [[NARouter defaultRouter]addPattern:pattern withHandlerClassName:classname selectorName:sel forScheme:scheme];
            }
        }
    }
    
}
@end
