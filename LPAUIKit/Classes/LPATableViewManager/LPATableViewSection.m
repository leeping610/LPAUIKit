//
//  LPATableViewSection.m
//  Pods
//
//  Created by 平果太郎 on 2017/10/23.
//
//

#import "LPATableViewSection.h"

#import "LPATableViewManager.h"
#import "LPATableViewItem.h"

CGFloat const LPATableViewSectionHeaderHeightAutomatic = DBL_MAX;
CGFloat const LPATableViewSectionFooterHeightAutomatic = DBL_MAX;

@interface LPATableViewSection ()

@property (nonatomic, strong) NSMutableArray *mutableItems;

@end

@implementation LPATableViewSection

#pragma mark - Class Methods

+ (instancetype)section {
    return [[self alloc] init];
}

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle {
    return [[self alloc] initWithTitle:headerTitle];
}

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle {
    return [[self alloc] initWithHeaderTitle:headerTitle footerTitle:footerTitle];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView {
    return [[self alloc] initWithHeaderView:headerView];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView {
    return [[self alloc] initWithHeaderView:headerView footerView:footerView];
}

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _mutableItems = [NSMutableArray array];
        _headerHeight = LPATableViewSectionHeaderHeightAutomatic;
        _footerHeight = LPATableViewSectionFooterHeightAutomatic;
        _cellTitlePadding = 5.0f;
    }
    return self;
}

- (instancetype)initWithHeaderTitle:(NSString *)headerTitle {
    self = [self init];
    if (self) {
        _headerTitle = headerTitle;
    }
    return self;
}

- (instancetype)initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle {
    self = [self initWithHeaderTitle:headerTitle];
    if (self) {
        _footerTitle = footerTitle;
    }
    return self;
}

- (instancetype)initWithHeaderView:(UIView *)headerView {
    self = [self init];
    if (self) {
        _headerView = headerView;
    }
    return self;
}

- (instancetype)initWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView {
    self = [self initWithHeaderView:headerView];
    if (self) {
        _footerView = footerView;
    }
    return self;
}

#pragma mark - Reading Information

- (NSUInteger)index {
    LPATableViewManager *tableViewManager = self.tableViewManager;
    return [tableViewManager.sections indexOfObject:self];
}

#pragma mark - Managing Items

- (NSArray *)items {
    return _mutableItems;
}

- (void)addItem:(id)item {
    if ([item isKindOfClass:[LPATableViewItem class]]) {
        ((LPATableViewItem *)item).section = self;
    }
    [_mutableItems addObject:item];
}

- (void)addItemsFromArray:(NSArray *)array {
    [array enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop){
        [self addItem:item];
    }];
}

- (void)insertItem:(id)item atIndex:(NSUInteger)index {
    if ([item isKindOfClass:[LPATableViewItem class]]) {
        ((LPATableViewItem *)item).section = self;
    }
    [_mutableItems insertObject:item atIndex:index];
}

- (void)insertItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes {
    [items enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop){
        if ([item isKindOfClass:[LPATableViewItem class]]) {
            ((LPATableViewItem *)item).section = self;
        }
    }];
    [_mutableItems insertObjects:items atIndexes:indexes];
}

- (void)removeItem:(id)item inRange:(NSRange)range {
    [_mutableItems removeObject:item inRange:range];
}

- (void)removeLastItem {
    [_mutableItems removeLastObject];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    [_mutableItems removeObjectAtIndex:index];
}

- (void)removeItem:(id)item {
    [_mutableItems removeObject:item];
}

- (void)removeAllItems {
    [_mutableItems removeAllObjects];
}

- (void)removeItemIdenticalTo:(id)item inRange:(NSRange)range {
    [_mutableItems removeObjectIdenticalTo:item inRange:range];
}

- (void)removeItemIdenticalTo:(id)item {
    [_mutableItems removeObjectIdenticalTo:item];
}

- (void)removeItemsInArray:(NSArray *)otherArray {
    [_mutableItems removeObjectsInArray:otherArray];
}

- (void)removeItemsInRange:(NSRange)range {
    [_mutableItems removeObjectsInRange:range];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes {
    [_mutableItems removeObjectsAtIndexes:indexes];
}

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(id)item {
    if ([item isKindOfClass:[LPATableViewItem class]]){
        ((LPATableViewItem *)item).section = self;
    }
    [_mutableItems replaceObjectAtIndex:index withObject:item];
}

- (void)replaceItemsWithItemsFromArray:(NSArray *)otherArray {
    [self removeAllItems];
    [self addItemsFromArray:otherArray];
}

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray *)otherArray range:(NSRange)otherRange {
    [otherArray enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop){
        if ([item isKindOfClass:[LPATableViewItem class]]) {
            ((LPATableViewItem *)item).section = self;
        }
    }];
    [_mutableItems replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray *)otherArray {
    [otherArray enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop){
        if ([item isKindOfClass:[LPATableViewItem class]]) {
            ((LPATableViewItem *)item).section = self;
        }
    }];
    [_mutableItems replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)items {
    [items enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop){
        if ([item isKindOfClass:[LPATableViewItem class]]) {
            ((LPATableViewItem *)item).section = self;
        }
    }];
    [_mutableItems replaceObjectsAtIndexes:indexes withObjects:items];
}

- (void)exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2 {
    [self.mutableItems exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortItemsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context {
    [_mutableItems sortUsingFunction:compare context:context];
}

- (void)sortItemsUsingSelector:(SEL)comparator {
    [_mutableItems sortUsingSelector:comparator];
}

#pragma mark - Manipulating table view section

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation {
    [_tableViewManager.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.index] withRowAnimation:animation];
}

#pragma mark - Checking for errors

- (NSArray *)errors {
    __block NSMutableArray *errors = [NSMutableArray array];
    [_mutableItems enumerateObjectsUsingBlock:^(LPATableViewItem *item, NSUInteger idx, BOOL *stop){
        if ([item respondsToSelector:@selector(error)]) {
            NSError *itemError = item.error;
            if (itemError) {
                [errors addObject:itemError];
            }
        }
    }];
    return errors;
}

@end
