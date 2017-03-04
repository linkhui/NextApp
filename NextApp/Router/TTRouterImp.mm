//
//  TTRouterImp.m
//  Pods
//
//  Created by Li Jianfeng on 15/11/30.
//
//

#import "TTRouterImp.h"
#import <objc/message.h>
#import <UIKit/UIKit.h>
#import "ALMUtility.h"
#import "NSString+ALMURLQuery.h"
#import "NSString+UrlEncode.h"

static NSMutableDictionary* splitQuery(NSString* query, NSStringEncoding encoding = NSUTF8StringEncoding) {
    if(!query||[query length]==0) return nil;
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count >= 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSMutableString* value = [[NSMutableString alloc] init];
            for (NSUInteger i = 1; i<kvPair.count; ++i) {
                NSString* s = [[kvPair objectAtIndex:i] stringByReplacingPercentEscapesUsingEncoding:encoding];
                if (s) [value appendString:s];
                if (i != kvPair.count -1) {
                    [value appendString:@"="];
                }
            }
            [pairs setObject:value forKey:key];
        }
    }
    return pairs;
}
@interface TTRouterImp ()
@property (nonatomic,strong)NSMutableDictionary * handlerFactoryDic;
@property (nonatomic,strong)NSMutableDictionary *patternHandlerClassDic;
@property (nonatomic,strong)NSMutableDictionary *patternBlockDic;
@end

@implementation TTRouterImp
+(instancetype)instance {
    static TTRouterImp* __instance = nil;
    if (!__instance) {
        __instance = [[TTRouterImp alloc] init];
    }
    return __instance;
}
- (instancetype)init{
    if (self = [super init]) {
        self. handlerFactoryDic = [NSMutableDictionary dictionaryWithCapacity:5];
        self.patternHandlerClassDic = [NSMutableDictionary dictionaryWithCapacity:5];
        self.patternBlockDic = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    return self;
}
-(void)dealloc {
    
}

-(instancetype)newSubRouter:(NSString*)pattern {
    if ([pattern isEqualToString:@".*"] || [pattern isEqualToString:@"(.*)"]) {
        return [TTRouterImp instance];
    }
    TTRouterImp* r = [TTRouterImp new];
    
    [self addRoute:[NSString stringWithFormat:@"%@(.*)", pattern] block:^id(TTRouterContext *ctx) {
        ctx.handled = NO;
        BOOL a = ctx.handled;
      return   [r _routURL:ctx.url urlPath:ctx.matchPaths[0] outparams:ctx.queryParams handler: &a];
    }];
    return r;
}

-(void)delSubRouter:(NSString*)pattern {
    [self.patternBlockDic removeObjectForKey:pattern];
}

- (NSMutableString *)urlPathWithSchemeURL:(NSURL *)url {
    
    NSMutableString* urlpath = [NSMutableString stringWithCapacity:url.absoluteString.length];
    {
        NSString* scheme = url.scheme;
        NSString* host = url.host;
        NSString* path = url.path;
        NSString* fragment = url.fragment;
        
        
        if (scheme) [urlpath appendFormat:@"%@://", scheme];
        if ([scheme isEqualToString:@"http"] ||
            [scheme isEqualToString:@"https"]) {
            if (!path || !path.length) path = @"/";
            if (host) [urlpath appendString:host];
            if (path) [urlpath appendString:path];
        } else {
            [urlpath appendString:@"/"];
            if (host) [urlpath appendString:host];
            if (path) [urlpath appendString:path];
        }
        
        if (fragment) {
            [urlpath appendFormat:@"#%@",fragment];
        }
    }
    
    return urlpath;
}

-(TTRouterResult *)route:(NSString*)urlString {
    return [self route:urlString parameters:nil];
}
-(TTRouterResult *)route:(NSString *)urlString parameters:(NSDictionary*)parameters {
    NSRange queryRange = [urlString rangeOfString:@"?"];
    NSMutableDictionary *decodedParamters = [NSMutableDictionary dictionary];
    if (parameters != nil) {
        [decodedParamters addEntriesFromDictionary:parameters];
    }
    if (queryRange.location != NSNotFound) {
        NSString *query = [urlString substringFromIndex:queryRange.length + queryRange.location];
        NSDictionary *queryInfo = [NSString makeQueryAsDictionary:query];
        NSMutableDictionary *decodedQueryInfo = [NSMutableDictionary dictionary];
        for (NSString *key in queryInfo.allKeys) {
            [decodedQueryInfo setObject:[queryInfo[key] urlDecode] forKey:key];
        }
        
        [decodedParamters addEntriesFromDictionary:decodedQueryInfo];
    }
    
    urlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (urlString) {
        NSString* fragment = nil;
        NSRange rng = [urlString rangeOfString:@"#" options:NSBackwardsSearch];
        if (rng.location != NSNotFound) {
            fragment = [urlString substringFromIndex:rng.location];
            for (NSUInteger i = 0; i<fragment.length; ++i) {
                switch ([fragment characterAtIndex:i]) {
                    case '/':
                    case '=':
                    case '?':
                        fragment = nil;
                        break;
                }
                if (!fragment) {
                    break;
                }
            }
            if (fragment) {
                urlString = [urlString substringToIndex:rng.location];
            }
        }
        urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//支持网络过来的URL 字符串
        
        // 处理url中#。 ? 前的 # 不转义； ? 后的 # 转义
        NSString *paramString = @"";
        NSRange range = [urlString rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            paramString = [urlString substringFromIndex:range.location];
            urlString = [urlString substringToIndex:range.location];
            if (paramString && paramString.length > 0) {
                paramString = [paramString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
        }
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`%^{}\"[]|\\<> "].invertedSet];
        urlString = [urlString stringByAppendingString:paramString];
        
        urlString = fragment ? [urlString stringByAppendingString:fragment] : urlString;
        
        //add by pengyutang [urlString trim]， 为了解决xiami://open?url=http://api.xiami.com/api/third/lotto/type/10%23login%20
        //无法创建[NSURL URLWithString]的问题
        return [self routeURL:[NSURL URLWithString:[urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] parameters:decodedParamters];
    }
    NSAssert(FALSE, @"url is null");
    return nil;
}
-(TTRouterResult *)routeURL:(NSURL*)url {
    return [self routeURL:url parameters:nil];
}
-(TTRouterResult *)routeURL:(NSURL*)url parameters:(NSDictionary*)parameters {
    return [self routeURL:url parameters:parameters asyn:FALSE];
}
-(TTRouterResult *)routeURL:(NSURL *)url parameters:(NSDictionary *)parameters asyn:(BOOL)basyn {
    if ([TTRouterImp instance] != self) {
        return [[TTRouterImp instance] routeURL:url parameters:parameters asyn:basyn];
    }
    
    NSAssert([NSThread isMainThread], @"only in main thread");
    if (basyn) {
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
        dispatch_async(dispatch_get_main_queue(), ^(){
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
            [self _routURL:url parameters:parameters];
//            _imp.routeURL(url, parameters);
        });
        return nil;
    }
    return      [self _routURL:url parameters:parameters];
}
-(void)routeURL:(NSURL *)url parameters:(NSDictionary *)parameters waitSeconds:(double)sec {
    if ([TTRouterImp instance] != self) {
        return [[TTRouterImp instance] routeURL:url parameters:parameters waitSeconds:sec];
    }
    NSAssert([NSThread isMainThread], @"only in main thread");
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        [self _routURL:url parameters:parameters];
    });
}
-(TTRouterResult *)_routURL:(NSURL *)url parameters:(NSDictionary *)parameters{
    NSAssert(url != nil, @"url shoud not be nil");
    NSAssert(url.absoluteString.length > 0, @"url should be valid");
    
    if (!url || !url.absoluteString || !url.absoluteString.length) {
        return nil;
    }
    
    NSMutableString* urlpath = [self urlPathWithSchemeURL:url];
    
    NSMutableDictionary* params = splitQuery(url.query);
    if (params && parameters) {
        for (id key in parameters) {
            [params setObject:parameters[key] forKey:key];
        }
    }
    NSDictionary* outparams = params ? [params copy] : [parameters copy];
    BOOL bHandled = FALSE; // 没有使用，一直是NO
    TTRouterResult *result = [self _routURL:url urlPath:urlpath outparams:outparams handler:&bHandled];
    
    if (result.canFindHandler) {
        return result;
    }
    
    /// 例子: nextapp:///page/trade_shop?id=123456
    /// 转化为 nextapp:///interWebView {url: trade_shop?id=123456 }
    /// 有些nextapp page事件为nextapp://page/, nextapp:///page/, nextapp:////page/等，所以匹配方式如下:
    BOOL isAlimusicPageUrl = [url.scheme isEqualToString:@"nextapp"]
                            && [url.path rangeOfString:@"/page/"].location != NSNotFound;
    if (isAlimusicPageUrl) {
        // 如果是nextapp的page事件，但是没有找到handler响应，尝试打开网页页面
        NSString *newUrlContent = [self interWebViewUrlContentForAlimusic:urlpath outparams:outparams];
        return [self _routURL:[NSURL URLWithString:@"nextapp:///interWebView"]
                   parameters:@{ @"url": newUrlContent }];
    }
    
    return result;
}

- (NSString *)interWebViewUrlContentForAlimusic:(NSString *)urlpath outparams:(NSDictionary *)outparams {
    __block NSString *newUrl = [[urlpath lastPathComponent] stringByAppendingString:@".html?"];
    // 如果有参数，把所有参数添加到url后面作为参数
    [outparams enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        if ([key isKindOfClass:[NSString class]]) {
            NSString *stringValue = nil;
            // url中的参数只支持string和number两个类型，其他类型参数因为未知如何转化成string故忽略
            if ([value isKindOfClass:[NSString class]]) {
                stringValue = value;
            } else if ([value isKindOfClass:[NSNumber class]]) {
                stringValue = [(NSNumber *)value stringValue];
            }
            
            if (stringValue == nil) {
                return;
            }
            newUrl = [newUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, stringValue]];
        }
    }];
    // 去掉最后一个字符，如果没有parameters，则去掉的是多出的?，否则去掉的是多出的&
    newUrl = [newUrl substringToIndex:newUrl.length - 1];
    return newUrl;
}

-(TTRouterResult *)_routURL:(NSURL *)url  urlPath:(NSString *)urlpath  outparams:(NSDictionary *)outparams handler:(BOOL* )bHandled{
      NSError* err = nil;
    NSMutableDictionary *patternDic  = [NSMutableDictionary dictionaryWithDictionary:self.patternHandlerClassDic];
    [patternDic addEntriesFromDictionary:self.patternBlockDic];
    TTRouterResult *result = [TTRouterResult new];
    result.canFindHandler = NO;
    for(NSString *key in [patternDic allKeys]){
        NSRegularExpression* re = [NSRegularExpression regularExpressionWithPattern:key
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&err];
        NSAssert(re, @"regex should not be nil");
        NSAssert(!err, @"regex should have no error");
        if (re && !err) {
            NSTextCheckingResult* firstMatch = [re firstMatchInString:urlpath
                                                              options:0
                                                                range:NSMakeRange(0, urlpath.length)];
            if (firstMatch) {
                result.canFindHandler = YES;
                NSMutableArray* array = nil;
                if (firstMatch.numberOfRanges > 1) {
                    array = [NSMutableArray array];
                    for (NSUInteger i = 1; i< [firstMatch numberOfRanges]; ++i) {
                        NSRange rng = [firstMatch rangeAtIndex:i];
                        if (rng.length && rng.length <= urlpath.length) {
                            [array addObject:[urlpath substringWithRange:rng]];
                        }
                    }
                }
                
                @try {
                    TTRouterContext *context = [TTRouterContext contextWithUrl:url matchPaths:array queryParam:outparams];
                    result = [self handle:key context:context withHandler:patternDic[key]];
                    return  result;
                }
                @catch (NSException *exception) {
                    NSLog(@"Route exception:\nurl:%@", url);
                    NSLog(@"\n reason:%@", exception.reason);
                    NSLog(@"\n stackSymbol:%@", exception.callStackSymbols);
                    return result;
                }
                @finally {
                }
            }
        }
    }
    return result;
}

-(TTRouterResult *)handle:(NSString *)pattern context:(TTRouterContext *)context withHandler:(id)handler{
    if ([handler isKindOfClass:[NSArray class]]) {
        id handleResult = nil;
        NSArray *arr = handler;
        id handler =  [self handlerForClassName:arr[0]];
        SEL  sel =   NSSelectorFromString(arr[1]);
        
        NSMethodSignature* methodSig = [handler methodSignatureForSelector:sel];
        if(methodSig == nil){
            handleResult = nil;
        }
        const char* retType = [methodSig methodReturnType];
        if (retType == NULL) {
            handleResult = nil;
        } else if(strcmp(retType, @encode(id)) == 0){
            SuppressPerformSelectorLeakWarning(handleResult = [handler performSelector:sel withObject:context]);
        } else{
            SuppressPerformSelectorLeakWarning([handler performSelector:sel withObject:context]);
            handleResult =  nil;
        }
       TTRouterResult *result = [TTRouterResult new];
       result.canFindHandler = YES;
        result.hanleResult = handleResult;
        return result;
    }else {
        TTRoutehandler handleBlock = (TTRoutehandler)handler;
        return   handleBlock(context);
    }
    
}
-(void)addRoute:(NSString *)pattern block:(TTRoutehandler)handler {
    self.patternBlockDic[pattern] = handler;
}
-(void)addRoute:(NSString*)pattern withObject:(Class)obj selector:(SEL)selector,... {
    NSAssert(pattern, @"pattern is null");
    NSAssert(obj, @"obj is null");
    NSAssert(NSStringFromSelector(selector), @"selector is null");
    NSString* strSel = NSStringFromSelector(selector);
    if (!pattern || !obj  || !strSel) {
        return;
    }
    self.patternHandlerClassDic[pattern] = @[NSStringFromClass(obj),strSel];
}
                     
-(id)handlerForClassName:(NSString *)className{
    
    id obj =  self. handlerFactoryDic[className];
    if (!obj){
        obj =  [NSClassFromString(className) new];
        self. handlerFactoryDic[className] = obj;
    }
    return obj;
  
}

- (BOOL)couldRouteBySchemeHandler:(NSURL *)schemeURL {
    
    NSMutableString *urlpath = [self urlPathWithSchemeURL:schemeURL];

    BOOL couldRoute = NO;
    
    NSError* err = nil;
    NSMutableDictionary *patternDic  = [NSMutableDictionary dictionaryWithDictionary:self.patternHandlerClassDic];
    [patternDic addEntriesFromDictionary:self.patternBlockDic];
    for(NSString *key in [patternDic allKeys]){
        NSRegularExpression* re = [NSRegularExpression regularExpressionWithPattern:key
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&err];
        if (re && !err) {
            NSTextCheckingResult* firstMatch = [re firstMatchInString:urlpath
                                                              options:0
                                                                range:NSMakeRange(0, urlpath.length)];
            if (firstMatch && patternDic[key]) {
                couldRoute = YES;
                break;
            }
        }
    }
    
    return couldRoute;
}

@end
