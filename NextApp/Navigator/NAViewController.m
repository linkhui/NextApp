//
//  NAViewController.m
//  NextApp
//
//  Created by lihui on 2017/3/4.
//  Copyright © 2017年 appgo. All rights reserved.
//

#import "NAViewController.h"

@interface NAViewController ()

@end

@implementation NAViewController

@synthesize customBackGesture;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
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

-(BOOL)canDismissWithGesture {
    return YES;
}

- (TTViewControllerPresentStyle)presentStyle {
    return TTViewControllerPresentStylePush;
}

@end
