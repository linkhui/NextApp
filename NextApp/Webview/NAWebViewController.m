//
// Created by lihui on 2017/3/5.
// Copyright (c) 2017 appgo. All rights reserved.
//

#import "NAWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface NAWebViewController()

@property(nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation NAWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 开启日志，方便调试
    [WebViewJavascriptBridge enableLogging];

    // 给哪个webview建立JS与OjbC的沟通桥梁
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];

    // JS主动调用OjbC的方法
// 这是JS会调用getUserIdFromObjC方法，这是OC注册给JS调用的
// JS需要回调，当然JS也可以传参数过来。data就是JS所传的参数，不一定需要传
// OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
    [self.bridge registerHandler:@"getUserIdFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getUserIdFromObjc, data from js is %@",data);
        if (responseCallback) {
            //反馈给JS
            responseCallback(@{@"userid":@"12345"});
        }
    }];

    //直接调用JS端注册的HandleName
    [self.bridge callHandler:@"getUserInfos" data:@{@"name": @"标哥"} responseCallback:^(id responseData) {
        NSLog(@"from js: %@", responseData);
    }];
}


@end
