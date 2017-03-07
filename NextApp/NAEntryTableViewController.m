//
//  NAEntryTableViewController.m
//  NextApp
//
//  Created by lihui on 2017/3/3.
//  Copyright © 2017年 appgo. All rights reserved.
//

#import "NAEntryTableViewController.h"
#import "NARouter.h"
#import "NAAPIService.h"
#import "NAAPIRequest.h"

#import "NAWebViewController.h"

@interface NAEntryTableViewController ()

@property(nonatomic, strong)NSArray *entries;

@end

@implementation NAEntryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"NextApp";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self buildEntries];
}

- (void)buildEntries {
    self.entries = @[@"api - douban search books",@"RAC", @"h5 - baidu.com", @"weex", @"js bridge"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entries count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.entries[indexPath.row];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self fetchDoubanBook];
        return;
    }

    if (indexPath.row == 2) {
        NAWebViewController *webViewController = [[NAWebViewController alloc] initWithAddress:@"https://www.baidu.com"];
        [self.navigationController pushViewController:webViewController animated:YES];
        return;
    }

    if (indexPath.row == 4) {
        NAWebViewController *webViewController = [[NAWebViewController alloc] initWithAddress:@"http://192.168.1.106/testjsbridge.html"];
        [self.navigationController pushViewController:webViewController animated:YES];
        return;
    }
    
    [[NARouter defaultRouter] route:@"nextapp:///interpage/NAViewController" withParam:nil];
}

- (void)fetchPM25 {
    NAAPIRequest *request = [NAAPIRequest  new];
    request.requestURL = [NSURL URLWithString:@"http://www.pm25.in/api/querys/pm2_5.json?city=%E4%B8%8A%E6%B5%B7&token=5j1znBVAsnSf5xQyNQyq"];
    NAAPIService *api = [NAAPIService  new];
    [api request:request callback:^(NAAPIRequest *request, id result, NSError *error) {
        if (error == nil && [result isKindOfClass:[NSArray class]]) {
            NSArray *pm25s = (NSArray *)result;
            NSDictionary *pm25info = [pm25s firstObject];
            NSLog(@"%@ %@",pm25info[@"position_name"], pm25info[@"pm2_5"]);
            //                NSLog(@"%@ %@ %@",pm25info[@"position_name"],pm25info[@"pm2_5"],pm25info[[@"quality"]);
        }
    }];
}

- (void)fetchDoubanBook {

    [[NARouter defaultRouter] route:@"nextapp:///interpage/NADoubanBookViewController" withParam:nil];
}

@end
