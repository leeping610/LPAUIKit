//
//  LPATableView.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/19.
//

#import "LPATableView.h"
#import <MJRefresh/MJRefresh.h>

@interface LPATableView ()

@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshBackNormalFooter *refreshFooter;

@end

@implementation LPATableView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
                  refreshType:(LPATableViewRefreshType)refreshType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.refreshType = refreshType;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                  refreshType:(LPATableViewRefreshType)refreshType
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.refreshType = refreshType;
    }
    return self;
}

- (void)reloadData
{
    [super reloadData];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)beginHeaderRefresh
{
    [self.mj_header beginRefreshing];
}

- (void)beginFooterRefresh
{
    [self.mj_footer beginRefreshing];
}

- (void)endRefresh
{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

#pragma mark - Event Response

- (void)headerRefreshDidPullHandler
{
    if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableViewDidHeaderPull:)]) {
        [self.lpaDelegate tableViewDidHeaderPull:self];
    }
}
- (void)footerRefreshDidPullHandler
{
    if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableViewDidFooterPull:)]) {
        [self.lpaDelegate tableViewDidFooterPull:self];
    }
}

#pragma mark - Custom Accessors

- (MJRefreshNormalHeader *)refreshHeader
{
    if (!_refreshHeader) {
        __weak typeof(self) weakSelf = self;
        _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefreshDidPullHandler];
        }];
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _refreshHeader;
}

- (MJRefreshBackNormalFooter *)refreshFooter
{
    if (!_refreshFooter) {
        __weak typeof(self) weakSelf = self;
        _refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerRefreshDidPullHandler];
        }];
    }
    return _refreshFooter;
}

- (void)setRefreshType:(LPATableViewRefreshType)refreshType
{
    _refreshType = refreshType;
    if (_refreshType & LPATableViewRefreshTypeHeader) {
        self.mj_header = self.refreshHeader;
    }else {
        self.mj_header = nil;
    }
    if (_refreshType & LPATableViewRefreshTypeFooter) {
        self.mj_footer = self.refreshFooter;
    }else {
        self.mj_footer = nil;
    }
}

@end
