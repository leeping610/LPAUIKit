//
//  LPATableViewManager.m
//  Pods
//
//  Created by 平果太郎 on 2017/10/23.
//
//

#import "LPATableViewManager.h"

@interface LPATableViewManager () <UITableViewDataSource,
                                   UITableViewDelegate>

@property (nonatomic, readwrite, copy) NSArray *sections;
@property (nonatomic, strong) NSMutableArray *mutableSections;
@property (nonatomic, strong) NSMutableDictionary *registeredXIBs;

@property (nonatomic, assign) CGFloat defaultTableViewSectionHeight;

@end

@implementation LPATableViewManager

#pragma mark - Life Cycle

- (instancetype)init {
    @throw [NSException exceptionWithName:NSGenericException reason:@"init not supported, use initWithTableView: instead." userInfo:nil];
    return nil;
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // Init arrays
        _sections = [NSArray array];
        _mutableSections = [NSMutableArray array];
        _registeredXIBs = [NSMutableDictionary dictionary];
        _registeredClasses = [NSMutableDictionary dictionary];
        // Default init
        [self registerDefaultClasses];
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView delegate:(id<LPATableViewManagerDelegate>)delegate {
    self = [self initWithTableView:tableView];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)registerDefaultClasses {
    self[@"LPATableViewItem"] = @"LPATableViewCell";
    self[@"__NSCFConstantString"] = @"LPATableViewCell";
    self[@"__NSCFString"] = @"LPATableViewCell";
    self[@"NSString"] = @"LPATableViewCell";
}

- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self registerClass:objectClass forCellWithReuseIdentifier:identifier bundle:nil];
}

- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle {
    NSAssert(NSClassFromString(objectClass), ([NSString stringWithFormat:@"Item class '%@' does not exist.", objectClass]));
    NSAssert(NSClassFromString(identifier), ([NSString stringWithFormat:@"Cell class '%@' does not exist.", identifier]));
    _registeredClasses[(id <NSCopying>)NSClassFromString(objectClass)] = NSClassFromString(identifier);
    
    // Perform check if a XIB exists with the same name as the cell class
    //
    if (!bundle)
        bundle = [NSBundle mainBundle];
    
    if ([bundle pathForResource:identifier ofType:@"nib"]) {
        _registeredXIBs[identifier] = objectClass;
        [_tableView registerNib:[UINib nibWithNibName:identifier bundle:bundle]
         forCellReuseIdentifier:objectClass];
    }
}

- (Class)classForCellAtIndexPath:(NSIndexPath *)indexPath {
    LPATableViewSection *section = _mutableSections[indexPath.section];
    NSObject *item = section.items[indexPath.row];
    return _registeredClasses[item.class];
}

- (id)objectAtKeyedSubscript:(id<NSCopying>)key {
    return _registeredClasses[key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    [self registerClass:(NSString *)key forCellWithReuseIdentifier:obj];
}

- (void)dealloc {
    _delegate = nil;
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

#pragma mark - Managing sections

- (void)addSection:(LPATableViewSection *)section {
    section.tableViewManager = self;
    [_mutableSections addObject:section];
}

- (void)addSectionsFromArray:(NSArray<LPATableViewSection *> *)array {
    [array enumerateObjectsUsingBlock:^(LPATableViewSection *section, NSUInteger idx, BOOL *stop){
        [self addSection:section];
    }];
}

- (void)insertSection:(LPATableViewSection *)section atIndex:(NSUInteger)index {
    section.tableViewManager = self;
    [_mutableSections insertObject:section atIndex:index];
}

- (void)insertSections:(NSArray<LPATableViewSection *> *)sections atIndexes:(NSIndexSet *)indexes {
    [sections enumerateObjectsUsingBlock:^(LPATableViewSection *section, NSUInteger idx, BOOL *stop){
        section.tableViewManager = self;
    }];
    [_mutableSections insertObjects:sections atIndexes:indexes];
}

- (void)removeSection:(LPATableViewSection *)section {
    [_mutableSections removeObject:section];
}

- (void)removeAllSections {
    [_mutableSections removeAllObjects];
}

- (void)removeSectionIdenticalTo:(LPATableViewSection *)section inRange:(NSRange)range {
    [_mutableSections removeObjectIdenticalTo:section inRange:range];
}

- (void)removeSectionIdenticalTo:(LPATableViewSection *)section {
    [_mutableSections removeObjectIdenticalTo:section];
}

- (void)removeSectionsInArray:(NSArray *)otherArray {
    [_mutableSections removeObjectsInArray:otherArray];
}

- (void)removeSectionsInRange:(NSRange)range {
    [_mutableSections removeObjectsInRange:range];
}

- (void)removeSection:(LPATableViewSection *)section inRange:(NSRange)range {
    [_mutableSections removeObject:section inRange:range];
}

- (void)removeLastSection {
    [_mutableSections removeLastObject];
}

- (void)removeSectionAtIndex:(NSUInteger)index {
    [_mutableSections removeObjectAtIndex:index];
}

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes {
    [_mutableSections removeObjectsAtIndexes:indexes];
}

- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(LPATableViewSection *)section {
    section.tableViewManager = self;
    [_mutableSections replaceObjectAtIndex:index withObject:section];
}

- (void)replaceSectionsWithSectionsFromArray:(NSArray *)otherArray {
    [self removeAllSections];
    [self addSectionsFromArray:otherArray];
}

- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray *)sections {
    [sections enumerateObjectsUsingBlock:^(LPATableViewSection *section, NSUInteger idx, BOOL *stop){
        section.tableViewManager = self;
    }];
    [_mutableSections replaceObjectsAtIndexes:indexes withObjects:sections];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray range:(NSRange)otherRange {
    [otherArray enumerateObjectsUsingBlock:^(LPATableViewSection *section, NSUInteger idx, BOOL *stop){
        section.tableViewManager = self;
    }];
    [_mutableSections replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray {
    [_mutableSections replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2 {
    [_mutableSections exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortSectionsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context {
    [_mutableSections sortUsingFunction:compare context:context];
}

- (void)sortSectionsUsingSelector:(SEL)comparator {
    [_mutableSections sortUsingSelector:comparator];
}

- (NSIndexPath *)indexPathForItem:(id)item {
    for (LPATableViewSection *section in _mutableSections) {
        for (id existItem in section.items) {
            if (existItem == item) {
                return [NSIndexPath indexPathForRow:[section.items indexOfObject:existItem]
                                          inSection:[_mutableSections indexOfObject:section]];
            }
        }
    }
    return nil;
}

#pragma mark - Checking for errors

- (NSArray *)errors {
    __block NSMutableArray *errors;
    [_mutableSections enumerateObjectsUsingBlock:^(LPATableViewSection *section, NSUInteger idx, BOOL *stop){
        NSArray *sectionErrors = section.errors;
        if (sectionErrors) {
            if (!errors) {
                errors = [[NSMutableArray alloc] init];
            }
            [errors addObjectsFromArray:sectionErrors];
        }
    }];
    return errors;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _mutableSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_mutableSections.count <= section) {
        return 0;
    }
    return ((LPATableViewSection *)_mutableSections[section]).items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPATableViewSection *section = _mutableSections[indexPath.section];
    LPATableViewItem *item = section.items[indexPath.row];
    
    UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
    if ([item isKindOfClass:[LPATableViewItem class]]) {
        //        cellStyle = ((LPATableViewItem *)item).style;
    }
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"RETableViewManager_%@_%li", [item class], (long) cellStyle];
    
    Class cellClass = [self classForCellAtIndexPath:indexPath];
    
    if (_registeredXIBs[NSStringFromClass(cellClass)]) {
        cellIdentifier = _registeredXIBs[NSStringFromClass(cellClass)];
    }
    
    if ([item respondsToSelector:@selector(cellIdentifier)] && item.cellIdentifier) {
        cellIdentifier = item.cellIdentifier;
    }
    
    LPATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    void (^loadCell)(LPATableViewCell *cell) = ^(LPATableViewCell *cell) {
        cell.tableViewManager = self;
        
        // RETableViewManagerDelegate
        //
        if ([self.delegate conformsToProtocol:@protocol(LPATableViewManagerDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willLoadCell:forRowAtIndexPath:)])
            [self.delegate tableView:tableView willLoadCell:cell forRowAtIndexPath:indexPath];
        
        [cell cellDidLoad];
        
        // RETableViewManagerDelegate
        //
        if ([self.delegate conformsToProtocol:@protocol(LPATableViewManagerDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didLoadCell:forRowAtIndexPath:)])
            [self.delegate tableView:tableView didLoadCell:cell forRowAtIndexPath:indexPath];
    };
    
    if (cell == nil) {
        cell = [[cellClass alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
        
        loadCell(cell);
    }
    
    if ([cell isKindOfClass:[LPATableViewCell class]] && [cell respondsToSelector:@selector(loaded)] && !cell.loaded) {
        loadCell(cell);
    }
    
    cell.rowIndex = indexPath.row;
    cell.sectionIndex = indexPath.section;
    cell.parentTableView = tableView;
    cell.section = section;
    cell.item = item;
    cell.detailTextLabel.text = nil;
    
    if ([item isKindOfClass:[LPATableViewItem class]])
        cell.detailTextLabel.text = ((LPATableViewItem *)item).detailLabelText;
    
    [cell cellWillAppear];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPATableViewSection *section = _mutableSections[indexPath.section];
    id item = section.items[indexPath.row];
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    CGFloat height = [[self classForCellAtIndexPath:indexPath] heightWithItem:item tableViewManager:self];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_mutableSections.count <= indexPath.section) {
        return UITableViewAutomaticDimension;
    }
    LPATableViewSection *section = _mutableSections[indexPath.section];
    
    id item = section.items[indexPath.row];
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)])
        return [self.delegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    
    CGFloat height = [[self classForCellAtIndexPath:indexPath] heightWithItem:item tableViewManager:self];
    
    return height ? height : UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex {
    if (_mutableSections.count <= sectionIndex) {
        return UITableViewAutomaticDimension;
    }
    
    LPATableViewSection *section = _mutableSections[sectionIndex];
    if (section.headerHeight != LPATableViewSectionHeaderHeightAutomatic) {
        return section.headerHeight;
    }
    
    if (section.headerView) {
        return section.headerView.frame.size.height;
    } else if (section.headerTitle.length) {
        if (!UITableViewStyleGrouped) {
            return self.defaultTableViewSectionHeight;
        } else {
            CGFloat headerHeight = 0;
            CGFloat headerWidth = CGRectGetWidth(CGRectIntegral(tableView.bounds)) - 40.0f; // 40 = 20pt horizontal padding on each side
            
            CGSize headerRect = CGSizeMake(headerWidth, LPATableViewSectionHeaderHeightAutomatic);
            
            CGRect headerFrame = [section.headerTitle boundingRectWithSize:headerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline] }
                                                                   context:nil];
            
            headerHeight = headerFrame.size.height;
            
            return headerHeight + 20.0f;
        }
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
        return [self.delegate tableView:tableView heightForHeaderInSection:sectionIndex];
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex {
    if (self.mutableSections.count <= sectionIndex) {
        return UITableViewAutomaticDimension;
    }
    LPATableViewSection *section = self.mutableSections[sectionIndex];
    
    if (section.footerHeight != LPATableViewSectionFooterHeightAutomatic) {
        return section.footerHeight;
    }
    
    if (section.footerView) {
        return section.footerView.frame.size.height;
    } else if (section.footerTitle.length) {
        if (!UITableViewStyleGrouped) {
            return self.defaultTableViewSectionHeight;
        } else {
            CGFloat footerHeight = 0;
            CGFloat footerWidth = CGRectGetWidth(CGRectIntegral(tableView.bounds)) - 40.0f; // 40 = 20pt horizontal padding on each side
            
            CGSize footerRect = CGSizeMake(footerWidth, LPATableViewSectionFooterHeightAutomatic);
            
            CGRect footerFrame = [section.footerTitle boundingRectWithSize:footerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] }
                                                                   context:nil];
            
            footerHeight = footerFrame.size.height;
            
            return footerHeight + 10.0f;
        }
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
        return [self.delegate tableView:tableView heightForFooterInSection:sectionIndex];
    
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex {
    if (_mutableSections.count <= sectionIndex) {
        return nil;
    }
    LPATableViewSection *section = _mutableSections[sectionIndex];
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
        return [self.delegate tableView:tableView viewForHeaderInSection:sectionIndex];
    
    return section.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIndex {
    if (_mutableSections.count <= sectionIndex) {
        return nil;
    }
    LPATableViewSection *section = _mutableSections[sectionIndex];
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
        return [self.delegate tableView:tableView viewForFooterInSection:sectionIndex];
    
    return section.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.delegate scrollViewDidScroll:self.tableView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidZoom:)])
        [self.delegate scrollViewDidZoom:self.tableView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [self.delegate scrollViewWillBeginDragging:self.tableView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        [self.delegate scrollViewWillEndDragging:self.tableView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [self.delegate scrollViewDidEndDragging:self.tableView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [self.delegate scrollViewWillBeginDecelerating:self.tableView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [self.delegate scrollViewDidEndDecelerating:self.tableView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [self.delegate scrollViewDidEndScrollingAnimation:self.tableView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
        return [self.delegate viewForZoomingInScrollView:self.tableView];
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
        [self.delegate scrollViewWillBeginZooming:self.tableView withView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [self.delegate scrollViewDidEndZooming:self.tableView withView:view atScale:scale];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
        return [self.delegate scrollViewShouldScrollToTop:self.tableView];
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [self.delegate scrollViewDidScrollToTop:self.tableView];
}

#pragma mark - Custom Accessors

- (NSArray *)sections {
    return _mutableSections;
}

@end
