//
//  LPATableViewCell.m
//  Pods
//
//  Created by 平果太郎 on 2017/10/23.
//
//

#import "LPATableViewCell.h"

#import "LPATableViewManager.h"

@interface LPATableViewCell ()

@property (nonatomic, assign, readwrite) BOOL loaded;
@property (nonatomic, assign) BOOL fromXib;

@property (nonatomic, strong, readwrite) UIImageView *backgroundImageView;
@property (nonatomic, strong, readwrite) UIImageView *selectedBackgroundImageView;

@end

@implementation LPATableViewCell

#pragma mark - Class Methods

+ (BOOL)canFocusWithItem:(LPATableViewItem *)item {
    return NO;
}

+ (CGFloat)heightWithItem:(LPATableViewItem *)item tableViewManager:(LPATableViewManager *)tableViewManager {
    return item.cellHeight;
    
//    if ([item isKindOfClass:[LPATableViewItem class]] && item.cellHeight > 0)
//        return item.cellHeight;
//    
//    if ([item isKindOfClass:[LPATableViewItem class]] && item.cellHeight == 0)
//        return item.section.style.cellHeight;
//    
//    return tableViewManager.style.cellHeight;
}

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    self.fromXib = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)cellDidLoad {
    self.loaded = YES;
}

- (void)cellWillAppear {
//    if ([self.item isKindOfClass:[NSString class]]) {
//        self.textLabel.text = (NSString *)self.item;
//        self.textLabel.backgroundColor = [UIColor clearColor];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//    } else {
//        LPATableViewItem *item = (LPATableViewItem *)self.item;
//        self.textLabel.text = item.title;
//        self.textLabel.backgroundColor = [UIColor clearColor];
//        self.textLabel.textAlignment = item.textAlignment;
//        if (self.selectionStyle != UITableViewCellSelectionStyleNone)
//            self.selectionStyle = item.selectionStyle;
//        self.imageView.image = item.image;
//        self.imageView.highlightedImage = item.highlightedImage;
//    }
//    if (self.textLabel.text.length == 0) {
//        self.textLabel.text = @" ";
//
}

- (void)cellDidDisappear {
    
}

#pragma mark - Index Methods

- (NSIndexPath *)indexPathForPreviousResponderInSectionIndex:(NSUInteger)sectionIndex {
    LPATableViewSection *section = self.tableViewManager.sections[sectionIndex];
    NSUInteger indexInSection =  [section isEqual:self.section] ? [section.items indexOfObject:self.item] : section.items.count;
    for (NSInteger i = indexInSection - 1; i >= 0; i--) {
        LPATableViewItem *item = section.items[i];
        if ([item isKindOfClass:[LPATableViewItem class]]) {
            Class class = [self.tableViewManager classForCellAtIndexPath:item.indexPath];
            if ([class canFocusWithItem:item])
                return [NSIndexPath indexPathForRow:i inSection:sectionIndex];
        }
    }
    return nil;
}

- (NSIndexPath *)indexPathForPreviousResponder {
    for (NSInteger i = self.sectionIndex; i >= 0; i--) {
        NSIndexPath *indexPath = [self indexPathForPreviousResponderInSectionIndex:i];
        if (indexPath)
            return indexPath;
    }
    return nil;
}

- (NSIndexPath *)indexPathForNextResponderInSectionIndex:(NSUInteger)sectionIndex {
    LPATableViewSection *section = self.tableViewManager.sections[sectionIndex];
    NSUInteger indexInSection =  [section isEqual:self.section] ? [section.items indexOfObject:self.item] : -1;
    for (NSInteger i = indexInSection + 1; i < section.items.count; i++) {
        LPATableViewItem *item = section.items[i];
        if ([item isKindOfClass:[LPATableViewItem class]]) {
            Class class = [self.tableViewManager classForCellAtIndexPath:item.indexPath];
            if ([class canFocusWithItem:item])
                return [NSIndexPath indexPathForRow:i inSection:sectionIndex];
        }
    }
    return nil;
}

- (NSIndexPath *)indexPathForNextResponder {
    for (NSInteger i = self.sectionIndex; i < self.tableViewManager.sections.count; i++) {
        NSIndexPath *indexPath = [self indexPathForNextResponderInSectionIndex:i];
        if (indexPath)
            return indexPath;
    }
    return nil;
}

@end
