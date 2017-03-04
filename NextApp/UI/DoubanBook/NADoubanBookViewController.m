//
//  NADoubanBookViewController.m
//  NextApp
//
//  Created by lihui on 2017/3/4.
//  Copyright © 2017年 appgo. All rights reserved.
//

#import "NADoubanBookViewController.h"
#import "DoubanBookModel.h"
#import "DoubanBookViewModel.h"
#import "UIImageView+WebCache.h"

@interface NADoubanBookViewController ()
@property (nonatomic, strong) DoubanBookViewModel *viewModel;
@end

@implementation NADoubanBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Douban book";
    [self.viewModel fetchDoubanBook:^(id result, NSError *error) {
        [self.tableView reloadData];
    }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.viewModel.model.title;
    cell.detailTextLabel.text = self.viewModel.model.summary;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.image]];

    return cell;
}

- (DoubanBookViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [DoubanBookViewModel new];
    }
    return _viewModel;

}

@end
