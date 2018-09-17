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
@property (nonatomic, strong) NSMutableArray<RACDisposable *> *disposableList;

@end

@implementation LPATableView

#pragma mark - Life Cycle

- (void)bindTableViewModel:(LPATableViewModel *)tableViewModel {
    NSParameterAssert(tableViewModel);
    if (_tableViewModel && _tableViewModel != tableViewModel) {
        /// 清除原viewModel订阅
        [_disposableList enumerateObjectsUsingBlock:^(RACDisposable *disposable, NSUInteger idx, BOOL *stop) {
            [disposable dispose];
        }];
        [_disposableList removeAllObjects];
    }
    self.tableViewModel = tableViewModel;
    self.dataSource = tableViewModel.tableViewDataSource;
    self.delegate = tableViewModel.tableViewDelegate;
    
    [self bindDataSource:tableViewModel];
    [self bindActions:tableViewModel];
    [self bindDisplay:tableViewModel];
}

- (void)bindDataSource:(LPATableViewModel *)tableViewModel {
    @weakify(self)
    /// DataSource
    RACDisposable *reloadDisposable =
    [[[_tableViewModel.reloadDataSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        [self reloadData];
    }];
    RACDisposable *insertSectionDisposable =
    [[[_tableViewModel.insertSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.second integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            [self insertSections:tuple.first withRowAnimation:rowAnimation];
        }
    }];
    RACDisposable *deleteSectionDisposable =
    [[[_tableViewModel.deleteSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.second integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            [self deleteSections:tuple.first withRowAnimation:rowAnimation];
        }
    }];
    RACDisposable *replaceSectionDisposable =
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
    RACDisposable *reloadSectionDisposable =
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
    RACDisposable *insertRowsAtIndexPathsDisposable =
    [[[_tableViewModel.insertRowsAtIndexPathsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.second integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            [self insertRowsAtIndexPaths:tuple.first withRowAnimation:rowAnimation];
        }
    }];
    RACDisposable *deleteRowsAtIndexPathsDisposable =
    [[[_tableViewModel.deleteRowsAtIndexPathsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.second integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            [self deleteRowsAtIndexPaths:tuple.first withRowAnimation:rowAnimation];
        }
    }];
    RACDisposable *replaceRowsAtIndexPathsDisposable =
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
    RACDisposable *reloadRowsAtIndexPathsDisposable =
    [[[_tableViewModel.reloadRowsAtIndexPathsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewRowAnimation rowAnimation = [tuple.first integerValue];
        if (rowAnimation == UITableViewRowAnimationNone) {
            [self reloadData];
        }else {
            [self reloadRowsAtIndexPaths:tuple.first withRowAnimation:rowAnimation];
        }
    }];
    RACDisposable *commitEditingStyleForRowAtIndexPathDisposable =
    [[[_tableViewModel.commitEditingStyleForRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        UITableViewCellEditingStyle editingStyle = [tuple.first integerValue];
        NSIndexPath *indexPath = tuple.second;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
            [self.lpaDelegate tableView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
        }
    }];
    RACDisposable *moveRowAtIndexPathToIndexPathDisposable =
    [[[_tableViewModel.moveRowAtIndexPathToIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        NSIndexPath *sourceIndexPath = tuple.first;
        NSIndexPath *destinationIndexPath = tuple.second;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
            [self.lpaDelegate tableView:self moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        }
    }];
    [_disposableList addObject:reloadDisposable];
    [_disposableList addObject:insertSectionDisposable];
    [_disposableList addObject:deleteSectionDisposable];
    [_disposableList addObject:replaceSectionDisposable];
    [_disposableList addObject:reloadSectionDisposable];
    [_disposableList addObject:insertRowsAtIndexPathsDisposable];
    [_disposableList addObject:deleteRowsAtIndexPathsDisposable];
    [_disposableList addObject:replaceRowsAtIndexPathsDisposable];
    [_disposableList addObject:reloadRowsAtIndexPathsDisposable];
    [_disposableList addObject:commitEditingStyleForRowAtIndexPathDisposable];
    [_disposableList addObject:moveRowAtIndexPathToIndexPathDisposable];
}

- (void)bindActions:(LPATableViewModel *)tableViewModel {
    @weakify(self)
    // Actions
    RACDisposable *scrollToRowAtIndexPathDisposable =
    [[[_tableViewModel.scrollToRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        [self scrollToRowAtIndexPath:tuple.first atScrollPosition:[tuple.second integerValue] animated:[tuple.third boolValue]];
    }];
    RACDisposable *scrollToNearestSelectedDisposable =
    [[[_tableViewModel.scrollToNearestSelectedRowSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        [self scrollToNearestSelectedRowAtScrollPosition:[tuple.first integerValue] animated:[tuple.second boolValue]];
    }];
    RACDisposable *didHighlightRowAtIndexPathDisposable =
    [[[_tableViewModel.didHighlightRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        NSIndexPath *indexPath = tuple.first;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)]) {
            [self.lpaDelegate tableView:self didHighlightRowAtIndexPath:indexPath];
        }
    }];
    RACDisposable *didUnhighlightRowAtIndexPathDisposable =
    [[[_tableViewModel.didUnhighlightRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        NSIndexPath *indexPath = tuple.first;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)]) {
            [self.lpaDelegate tableView:self didUnhighlightRowAtIndexPath:indexPath];
        }
    }];
    RACDisposable *didSelectRowAtIndexPathDisposable =
    [[[_tableViewModel.didSelectRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        NSIndexPath *indexPath = tuple.first;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [self.lpaDelegate tableView:self didSelectRowAtIndexPath:indexPath];
        }
    }];
    RACDisposable *didDeselectRowAtIndexPathDisposable =
    [[[_tableViewModel.didDeselectRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        NSIndexPath *indexPath = tuple.first;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
            [self.lpaDelegate tableView:self didDeselectRowAtIndexPath:indexPath];
        }
    }];
    RACDisposable *willBeginEditingRowAtIndexPathDisposable =
    [[[_tableViewModel.willBeginEditingRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        NSIndexPath *indexPath = tuple.first;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
            [self.lpaDelegate tableView:self willBeginEditingRowAtIndexPath:indexPath];
        }
    }];
    RACDisposable *didEndEditingRowAtIndexPathDisposable =
    [[[_tableViewModel.didEndEditingRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        NSIndexPath *indexPath = tuple.first;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
            [self.lpaDelegate tableView:self didEndEditingRowAtIndexPath:indexPath];
        }
    }];
    RACDisposable *editActionsForRowAtIndexPathDisposable =
    [[[_tableViewModel.editActionsForRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        NSIndexPath *indexPath = tuple.first;
        void (^rowActionBlock)(NSArray<UITableViewRowAction *> *rowActionList) = tuple.second;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]) {
            NSArray *rowActionList = [self.lpaDelegate tableView:self editActionsForRowAtIndexPath:indexPath];
            if (rowActionBlock) {
                rowActionBlock(rowActionList);
            }
        }
    }];
    RACDisposable *willSelectRowAtIndexPathDisposable =
    [[[_tableViewModel.willSelectRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        NSIndexPath *indexPath = tuple.first;
        void (^block)(NSIndexPath *blockIndexPath) = tuple.second;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
            NSIndexPath *targetIndexPath = [self.lpaDelegate tableView:self willSelectRowAtIndexPath:indexPath];
            if (block) {
                block(targetIndexPath);
            }
        }
    }];
    RACDisposable *willDeselectRowAtIndexPathDisposable =
    [[[_tableViewModel.willDeselectRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        NSIndexPath *indexPath = tuple.first;
        void (^block)(NSIndexPath *blockIndexPath) = tuple.second;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
            NSIndexPath *targetIndexPath = [self.lpaDelegate tableView:self willDeselectRowAtIndexPath:indexPath];
            if (block) {
                block(targetIndexPath);
            }
        }
    }];
    RACDisposable *shouldShowMenuForRowAtIndexPathDisposable =
    [[[_tableViewModel.shouldShowMenuForRowAtIndexPathSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        NSIndexPath *indexPath = tuple.first;
        void (^block)(BOOL should) = tuple.second;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)]) {
            BOOL shouldShowMenu = [self.lpaDelegate tableView:self shouldShowMenuForRowAtIndexPath:indexPath];
            if (block) {
                block(shouldShowMenu);
            }
        }
    }];
    RACDisposable *canPerformActionDisposable =
    [[[_tableViewModel.canPerformActionSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        SEL action = NSSelectorFromString(tuple.first);
        NSIndexPath *indexPath = tuple.second;
        id sender = tuple.third;
        void (^block)(BOOL can) = tuple.fourth;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)]) {
            BOOL can = [self.lpaDelegate tableView:self canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
            if (block) {
                block(can);
            }
        }
    }];
    RACDisposable *performActionDisposable =
    [[[_tableViewModel.performActionSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        SEL action = NSSelectorFromString(tuple.first);
        NSIndexPath *indexPath = tuple.second;
        id sender = tuple.third;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]) {
            [self.lpaDelegate tableView:self performAction:action forRowAtIndexPath:indexPath withSender:sender];
        }
    }];
    [_disposableList addObject:scrollToRowAtIndexPathDisposable];
    [_disposableList addObject:scrollToNearestSelectedDisposable];
    [_disposableList addObject:didHighlightRowAtIndexPathDisposable];
    [_disposableList addObject:didUnhighlightRowAtIndexPathDisposable];
    [_disposableList addObject:didSelectRowAtIndexPathDisposable];
    [_disposableList addObject:didDeselectRowAtIndexPathDisposable];
    [_disposableList addObject:willBeginEditingRowAtIndexPathDisposable];
    [_disposableList addObject:didEndEditingRowAtIndexPathDisposable];
    [_disposableList addObject:editActionsForRowAtIndexPathDisposable];
    [_disposableList addObject:willSelectRowAtIndexPathDisposable];
    [_disposableList addObject:willDeselectRowAtIndexPathDisposable];
    [_disposableList addObject:shouldShowMenuForRowAtIndexPathDisposable];
    [_disposableList addObject:canPerformActionDisposable];
    [_disposableList addObject:performActionDisposable];
}

- (void)bindDisplay:(LPATableViewModel *)tableViewModel {
    @weakify(self)
    /// Display
    RACDisposable *willDisplayCellDisposable =
    [[[_tableViewModel.willDisplayCellSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewCell *cell = tuple.first;
        NSIndexPath *indexPath = tuple.second;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
            [self.lpaDelegate tableView:self willDisplayCell:cell forRowAtIndexPath:indexPath];
        }
    }];
    RACDisposable *willDisplayHeaderViewDisposable =
    [[[_tableViewModel.willDisplayHeaderViewSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UIView *view = tuple.first;
        NSInteger section = [tuple.second integerValue];
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
            [self.lpaDelegate tableView:self willDisplayHeaderView:view forSection:section];
        }
    }];
    RACDisposable *willDisplayFooterViewDisposable =
    [[[_tableViewModel.willDisplayFooterViewSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UIView *view = tuple.first;
        NSInteger section = [tuple.second integerValue];
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
            [self.lpaDelegate tableView:self willDisplayFooterView:view forSection:section];
        }
    }];
    RACDisposable *didEndDisplayingCellDisposable =
    [[[_tableViewModel.didEndDisplayingCellSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UITableViewCell *tableViewCell = tuple.first;
        NSIndexPath *indexPath = tuple.second;
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
            [self.lpaDelegate tableView:self didEndDisplayingCell:tableViewCell forRowAtIndexPath:indexPath];
        }
    }];
    RACDisposable *didEndDisplayingHeaderViewDisposable =
    [[[_tableViewModel.didEndDisplayingHeaderViewSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UIView *view = tuple.first;
        NSInteger section = [tuple.second integerValue];
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]) {
            [self.lpaDelegate tableView:self didEndDisplayingHeaderView:view forSection:section];
        }
    }];
    RACDisposable *didEndDisplayingFooterViewDisposable =
    [[[_tableViewModel.didEndDisplayingFooterViewSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UIView *view = tuple.first;
        NSInteger section = [tuple.second integerValue];
        if (self.lpaDelegate && [self.lpaDelegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]) {
            [self.lpaDelegate tableView:self didEndDisplayingFooterView:view forSection:section];
        }
    }];
    [_disposableList addObject:willDisplayCellDisposable];
    [_disposableList addObject:willDisplayHeaderViewDisposable];
    [_disposableList addObject:willDisplayFooterViewDisposable];
    [_disposableList addObject:didEndDisplayingCellDisposable];
    [_disposableList addObject:didEndDisplayingHeaderViewDisposable];
    [_disposableList addObject:didEndDisplayingFooterViewDisposable];
}

@end
