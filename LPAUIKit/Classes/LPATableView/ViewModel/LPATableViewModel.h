//
//  LPATableViewModel.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/29.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "LPATableCellViewModelProtocol.h"
#import "LPATableSectionViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPATableViewModel : NSObject 

@property (nonatomic, weak) id<UITableViewDelegate> tableViewDelegate;
@property (nonatomic, weak) id<UITableViewDataSource> tableViewDataSource;

@property (nonatomic, strong, readonly) RACSignal *reloadDataSignal;
@property (nonatomic, strong, readonly) RACSignal *scrollToRowAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *scrollToNearestSelectedRowSignal;
@property (nonatomic, strong, readonly) RACSignal *insertSectionsSignal;
@property (nonatomic, strong, readonly) RACSignal *deleteSectionsSignal;
@property (nonatomic, strong, readonly) RACSignal *replaceSectionsSignal;
@property (nonatomic, strong, readonly) RACSignal *reloadSectionsSignal;

@property (nonatomic, strong, readonly) RACSignal *insertRowsAtIndexPathsSignal;
@property (nonatomic, strong, readonly) RACSignal *deleteRowsAtIndexPathsSignal;
@property (nonatomic, strong, readonly) RACSignal *replaceRowsAtIndexPathsSignal;
@property (nonatomic, strong, readonly) RACSignal *reloadRowsAtIndexPathsSignal;

@property (nonatomic, strong, readonly) RACSignal *willDisplayCellSignal;
@property (nonatomic, strong, readonly) RACSignal *willDisplayHeaderViewSignal;
@property (nonatomic, strong, readonly) RACSignal *willDisplayFooterViewSignal;
@property (nonatomic, strong, readonly) RACSignal *didEndDisplayingCellSignal;
@property (nonatomic, strong, readonly) RACSignal *didEndDisplayingHeaderViewSignal;
@property (nonatomic, strong, readonly) RACSignal *didEndDisplayingFooterViewSignal;
@property (nonatomic, strong, readonly) RACSignal *didHighlightRowAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *didUnhighlightRowAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *didSelectRowAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *didDeselectRowAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *willBeginEditingRowAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *didEndEditingRowAtIndexPathSignal;

- (void)new NS_UNAVAILABLE;

///-----------------------------
/// @name Adding cells
///-----------------------------
- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel;
- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel toSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel;
- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel toSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel toSectionIndex:(NSUInteger)sectionIndex;
- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel toSectionIndex:(NSUInteger)sectionIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList;
- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList toSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel;
- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList toSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList toSectionIndex:(NSUInteger)sectionIndex;
- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList toSectionIndex:(NSUInteger)sectionIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation;

///-----------------------------
/// @name Insert cells
///-----------------------------
- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atRowIndex:(NSUInteger)rowIndex;
- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atRowIndex:(NSUInteger)rowIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)insertCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atRowIndex:(NSUInteger)rowIndex;
- (void)insertCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atRowIndex:(NSUInteger)rowIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel atRowIndex:(NSUInteger)rowIndex;
- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel atRowIndex:(NSUInteger)rowIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)insertCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel atRowIndex:(NSUInteger)rowIndex;
- (void)insertCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel atRowIndex:(NSUInteger)rowIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atSectionIndex:(NSUInteger)sectionIndex atRowIndex:(NSUInteger)rowIndex;
- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atSectionIndex:(NSUInteger)sectionIndex atRowIndex:(NSUInteger)rowIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)insertCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atSectionIndex:(NSUInteger)sectionIndex atRowIndex:(NSUInteger)rowIndex;
- (void)insertCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atSectionIndex:(NSUInteger)sectionIndex atRowIndex:(NSUInteger)rowIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation;

///-----------------------------
/// @name Removing cells
///-----------------------------
- (void)removeCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel;
- (void)removeCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)removeLastCellViewModel;
- (void)removeLastCellViewModelWithRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)removeCellViewModelAtIndex:(NSUInteger)index;
- (void)removeCellViewModelAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation;

///-----------------------------
/// @name Adding sections
///-----------------------------
- (void)addSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel;
- (void)addSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)insertSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel atIndex:(NSUInteger)index;
- (void)insertSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)addSectionViewModelList:(NSArray<id<LPATableSectionViewModelProtocol>> *)sectionViewModelList;
- (void)addSectionViewModelList:(NSArray<id<LPATableSectionViewModelProtocol>> *)sectionViewModelList withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)insertSectionViewModelList:(NSArray<id<LPATableSectionViewModelProtocol>> *)sectionViewModelList atIndex:(NSUInteger)index;
- (void)insertSectionViewModelList:(NSArray<id<LPATableSectionViewModelProtocol>> *)sectionViewModelList atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation;

///-----------------------------
/// @name Reload sections
///-----------------------------

- (void)reloadSectionWithSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel;
- (void)reloadSectionWithSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)reloadSectionAtIndex:(NSUInteger)index;
- (void)reloadSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)reloadSectionAtRange:(NSRange)range;
- (void)reloadSectionAtRange:(NSRange)range withRowAnimaion:(UITableViewRowAnimation)rowAnimation;

///-----------------------------
/// @name Removing Sections
///-----------------------------

- (void)removeAllSection;
- (void)removeAllSectionWithRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)removeSectionWithSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel;
- (void)removeSectionWithSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation;

///-----------------------------
/// @name Read
///-----------------------------
- (nullable NSIndexPath *)indexPathForCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel;
- (nullable id<LPATableCellViewModelProtocol>)cellViewModelForIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
