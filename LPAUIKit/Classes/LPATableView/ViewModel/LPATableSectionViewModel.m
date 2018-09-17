//
//  LPATableSectionViewModel.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/29.
//

#import "LPATableSectionViewModel.h"

@interface LPATableSectionViewModel ()

@property (nonatomic, strong) NSMutableArray *mutableCellList;

@end

@implementation LPATableSectionViewModel

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _mutableCellList = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - LPATableSectionViewModel Protocol

- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel {
    [_mutableCellList addObject:cellViewModel];
}

- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList {
    [_mutableCellList addObjectsFromArray:cellViewModelList];
}

- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atIndex:(NSUInteger)index {
    if (index < _mutableCellList.count - 1) {
        [_mutableCellList insertObject:cellViewModel atIndex:index];
    }
}

- (void)insertCellViewMddelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atIndexes:(NSIndexSet *)indexSet {
    [_mutableCellList insertObjects:cellViewModelList atIndexes:indexSet];
}

- (void)removeCellViewModel:(id<LPATableSectionViewModelProtocol>)cellViewModel {
    [_mutableCellList removeObject:cellViewModel];
}

- (void)removeCellViewModelAtIndex:(NSUInteger)index {
    [_mutableCellList removeObjectAtIndex:index];
}

- (void)removeCellViewModelsAtRange:(NSRange)range {
    [_mutableCellList removeObjectsInRange:range];
}

- (void)removeCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atRange:(NSRange)range {
    [_mutableCellList removeObject:cellViewModel inRange:range];
}

- (void)removeCellViewModelsInArray:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList {
    [_mutableCellList removeObjectsInArray:cellViewModelList];
}

- (void)removeCellViewModelsInIndexes:(NSIndexSet *)indexSet {
    [_mutableCellList removeObjectsAtIndexes:indexSet];
}

- (void)removeAllCellViewModels {
    [_mutableCellList removeAllObjects];
}

#pragma mark - Custom Accessors

- (NSArray *)cellList {
    return [_mutableCellList copy];
}

@end
