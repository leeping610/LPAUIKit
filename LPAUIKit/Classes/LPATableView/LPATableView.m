//
//  LPATableView.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/19.
//

#import "LPATableView.h"
#import "LPATableViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface LPATableView ()

@property (nonatomic, strong, readwrite) LPATableViewModel *tableViewModel;

@property (nonatomic, strong) RACDisposable *reloadDataDisposable;
@property (nonatomic, strong) RACDisposable *scrollToRowAtIndexDisposable;
@property (nonatomic, strong) RACDisposable *scrollToNearestSelectedRowDisposable;
@property (nonatomic, strong) RACDisposable *insertSectionDisposable;
@property (nonatomic, strong) RACDisposable *deleteSectionDisposable;
@property (nonatomic, strong) RACDisposable *replaceSectionDisposable;
@property (nonatomic, strong) RACDisposable *reloadSectionDisposable;
@property (nonatomic, strong) RACDisposable *insertRowAtIndexPathsDisposable;
@property (nonatomic, strong) RACDisposable *deleteRowAtIndexPathsDisposable;
@property (nonatomic, strong) RACDisposable *replaceRowAtIndexPathsDisposable;
@property (nonatomic, strong) RACDisposable *reloadRowAtIndexPathsDisposable;

@end

@implementation LPATableView

#pragma mark - Life Cycle

- (void)bindTableViewModel:(LPATableViewModel *)tableViewModel {
    NSParameterAssert(tableViewModel);
    if (_tableViewModel && _tableViewModel != tableViewModel) {
        /// 清除原viewModel订阅
        [_reloadDataDisposable dispose];
        [_scrollToRowAtIndexDisposable dispose];
        [_scrollToNearestSelectedRowDisposable dispose];
        [_insertSectionDisposable dispose];
        [_deleteSectionDisposable dispose];
        [_replaceSectionDisposable dispose];
        [_reloadSectionDisposable dispose];
        [_insertRowAtIndexPathsDisposable dispose];
        [_deleteRowAtIndexPathsDisposable dispose];
        [_replaceRowAtIndexPathsDisposable dispose];
        [_reloadRowAtIndexPathsDisposable dispose];
    }
    self.tableViewModel = tableViewModel;
    self.dataSource = tableViewModel.tableViewDataSource;
    self.delegate = tableViewModel.tableViewDelegate;
    
    @weakify(self)
    self.reloadDataDisposable =
    [[[_tableViewModel.reloadDataSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        [self reloadData];
    }];
    self.scrollToRowAtIndexDisposable =
    [[[_tableViewModel.scrollToRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        [self scrollToRowAtIndexPath:tuple.first atScrollPosition:[tuple.second integerValue] animated:[tuple.third boolValue]];
    }];
    self.scrollToNearestSelectedRowDisposable =
    [[[_tableViewModel.scrollToNearestSelectedRowSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        [self scrollToNearestSelectedRowAtScrollPosition:[tuple.first integerValue] animated:[tuple.second boolValue]];
    }];
    self.insertSectionDisposable =
    [[[_tableViewModel.insertSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.second integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            [self insertSections:tuple.first withRowAnimation:rowAnimation];
        }
    }];
    self.deleteSectionDisposable =
    [[[_tableViewModel.deleteSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.second integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            [self deleteSections:tuple.first withRowAnimation:rowAnimation];
        }
    }];
    self.replaceSectionDisposable =
    [[[_tableViewModel.replaceSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.second integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            NSIndexSet *indexSet = tuple.first;
            UITableViewRowAnimation removeAnimation = UITableViewRowAnimationNone;
            if (rowAnimation == UITableViewRowAnimationRight) {
                removeAnimation = UITableViewRowAnimationLeft;
            } else if (rowAnimation == UITableViewRowAnimationLeft) {
                removeAnimation = UITableViewRowAnimationRight;
            } else if (rowAnimation == UITableViewRowAnimationTop) {
                removeAnimation = UITableViewRowAnimationBottom;
            } else if (rowAnimation == UITableViewRowAnimationBottom) {
                removeAnimation = UITableViewRowAnimationTop;
            }
            [self beginUpdates];
            [self deleteSections:indexSet withRowAnimation:removeAnimation];
            [self insertSections:indexSet withRowAnimation:rowAnimation];
            [self endUpdates];
        }
    }];
    self.reloadDataDisposable =
    [[[_tableViewModel.reloadSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.second integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            NSIndexSet *indexSet = tuple.first;
            [self reloadSections:indexSet withRowAnimation:rowAnimation];
        }
    }];
    self.insertSectionDisposable =
    [[[_tableViewModel.insertRowsAtIndexPathsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.second integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            [self insertRowsAtIndexPaths:tuple.first withRowAnimation:rowAnimation];
        }
    }];
    self.deleteSectionDisposable =
    [[[_tableViewModel.deleteRowsAtIndexPathsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.second integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            [self deleteRowsAtIndexPaths:tuple.first withRowAnimation:rowAnimation];
        }
    }];
    self.replaceRowAtIndexPathsDisposable =
    [[[_tableViewModel.replaceRowsAtIndexPathsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.second integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            NSArray *indexPathList = tuple.first;
            UITableViewRowAnimation removeAnimation = UITableViewRowAnimationNone;
            if (rowAnimation == UITableViewRowAnimationRight) {
                removeAnimation = UITableViewRowAnimationLeft;
            } else if (rowAnimation == UITableViewRowAnimationLeft) {
                removeAnimation = UITableViewRowAnimationRight;
            } else if (rowAnimation == UITableViewRowAnimationTop) {
                removeAnimation = UITableViewRowAnimationBottom;
            } else if (rowAnimation == UITableViewRowAnimationBottom) {
                removeAnimation = UITableViewRowAnimationTop;
            }
            [self beginUpdates];
            [self deleteRowsAtIndexPaths:indexPathList withRowAnimation:removeAnimation];
            [self insertRowsAtIndexPaths:indexPathList withRowAnimation:rowAnimation];
            [self endUpdates];
        }
    }];
    self.reloadRowAtIndexPathsDisposable =
    [[[_tableViewModel.reloadRowsAtIndexPathsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.first integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            [self reloadRowsAtIndexPaths:tuple.first withRowAnimation:rowAnimation];
        }
    }];
    // Reload if tableViewModel exist datas
    if (_tableViewModel) {
        [self reloadData];
    }
}

@end
