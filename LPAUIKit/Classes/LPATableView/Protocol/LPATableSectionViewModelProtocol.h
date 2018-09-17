//
//  LPATableSectionViewModelProtocol.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/29.
//

#import <Foundation/Foundation.h>
#import "LPATableCellViewModelProtocol.h"

@protocol LPATableSectionViewModelProtocol <NSObject>

@required

/// cellViewModel数组
@property (nonatomic, copy, readonly) NSArray<id<LPATableCellViewModelProtocol>> *cellList;

///-----------------------------
/// @name Adding Items
///-----------------------------

- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel;
- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList;

- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atIndex:(NSUInteger)index;
- (void)insertCellViewMddelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atIndexes:(NSIndexSet *)indexSet;

///-----------------------------
/// @name Removing Items
///-----------------------------

- (void)removeCellViewModel:(id<LPATableSectionViewModelProtocol>)cellViewModel;
- (void)removeCellViewModelAtIndex:(NSUInteger)index;
- (void)removeCellViewModelsAtRange:(NSRange)range;
- (void)removeCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atRange:(NSRange)range;
- (void)removeCellViewModelsInArray:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList;
- (void)removeCellViewModelsInIndexes:(NSIndexSet *)indexSet;
- (void)removeAllCellViewModels;

///-----------------------------
/// @name Replacing Items
///-----------------------------

- (void)replaceCellViewModelAtIndex:(NSUInteger)index withCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel;
- (void)replaceAllCellViewModelsFromArray:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList;
- (void)replaceCellViewModelsAtIndexes:(NSIndexSet *)indexSet withCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList;


@optional

///-----------------------------
/// @name Optional property
///-----------------------------

- (NSString *)sectionHeaderTitle;
- (NSString *)sectionFooterTitle;

- (UIView *)sectionHeaderView;
- (UIView *)sectionFooterView;
- (CGFloat)sectionHeightForHeader;
- (CGFloat)sectionHeightForFooter;
- (CGFloat)sectionEstimatedHeightForHeader;
- (CGFloat)sectionEstimatedHeightForFooter;

@end
