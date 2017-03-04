//
//  NAEntryTableViewController.m
//  NextApp
//
//  Created by lihui on 2017/3/3.
//  Copyright © 2017年 appgo. All rights reserved.
//

#import "NAEntryTableViewController.h"
#import "NAViewController.h"
#import "NARouter.h"

@interface NAEntryTableViewController ()

@end

@implementation NAEntryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"NextApp";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UINib * nib = [UINib nibWithNibName:@"Cell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [@(indexPath.row) stringValue];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NAViewController *vc = [NAViewController new];
//    vc.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [[NARouter defaultRouter] route:@"nextapp:///interpage/NAViewController" withParam:nil];
}

@end
