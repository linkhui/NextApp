//
//  TTRouter.m
//  TTUISkeleton
//
//  Created by guanshanliu on 11/20/15.
//  Copyright © 2015 TTPod. All rights reserved.
//

#import "TTRouter.h"
#import "TTRouterImp.h"
//#import <AliPlanetWeex/AliPlanetWeex.h>

static const NSString *TTRequestCodeString = @"requestCode";

@implementation TTRouter{
    NSMutableDictionary  *_routerMap;
}
+ (instancetype)defaultRouter {
    static dispatch_once_t onceToken;
    static TTRouter *router;
    dispatch_once(&onceToken, ^{
        router = [TTRouter new];
    });
    return router;
}
-(instancetype)init{
    if (self = [super init]) {
        _routerMap = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    return self;
}
- (TTRouterResult *)route:(NSString *)urlString withParam:(NSDictionary *)param {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *sourceViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        sourceViewController = [(UINavigationController *)rootViewController topViewController];
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        sourceViewController = ({
            UITabBarController *tab = (UITabBarController *)rootViewController;
            tab.selectedViewController;
        });
    } else if ([rootViewController isKindOfClass:[UISplitViewController class]]) {
        sourceViewController = ({
            UISplitViewController *split = (UISplitViewController *)rootViewController;
            split.viewControllers.firstObject;
        });
    }
    
    TTRouterResult *result = [self checkSchemeTransferWithUrl:urlString withParam:param fromViewController:sourceViewController];
    return result;
}

- (TTRouterResult *)impRoute:(NSString *)urlString withParam:(NSDictionary *)param fromViewController:(UIViewController *)viewController {
    return [[TTRouterImp instance] route:urlString parameters:param];
}

- (BOOL)couldRouteBySchemeHandler:(NSString *)urlString {
    NSString *schemeURLString = [self nextappSchemeForHttpUrlContent:urlString];
    
    BOOL couldRoute = NO;
    if (schemeURLString.length) {
        NSURL *schemeURL = [NSURL URLWithString:schemeURLString];
        NSString *scheme = schemeURL.scheme;
        TTRouterImp *routerImp = _routerMap[scheme];
        
        couldRoute = [routerImp couldRouteBySchemeHandler:schemeURL];
    }
    
    return couldRoute;
}

- (TTRouterResult *)route:(NSString *)urlString withParam:(NSDictionary *)param fromViewController:(UIViewController *)viewController {
    // TODO: 跳转
    return [self checkSchemeTransferWithUrl:urlString withParam:param fromViewController:viewController];
}

- (TTRouterResult *)routeToWeexWithUrlString:(NSString *)urlString
                    withTransformedUrlString:(NSString *)urlSchema
                                   withParam:(NSDictionary *)param
                              withController:(UIViewController *)controller {
    NSString *weexURLString = nil;
//    if ([[ALMWeexURLSchemaConfiguration sharedInstance] weexCanHandle:urlString]) {
//        weexURLString = [[ALMWeexURLSchemaConfiguration sharedInstance] transformURLSchemaToWeexURL:urlString
//                                                                                         withParams:param
//                                                                                 withExtendedParams:&param];
//    }
//    
//    if (weexURLString.length == 0 &&
//        urlSchema.length > 0 &&
//        [[ALMWeexURLSchemaConfiguration sharedInstance] weexCanHandle:urlSchema]) {
//        weexURLString = [[ALMWeexURLSchemaConfiguration sharedInstance] transformURLSchemaToWeexURL:urlSchema
//                                                                                         withParams:param
//                                                                                 withExtendedParams:&param];
//    }
    
    if (weexURLString.length > 0) {
        return [self impRoute:weexURLString withParam:param fromViewController:controller];
    }
    
    return nil;
}

// 检查H5 to native转换
- (TTRouterResult *)checkSchemeTransferWithUrl:(NSString *)urlString withParam:(NSDictionary *)param fromViewController:(UIViewController *)viewController {
    // 如果是通过Hybrid中interWebview转化的，不需要转化成nextapp scheme。
    // 否则如果转化后找不到响应的原生界面，又会interWebview转化为http scheme，造成死循环。
    BOOL fromInterWebView = [param[@"_fromInterWebView"] boolValue];
    TTRouterResult *result = nil;
    
    NSString *scheme = [self nextappSchemeForHttpUrlContent:urlString];
    
    result = [self routeToWeexWithUrlString:urlString
                   withTransformedUrlString:scheme
                                  withParam:param
                             withController:viewController];
    
    if (!result.canFindHandler && !fromInterWebView && scheme) {
        // 如果不是来自于Hybrid中interWebview转化，又匹配下发的domain host，则优先native页面
        result = [self impRoute:scheme withParam:param fromViewController:viewController];
    }
    
    if (!result.canFindHandler) {
        // 如果找不到处理的handler，按原始url处理
        result = [self impRoute:urlString withParam:param fromViewController:viewController];
    }
    
    if (result && !result.canFindHandler) {
    }
    return result;
}

- (NSString *)transformableUrlContentPrexfix {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"tt_global_url_prefix"];
}

/// 例子: http://h5.dongting.com/app/youle/trade_shop.html?id=123456
/// 转化为 nextapp:///page/trade_shop?id=123456
- (NSString *)nextappSchemeForHttpUrlContent:(NSString *)urlContent {
    if (nil == urlContent) {
        return nil;
    }
    NSString *defaultDomainPrefix = [self transformableUrlContentPrexfix];
    if ([defaultDomainPrefix hasPrefix:@"http"]) {
        defaultDomainPrefix = [defaultDomainPrefix componentsSeparatedByString:@"//"].lastObject;
    }
    
    while ([defaultDomainPrefix hasPrefix:@"/"]) {
        defaultDomainPrefix = [defaultDomainPrefix substringFromIndex:1];
    }
    
    if (!defaultDomainPrefix) {
        return nil;
    }
    
    // 通过正则表达式匹配http(s?)://下发地址
    NSString *pattern = [NSString stringWithFormat:@"http(s?)://%@", defaultDomainPrefix];
    
    NSError* err = nil;
    NSRegularExpression* re = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:&err];
    NSAssert(re, @"regex should not be nil");
    NSAssert(!err, @"regex should have no error");
    if (!re || err) {
        return nil;
    }
    
    NSTextCheckingResult* firstMatch = [re firstMatchInString:urlContent
                                                      options:0
                                                        range:NSMakeRange(0, urlContent.length)];
    if (firstMatch.numberOfRanges == 0) {
        return nil;
    }
    
    // 1. 截取匹配后的部分
    NSRange range = [firstMatch rangeAtIndex:0];
    NSString *pathAndParameters = [urlContent substringFromIndex:range.location + range.length];
    NSArray *components = [pathAndParameters componentsSeparatedByString:@"?"];
    // 2. 去掉网页扩展名
    NSString *path = [components.firstObject stringByDeletingPathExtension];
    if (!path) {
        return nil;
    }
    
    // 3. 在前面加上nextapp:///page/前缀
    NSString *scheme = [@"nextapp:///page/" stringByAppendingString:path];
    for (NSInteger index = 1; index < components.count; index++) {
        scheme = [scheme stringByAppendingString:[NSString stringWithFormat:@"?%@", components[index]]];
    }
    return scheme;
}

- (void)addPattern:(NSString*)pattern withHandlerClassName:(NSString *)handlerClassName selectorName:(nonnull NSString *)selectorName{
    [self addRoute:pattern withObject:NSClassFromString(handlerClassName) selector:NSSelectorFromString(selectorName)];
}

- (void)addPattern:(NSString *)pattern withHandlerClassName:(NSString *)handlerClassName selectorName:(nonnull NSString *)selectorName forScheme:(NSString *)scheme{
    [self addRoute:pattern withObject: NSClassFromString(handlerClassName) selector:NSSelectorFromString(selectorName) forScheme:scheme];
}

-(void)addRoute:(NSString *)pattern withObject:(id)obj selector:(SEL)selector{
    return [self   addRoute:pattern withObject:obj selector:selector forScheme:@"nextapp"];
}
- (TTRouterImp *)routerForScheme:(NSString *)scheme{
    TTRouterImp *imp = nil;
    if (scheme == nil) {
         scheme = @"nextapp";
    }
    imp = _routerMap[scheme];
    if (!imp) {
        imp = [[TTRouterImp instance]newSubRouter:[NSString stringWithFormat:@"%@://",scheme]];
        _routerMap[scheme] = imp;
    }
    return  imp;
}
-(void)addRoute:(NSString *)pattern withObject:(id)obj selector:(SEL)selector forScheme:(NSString *)scheme{
   [[self routerForScheme:scheme] addRoute:pattern withObject:obj selector:selector,nil];
}

- (TTRouterResult *)route:(NSString *)urlString
                withParam:(nullable NSDictionary *)param
          withRequestCode:(NSInteger)requestCode {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setObject:@(requestCode) forKey:TTRequestCodeString];
    return [self route:urlString
             withParam:params];
}

- (TTRouterResult *)route:(NSString *)urlString
                withParam:(nullable NSDictionary *)param
       fromViewController:(UIViewController *)viewController
          withRequestCode:(NSInteger)requestCode {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setObject:@(requestCode) forKey:TTRequestCodeString];
    return [self route:urlString
             withParam:params
    fromViewController:viewController];
}
@end
