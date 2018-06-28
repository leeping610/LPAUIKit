//
//  LPATableViewItem.m
//  Pods
//
//  Created by 平果太郎 on 2017/10/23.
//
//

#import "LPATableViewItem.h"

#import "LPATableViewManager.h"
#import "LPATableViewSection.h"

NSString *const LPATableViewItemErrorDomain = @"RFPTableViewItemErrorDomain";
NSInteger const LPATableViewItemErrorCode = 12345;
NSString *const LPATableViewItemErrorDescription = @"RFPTableViewErrorDescription";

@interface LPATableViewItem ()

@end

@implementation LPATableViewItem

#pragma mark - Class Methods

+ (instancetype)item {
    return [[self alloc] init];
}

+ (instancetype)itemWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _enable = YES;
        _cellHeight = 44.0f;
        _selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        _title = title;
    }
    return self;
}

- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation {
    [self.section.tableViewManager.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:animation];
}

- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation {
    LPATableViewSection *section = self.section;
    NSInteger row = self.indexPath.row;
    [section removeItemAtIndex:self.indexPath.row];
    [section.tableViewManager.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section.index]] withRowAnimation:animation];
}

#pragma mark - Custom Accessors

- (NSIndexPath *)indexPath {
    return [NSIndexPath indexPathForRow:[self.section.items indexOfObject:self] inSection:self.section.index];
}

@end
