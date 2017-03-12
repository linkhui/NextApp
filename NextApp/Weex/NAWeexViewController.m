//
//  NAWeexViewController.m
//  NextApp
//
//  Created by lihui on 2017/3/12.
//  Copyright © 2017年 appgo. All rights reserved.
//

#import "NAWeexViewController.h"
#import <WeexSDK/WXSDKInstance.h>

@interface NAWeexViewController ()

@property (nonatomic, strong)WXSDKInstance *instance;
@property (nonatomic, strong)UIView *weexView;

@end

@implementation NAWeexViewController

- (void)dealloc {
    [_instance destroyInstance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    _instance.frame = self.view.frame;
    __weak typeof(self) weakself = self;
    _instance.onCreate = ^(UIView *view) {
        [weakself.weexView removeFromSuperview];
        weakself.weexView = view;
        [weakself.view addSubview:weakself.weexView];
    };
    
    _instance.onFailed = ^(NSError *error) {
        
    };
    
    _instance.renderFinish = ^(UIView *view) {
        
    };
    
    [_instance renderWithURL:self.url];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
