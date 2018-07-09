//
//  LPATableViewModel.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/29.
//

#import "LPATableViewModel.h"
#import "LPATableSectionViewModel.h"

#import "LPATableViewCellProtocol.h"

#define LPA_TABLE_VIEWMODEL_RAC_SUBJECT(subjectName, signalName) \
- (RACSubject *)subjectName { \
    if (!_##subjectName) { \
        _##subjectName = [[RACSubject subject] setNameWithFormat:signalName]; \
    }\
    return _##subjectName; \
}

#define LPA_TABLE_VIEWMODEL_RAC_SINGAL(signalName, subjectName) \
- (RACSignal *)signalName { \
    return self.subjectName; \
}

@interface LPATableViewModel () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RACSubject *reloadDataSubject;
@property (nonatomic, strong) RACSubject *scrollToRowAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *scrollToNearestSelectedRowSubject;

@property (nonatomic, strong) RACSubject *insertSectionsSubject;
@property (nonatomic, strong) RACSubject *deleteSectionsSubject;
@property (nonatomic, strong) RACSubject *replaceSectionsSubject;
@property (nonatomic, strong) RACSubject *reloadSectionsSubject;

@property (nonatomic, strong) RACSubject *insertRowsAtIndexPathsSubject;
@property (nonatomic, strong) RACSubject *deleteRowsAtIndexPathsSubject;
@property (nonatomic, strong) RACSubject *replaceRowsAtIndexPathsSubject;
@property (nonatomic, strong) RACSubject *reloadRowsAtIndexPathsSubject;

@property (nonatomic, strong) RACSubject *willDisplayCellSubject;
@property (nonatomic, strong) RACSubject *willDisplayHeaderViewSubject;
@property (nonatomic, strong) RACSubject *willDisplayFooterViewSubject;
@property (nonatomic, strong) RACSubject *didEndDisplayingCellSubject;
@property (nonatomic, strong) RACSubject *didEndDisplayingHeaderViewSubject;
@property (nonatomic, strong) RACSubject *didEndDisplayingFooterViewSubject;
@property (nonatomic, strong) RACSubject *didHighlightRowAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *didUnhighlightRowAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *didSelectRowAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *didDeselectRowAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *willBeginEditingRowAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *didEndEditingRowAtIndexPathSubject;

@property (nonatomic, strong) NSMutableArray<id<LPATableSectionViewModelProtocol>> *sectionList;

@end

@implementation LPATableViewModel

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _sectionList = [[NSMutableArray alloc] init];
        _tableViewDelegate = self;
        _tableViewDataSource = self;
        /// Add default section
        LPATableSectionViewModel *sectionViewModel = [[LPATableSectionViewModel alloc] init];
        [_sectionList addObject:sectionViewModel];
    }
    return self;
}

#pragma mark - LPATableViewModelProtocol (Adding cells)

- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel {
    [self addCellViewModel:cellViewModel toSectionIndex:_sectionList.count - 1];
}

- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self addCellViewModel:cellViewModel toSectionIndex:_sectionList.count - 1 withRowAnimation:rowAnimation];
}

- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel toSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel {
    [self addCellViewModel:cellViewModel toSectionViewModel:sectionViewModel withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel toSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    if ([_sectionList containsObject:sectionViewModel]) {
        NSInteger sectionIndex = [_sectionList indexOfObject:sectionViewModel];
        [self addCellViewModel:cellViewModel toSectionIndex:sectionIndex withRowAnimation:rowAnimation];
    }
}

- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel toSectionIndex:(NSUInteger)sectionIndex {
    [self addCellViewModel:cellViewModel toSectionIndex:sectionIndex withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel toSectionIndex:(NSUInteger)sectionIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    if (sectionIndex < _sectionList.count) {
        LPATableSectionViewModel *sectionViewModel = _sectionList[sectionIndex];
        [sectionViewModel addCellViewModel:cellViewModel];
        /// Send signal
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sectionViewModel.cellList.count - 1
                                                    inSection:sectionIndex];
        NSArray *indexPathList = @[indexPath];
        [self.insertSectionsSubject sendNext:RACTuplePack(indexPathList, @(rowAnimation))];
    }
}

- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList {
    [self addCellViewModelList:cellViewModelList withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self addCellViewModelList:cellViewModelList toSectionIndex:_sectionList.count - 1 withRowAnimation:rowAnimation];
}

- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList toSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel {
    NSInteger sectionIndex = [_sectionList indexOfObject:sectionViewModel];
    [self addCellViewModelList:cellViewModelList toSectionIndex:sectionIndex];
}

- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList toSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSInteger sectionIndex = [_sectionList indexOfObject:sectionViewModel];
    [self addCellViewModelList:cellViewModelList toSectionIndex:sectionIndex withRowAnimation:rowAnimation];
}

- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList toSectionIndex:(NSUInteger)sectionIndex {
    [self addCellViewModelList:cellViewModelList toSectionIndex:sectionIndex withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList toSectionIndex:(NSUInteger)sectionIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    if (sectionIndex < _sectionList.count) {
        LPATableSectionViewModel *sectionViewModel = _sectionList[sectionIndex];
        [sectionViewModel addCellViewModelList:cellViewModelList];
        /// Send signal
        NSMutableArray *indexPathList = [[NSMutableArray alloc] init];
        [cellViewModelList enumerateObjectsUsingBlock:^(id<LPATableCellViewModelProtocol> cellViewModel, NSUInteger idx, BOOL *stop){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sectionViewModel.cellList.count + idx inSection:sectionIndex];
            [indexPathList addObject:indexPath];
        }];
        [self.insertSectionsSubject sendNext:RACTuplePack(indexPathList, @(rowAnimation))];
    }
}

#pragma mark - LPATableViewModelProtocol (Insert cells)

- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atRowIndex:(NSUInteger)rowIndex {
    [self insertCellViewModel:cellViewModel atRowIndex:rowIndex withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atRowIndex:(NSUInteger)rowIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self insertCellViewModel:cellViewModel atSectionIndex:_sectionList.count - 1 atRowIndex:rowIndex withRowAnimation:rowAnimation];
}

- (void)insertCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atRowIndex:(NSUInteger)rowIndex {
    [self insertCellViewModelList:cellViewModelList atRowIndex:rowIndex];
}

- (void)insertCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atRowIndex:(NSUInteger)rowIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self insertCellViewModelList:cellViewModelList atSectionIndex:_sectionList.count - 1 atRowIndex:rowIndex withRowAnimation:rowAnimation];
}

- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel atRowIndex:(NSUInteger)rowIndex {
    NSInteger sectionIndex = [_sectionList indexOfObject:sectionViewModel];
    [self insertCellViewModel:cellViewModel atSectionIndex:sectionIndex atRowIndex:rowIndex];
}

- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel atRowIndex:(NSUInteger)rowIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSInteger sectionIndex = [_sectionList indexOfObject:cellViewModel];
    [self insertCellViewModel:cellViewModel atSectionIndex:errSecItemNotFound atRowIndex:rowIndex withRowAnimation:rowAnimation];
}

- (void)insertCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel atRowIndex:(NSUInteger)rowIndex {
    [self insertCellViewModelList:cellViewModelList atSectionViewModel:sectionViewModel atRowIndex:rowIndex withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel atRowIndex:(NSUInteger)rowIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSInteger sectionIndex = [_sectionList indexOfObject:sectionViewModel];
    [self insertCellViewModelList:cellViewModelList atSectionIndex:sectionIndex atRowIndex:rowIndex withRowAnimation:rowAnimation];
}

- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atSectionIndex:(NSUInteger)sectionIndex atRowIndex:(NSUInteger)rowIndex {
    [self insertCellViewModel:cellViewModel atSectionIndex:sectionIndex atRowIndex:rowIndex withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel atSectionIndex:(NSUInteger)sectionIndex atRowIndex:(NSUInteger)rowIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    if (sectionIndex < _sectionList.count) {
        id<LPATableSectionViewModelProtocol> sectionViewModel = _sectionList[sectionIndex];
        if (rowIndex < sectionViewModel.cellList.count) {
            [sectionViewModel insertCellViewModel:cellViewModel atIndex:rowIndex];
            [self.insertRowsAtIndexPathsSubject sendNext:RACTuplePack(@[[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]],
                                                                      @(rowAnimation))];
        }
    }
}

- (void)insertCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atSectionIndex:(NSUInteger)sectionIndex atRowIndex:(NSUInteger)rowIndex {
    [self insertCellViewModelList:cellViewModelList atSectionIndex:sectionIndex atRowIndex:rowIndex];
}

- (void)insertCellViewModelList:(NSArray<id<LPATableCellViewModelProtocol>> *)cellViewModelList atSectionIndex:(NSUInteger)sectionIndex atRowIndex:(NSUInteger)rowIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    if (sectionIndex < _sectionList.count) {
        id<LPATableSectionViewModelProtocol> sectionViewModel = _sectionList[sectionIndex];
        if (rowIndex < sectionViewModel.cellList.count) {
            NSMutableArray *indexPathList = [[NSMutableArray alloc] init];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(rowIndex, cellViewModelList.count)];
            [sectionViewModel insertCellViewMddelList:cellViewModelList atIndexes:indexSet];
            [cellViewModelList enumerateObjectsUsingBlock:^(id<LPATableCellViewModelProtocol> cellViewModel, NSUInteger idx, BOOL *stop) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex + idx inSection:sectionIndex];
                [indexPathList addObject:indexPath];
            }];
            [self.insertRowsAtIndexPathsSubject sendNext:RACTuplePack(indexPathList, @(rowAnimation))];
        }
    }
}

#pragma mark - LPATableViewModelProtocol (Removing cells)

- (void)removeCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel {
    [self removeCellViewModel:cellViewModel withRowAnimation:UITableViewRowAnimationNone];
}

- (void)removeCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSInteger cellIndex = [_sectionList.lastObject.cellList indexOfObject:cellViewModel];
    [self removeCellViewModelAtIndex:cellIndex withRowAnimation:rowAnimation];
}

- (void)removeLastCellViewModel {
    [self removeLastCellViewModelWithRowAnimation:UITableViewRowAnimationNone];
}

- (void)removeLastCellViewModelWithRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self removeCellViewModelAtIndex:_sectionList.lastObject.cellList.count - 1
                    withRowAnimation:rowAnimation];
}

- (void)removeCellViewModelAtIndex:(NSUInteger)index {
    [self removeCellViewModelAtIndex:index withRowAnimation:UITableViewRowAnimationNone];
}

- (void)removeCellViewModelAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    id<LPATableSectionViewModelProtocol> sectionViewModel = _sectionList.lastObject;
    if (index < sectionViewModel.cellList.count) {
        [sectionViewModel removeCellViewModelAtIndex:index];
        [self.deleteRowsAtIndexPathsSubject sendNext:RACTuplePack(@[[NSIndexPath indexPathForRow:index inSection:_sectionList.count - 1]],
                                                                  @(rowAnimation))];
    }
}

#pragma mark - LPATableViewModelProtocol (Adding sections)

- (void)addSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel {
    [self addSectionViewModel:sectionViewModel withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self insertSectionViewModel:sectionViewModel atIndex:_sectionList.count - 1 withRowAnimation:@(rowAnimation)];
}

- (void)insertSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel atIndex:(NSUInteger)index {
    [self insertSectionViewModel:sectionViewModel atIndex:index withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    if (index < _sectionList.count) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
        [_sectionList insertObject:sectionViewModel atIndex:index];
        [self.insertSectionsSubject sendNext:RACTuplePack(indexSet, @(rowAnimation))];
    }
}

- (void)addSectionViewModelList:(NSArray<id<LPATableSectionViewModelProtocol>> *)sectionViewModelList {
    [self addSectionViewModelList:sectionViewModelList withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addSectionViewModelList:(NSArray<id<LPATableSectionViewModelProtocol>> *)sectionViewModelList withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self insertSectionViewModelList:sectionViewModelList atIndex:_sectionList.count - 1 withRowAnimation:@(rowAnimation)];
}

- (void)insertSectionViewModelList:(NSArray<id<LPATableSectionViewModelProtocol>> *)sectionViewModelList atIndex:(NSUInteger)index {
    [self insertSectionViewModelList:sectionViewModelList atIndex:index withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertSectionViewModelList:(NSArray<id<LPATableSectionViewModelProtocol>> *)sectionViewModelList atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, sectionViewModelList.count)];
    [_sectionList insertObjects:sectionViewModelList atIndexes:indexSet];
    [self.insertSectionsSubject sendNext:RACTuplePack(indexSet, @(rowAnimation))];
}

#pragma mark - LPATableViewModelProtocol (Reload sections)

- (void)reloadSectionWithSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel {
    [self reloadSectionWithSectionViewModel:sectionViewModel withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadSectionWithSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSInteger sectionIndex = [_sectionList indexOfObject:sectionViewModel];
    [self reloadSectionAtIndex:sectionIndex withRowAnimation:rowAnimation];
}

- (void)reloadSectionAtIndex:(NSUInteger)index {
    [self reloadSectionAtIndex:index withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self.reloadSectionsSubject sendNext:RACTuplePack([NSIndexSet indexSetWithIndex:index], @(rowAnimation))];
}

- (void)reloadSectionAtRange:(NSRange)range {
    [self reloadSectionAtRange:range withRowAnimaion:UITableViewRowAnimationNone];
}

- (void)reloadSectionAtRange:(NSRange)range withRowAnimaion:(UITableViewRowAnimation)rowAnimation {
    if (_sectionList.count < range.location + range.length) {
        NSIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndexesInRange:range];
        [self.reloadSectionsSubject sendNext:RACTuplePack(indexSet, @(rowAnimation))];
    }
}

#pragma mark - LPATableViewModelProtocol (Removing Sections)

- (void)removeAllSection {
    [self removeAllSectionWithRowAnimation:UITableViewRowAnimationNone];
}

- (void)removeAllSectionWithRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [_sectionList removeAllObjects];
    [self.reloadDataSubject sendNext:nil];
}

- (void)removeSectionWithSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel {
    [self removeSectionWithSectionViewModel:sectionViewModel withRowAnimation:UITableViewRowAnimationNone];
}

- (void)removeSectionWithSectionViewModel:(id<LPATableSectionViewModelProtocol>)sectionViewModel withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSInteger sectionIndex = [_sectionList indexOfObject:sectionViewModel];
    [self removeSectionAtIndex:sectionIndex withRowAnimation:rowAnimation];
}

- (void)removeSectionAtIndex:(NSUInteger)index {
    [self removeSectionAtIndex:index withRowAnimation:UITableViewRowAnimationNone];
}

- (void)removeSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    if (_sectionList.count < index) {
        [_sectionList removeObjectAtIndex:index];
        [self.deleteSectionsSubject sendNext:RACTuplePack([NSIndexSet indexSetWithIndex:index], @(rowAnimation))];
    }
}

#pragma mark - LPATableViewModelProtocol (Reading)

- (nullable NSIndexPath *)indexPathForCellViewModel:(id<LPATableCellViewModelProtocol>)cellViewModel {
    __block NSIndexPath *indexPath = nil;
    [_sectionList enumerateObjectsUsingBlock:^(id<LPATableSectionViewModelProtocol> sectionViewModel, NSUInteger idx, BOOL *stop) {
        if ([sectionViewModel.cellList containsObject:cellViewModel]) {
            NSInteger cellIndex = [sectionViewModel.cellList indexOfObject:cellViewModel];
            indexPath = [NSIndexPath indexPathForRow:cellIndex inSection:idx];
            *stop = YES;
        }
    }];
    return indexPath;
}

- (nullable id<LPATableCellViewModelProtocol>)cellViewModelForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _sectionList.count) {
        LPATableSectionViewModel *sectionViewModel = _sectionList[indexPath.section];
        if (indexPath.row < sectionViewModel.cellList.count) {
            id<LPATableCellViewModelProtocol> cellViewModel = sectionViewModel.cellList[indexPath.row];
            return cellViewModel;
        }
    }
    return nil;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sectionList[section].cellList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<LPATableSectionViewModelProtocol> sectionViewModel = _sectionList[indexPath.section];
    id<LPATableCellViewModelProtocol> cellViewModel = sectionViewModel.cellList[indexPath.row];
    /// Cell identifier
    NSString *cellIdentifier = [NSString stringWithFormat:@"LPATableViewCell_%@", NSStringFromClass(cellViewModel.reuseViewClass)];
    if ([cellViewModel respondsToSelector:@selector(cellIdentifier)]) {
        cellIdentifier = cellViewModel.cellIdentifier;
    }
    /// Register cell to tableView
    Class cellClass = [UITableViewCell class];
    if ([cellViewModel respondsToSelector:@selector(reuseViewClass)]) {
        cellClass = cellViewModel.reuseViewClass;
        NSBundle *cellBundle = [NSBundle bundleForClass:cellViewModel.reuseViewClass];
        NSString *cellNibPath = [cellBundle pathForResource:NSStringFromClass(cellViewModel.reuseViewClass) ofType:@"nib"];
        if (cellNibPath) {
            [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(cellViewModel.reuseViewClass) bundle:cellBundle] forCellReuseIdentifier:cellIdentifier];
        }else {
            [tableView registerClass:cellViewModel.reuseViewClass forCellReuseIdentifier:cellIdentifier];
        }
    }
    /// Return tableView cell
    id<LPATableViewCellProtocol> cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
        if ([cellViewModel respondsToSelector:@selector(tableViewCellStyle)]) {
            cellStyle = cellViewModel.tableViewCellStyle;
        }
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
        if ([cell respondsToSelector:@selector(cellDidLoad)]) {
            [cell cellDidLoad];
        }
    }
    if ([cell respondsToSelector:@selector(bindViewModel:)]) {
        [cell bindViewModel:cellViewModel];
    }
    if ([cell respondsToSelector:@selector(cellWillAppear)]) {
        [cell cellWillAppear];
    }
    /// Set tableViewCell property
    UITableViewCell *tableViewCell = (UITableViewCell *)cell;
    if ([cellViewModel respondsToSelector:@selector(titleText)]) {
        tableViewCell.textLabel.text = cellViewModel.titleText;
    }
    if ([cellViewModel respondsToSelector:@selector(detailText)]) {
        tableViewCell.detailTextLabel.text = cellViewModel.detailText;
    }
    if ([cellViewModel respondsToSelector:@selector(separatorInset)]) {
        tableViewCell.separatorInset = cellViewModel.separatorInset;
    }
    if ([cellViewModel respondsToSelector:@selector(tableViewCellSelectionStyle)]) {
        tableViewCell.selectionStyle = cellViewModel.tableViewCellSelectionStyle;
    }
    if ([cellViewModel respondsToSelector:@selector(tableViewCellAccessoryType)]) {
        tableViewCell.accessoryType = cellViewModel.tableViewCellAccessoryType;
    }
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<LPATableCellViewModelProtocol> cellViewModel = [self cellViewModelForIndexPath:indexPath];
    if ([cellViewModel respondsToSelector:@selector(estimatedHeight)]) {
        return cellViewModel.estimatedHeight;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    id<LPATableSectionViewModelProtocol> sectionViewModel = _sectionList[section];
    if ([sectionViewModel respondsToSelector:@selector(sectionEstimatedHeightForHeader)]) {
        return sectionViewModel.sectionEstimatedHeightForHeader;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    id<LPATableSectionViewModelProtocol> sectionViewModel = _sectionList[section];
    if ([sectionViewModel respondsToSelector:@selector(sectionEstimatedHeightForFooter)]) {
        return sectionViewModel.sectionEstimatedHeightForFooter;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<LPATableCellViewModelProtocol> cellViewModel = [self cellViewModelForIndexPath:indexPath];
    if ([cellViewModel respondsToSelector:@selector(cellHeight)]) {
        return cellViewModel.cellHeight;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id<LPATableSectionViewModelProtocol> sectionViewModel = _sectionList[section];
    if ([sectionViewModel respondsToSelector:@selector(sectionHeightForHeader)]) {
        return sectionViewModel.sectionHeightForHeader;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    id<LPATableSectionViewModelProtocol> sectionViewModel = _sectionList[section];
    if ([sectionViewModel respondsToSelector:@selector(sectionHeightForFooter)]) {
        return sectionViewModel.sectionHeightForFooter;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
}

#pragma mark - RACSignal

LPA_TABLE_VIEWMODEL_RAC_SINGAL(reloadDataSignal, reloadDataSubject)
LPA_TABLE_VIEWMODEL_RAC_SINGAL(scrollToRowAtIndexPathSignal, scrollToRowAtIndexPathSubject)
LPA_TABLE_VIEWMODEL_RAC_SINGAL(scrollToNearestSelectedRowSignal, scrollToNearestSelectedRowSubject)
LPA_TABLE_VIEWMODEL_RAC_SINGAL(insertSectionsSignal, insertSectionsSubject)
LPA_TABLE_VIEWMODEL_RAC_SINGAL(deleteSectionsSignal, deleteSectionsSubject)
LPA_TABLE_VIEWMODEL_RAC_SINGAL(replaceSectionsSignal, replaceSectionsSubject)
LPA_TABLE_VIEWMODEL_RAC_SINGAL(reloadSectionsSignal, reloadSectionsSubject)
LPA_TABLE_VIEWMODEL_RAC_SINGAL(insertRowsAtIndexPathsSignal, insertRowsAtIndexPathsSubject)
LPA_TABLE_VIEWMODEL_RAC_SINGAL(deleteRowsAtIndexPathsSignal, deleteRowsAtIndexPathsSubject)
LPA_TABLE_VIEWMODEL_RAC_SINGAL(replaceRowsAtIndexPathsSignal, replaceRowsAtIndexPathsSubject)
LPA_TABLE_VIEWMODEL_RAC_SINGAL(reloadRowsAtIndexPathsSignal, reloadRowsAtIndexPathsSubject)

#pragma mark - Custom Accessors

LPA_TABLE_VIEWMODEL_RAC_SUBJECT(reloadDataSubject, @"reloadDataSignal")
LPA_TABLE_VIEWMODEL_RAC_SUBJECT(scrollToRowAtIndexPathSubject, @"scrollToRowAtIndexPathSignal")
LPA_TABLE_VIEWMODEL_RAC_SUBJECT(scrollToNearestSelectedRowSubject, @"scrollToNearestRowSignal")
LPA_TABLE_VIEWMODEL_RAC_SUBJECT(insertSectionsSubject, @"insertSectionsSignal")
LPA_TABLE_VIEWMODEL_RAC_SUBJECT(deleteSectionsSubject, @"deleteSectionSignal")
LPA_TABLE_VIEWMODEL_RAC_SUBJECT(replaceSectionsSubject, @"replaceSectionSignal")
LPA_TABLE_VIEWMODEL_RAC_SUBJECT(reloadSectionsSubject, @"reloadSectionSignal")
LPA_TABLE_VIEWMODEL_RAC_SUBJECT(insertRowsAtIndexPathsSubject, @"insertRowsAtIndexPathSignal")
LPA_TABLE_VIEWMODEL_RAC_SUBJECT(deleteRowsAtIndexPathsSubject, @"deleteRowsAtIndexPathsSignal")
LPA_TABLE_VIEWMODEL_RAC_SUBJECT(replaceRowsAtIndexPathsSubject, @"replaceRowsAtIndexPathsSignal")
LPA_TABLE_VIEWMODEL_RAC_SUBJECT(reloadRowsAtIndexPathsSubject, @"reloadRowsAtIndexPathsSignal")

@end
