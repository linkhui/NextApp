//
//  NATableViewController.m
//  TTUISkeleton
//
//  Created by  on 11/20/15.
//  Copyright © 2015 TTPod. All rights reserved.
//

#import "NATableViewController.h"

@implementation NATableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) {
        return nil;
    }
    
    self.style = style;
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) {
        return nil;
    }
    
    self.style = UITableViewStylePlain;
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    self.style = UITableViewStylePlain;
    
    return self;
}

- (void)loadView {
    CGRect frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:self.style];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView;
    });
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.clearsSelectionOnViewWillAppear) {
        [self clearSelections:self.tableView];
    }
}

#pragma mark - Table View

- (void)setTableView:(UITableView *)tableView {
    if (!tableView) {
        return;
    }
    
    _tableView = tableView;
    _tableView.frame = self.view.bounds;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Miscs

- (void)clearSelections:(UITableView *)tableView {
    NSArray *selectedRows = [tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedRows) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

@end
