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
    // Demo
    LPATableViewModel *tableViewModel = [[LPATableViewModel alloc] init];
    for (NSInteger i = 0; i < 100; i++) {
        LPADemoTableCellViewModel *demoViewModel = [[LPADemoTableCellViewModel alloc] init];
        demoViewModel.title = [NSString stringWithFormat:@"第%ld个标题", i];
        demoViewModel.descriptionText = [NSString stringWithFormat:@"第%ld个描述🐱", i];
        [tableViewModel addCellViewModel:demoViewModel];
    }
    [self.tableView bindTableViewModel:tableViewModel];
    [self.tableView setLpa_pullToRefreshStyle:LPAScrollPullToRefreshStyleHeader];
    [self.tableView lpa_didHeaderPullToRefresh:[^(LPATableView *tableView){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView lpa_endPullToRefresh];
        });
    } copy]];
    __weak typeof(self) weakSelf = self;
    LPABarButtonItemHandlerBlock rightBlock1 = ^(UIButton *barButton) {
        [tableViewModel removeAllSection];
    };
    LPABarButtonItemHandlerBlock rightBlock2 = ^(UIButton *barButton) {
        [weakSelf.tableView reloadData];
    };
    LPABarButtonItemHandlerBlock rightBlock3 = ^(UIButton *barButton) {
        [weakSelf.tableView setEditing:!weakSelf.tableView.isEditing animated:YES];
    };
    [self lpa_addRightBarButtonItemWithTextList:@[@"删", @"刷", @"编"] handlerBlockList:@[rightBlock1, rightBlock2, rightBlock3]];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LPATableView Delegate

- (void)tableView:(LPATableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    LPADemoTableCellViewModel *demoViewModel = [[LPADemoTableCellViewModel alloc] init];
    demoViewModel.title = [NSString stringWithFormat:@"我是添加的%@", indexPath];
    demoViewModel.descriptionText = [NSString stringWithFormat:@"我也是添加的%@", indexPath];
    [_tableView.tableViewModel insertCellViewModel:demoViewModel atRowIndex:indexPath.row withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(LPATableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Custom Accessors

- (LPATableView *)tableView {
    if (!_tableView) {
        _tableView = [[LPATableView alloc] initWithFrame:self.view.bounds];
        _tableView.lpaDelegate = self;
    }
    return _tableView;
}

@end
