//
//  LPADemoTableViewController.m
//  LPAUIKit_Example
//
//  Created by 平果太郎 on 2017/10/19.
//  Copyright © 2017年 leeping610. All rights reserved.
//

#import "LPADemoTableViewController.h"
#import "LPADemoTableCellViewModel.h"

#import <LPAUIKit/LPAUIKit.h>

@interface LPADemoTableViewController () <LPATableViewDelegate>

@property (nonatomic, strong) LPATableView *tableView;

@end

@implementation LPADemoTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    // Demo
    LPATableViewModel *tableViewModel = [[LPATableViewModel alloc] init];
    LPADemoTableCellViewModel *demoViewModel = [[LPADemoTableCellViewModel alloc] init];
    demoViewModel.title = @"1111";
    demoViewModel.descriptionText = @"222";
    [self.tableView bindTableViewModel:tableViewModel];
    [tableViewModel addCellViewModel:demoViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors

- (LPATableView *)tableView {
    if (!_tableView) {
        _tableView = [[LPATableView alloc] initWithFrame:self.view.bounds];
    }
    return _tableView;
}

@end
