//
//  LPACollectionView.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/19.
//

#import "LPACollectionView.h"
#import <MJRefresh/MJRefresh.h>

@interface LPACollectionView ()

@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshBackNormalFooter *refreshFooter;

@end

@implementation LPACollectionView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
                  refreshType:(LPACollectionViewRefreshType)refreshType {
    self = [super initWithFrame:frame];
    if (self) {
        self.refreshType = refreshType;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                  refreshType:(LPACollectionViewRefreshType)refreshType {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.refreshType = refreshType;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)reloadData {
    [super reloadData];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)beginHeaderRefresh {
    [self.mj_header beginRefreshing];
}

- (void)beginFooterRefresh {
    [self.mj_footer beginRefreshing];
}

- (void)endRefresh {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

#pragma mark - Event Response

- (void)headerRefreshDidPullHandler {
    if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(collectionViewDidHeaderPull:)]) {
        [self.lpaDelegate collectionViewDidHeaderPull:self];
    }
}

- (void)footerRefreshDidPullHandler {
    if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(collectionViewDidFooterPull:)]) {
        [self.lpaDelegate collectionViewDidFooterPull:self];
    }
}

#pragma mark - Custom Accessors

- (MJRefreshNormalHeader *)refreshHeader {
    if (!_refreshHeader) {
        __weak typeof(self) weakSelf = self;
        _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefreshDidPullHandler];
        }];
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _refreshHeader;
}

- (MJRefreshBackNormalFooter *)refreshFooter {
    if (!_refreshFooter) {
        __weak typeof(self) weakSelf = self;
        _refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerRefreshDidPullHandler];
        }];
    }
    return _refreshFooter;
}

- (void)setRefreshType:(LPACollectionViewRefreshType)refreshType {
    _refreshType = refreshType;
    if (_refreshType & LPACollectionViewRefreshTypeHeader) {
        self.mj_header = self.refreshHeader;
    }else {
        self.mj_header = nil;
    }
    if (_refreshType & LPACollectionViewRefreshTypeFooter) {
        self.mj_footer = self.refreshFooter;
    }else {
        self.mj_footer = nil;
    }
}

@end
