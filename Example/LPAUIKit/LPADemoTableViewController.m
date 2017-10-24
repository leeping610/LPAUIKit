//
//  LPADemoTableViewController.m
//  LPAUIKit_Example
//
//  Created by 平果太郎 on 2017/10/19.
//  Copyright © 2017年 leeping610. All rights reserved.
//

#import "LPADemoTableViewController.h"

#import <LPAUIKit/LPATableView.h>

@interface LPADemoTableViewController () <LPATableViewDelegate,
                                          UITableViewDelegate,
                                          UITableViewDataSource>

@property (nonatomic, strong) LPATableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDatas;

@end

@implementation LPADemoTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[LPATableView alloc] initWithFrame:self.view.bounds
                                             refreshType:LPATableViewRefreshTypeHeader | LPATableViewRefreshTypeFooter];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.lpaDelegate = self;
    self.tableDatas = [NSMutableArray array];
    for (NSInteger i = 0; i < 20; i++) {
        [_tableDatas addObject:@(i)];
    }
    // Add to superView
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)[_tableDatas[indexPath.row] integerValue]];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - LPATableView Delegate

- (void)tableViewDidHeaderPull:(LPATableView *)tableView
{
    NSLog(@"%s", __FUNCTION__);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView endRefresh];
    });
}

- (void)tableViewDidFooterPull:(LPATableView *)tableView
{
    NSLog(@"%s", __FUNCTION__);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 20; i++) {
            [_tableDatas addObject:@(i)];
        }
        [tableView reloadData];
        tableView.refreshType = LPATableViewRefreshTypeHeader;
    });
}

@end
