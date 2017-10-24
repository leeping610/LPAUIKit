//
//  LPATableViewCell.h
//  Pods
//
//  Created by 平果太郎 on 2017/10/23.
//
//

#import <UIKit/UIKit.h>

#import "LPATableViewItem.h"
#import "LPATableViewSection.h"

@class LPATableViewManager;

@interface LPATableViewCell : UITableViewCell

///-----------------------------
/// @name Accessing Table View and Table View Manager
///

@property (nonatomic, weak, readwrite) UITableView *parentTableView;
@property (nonatomic, weak, readwrite) LPATableViewManager *tableViewManager;

///-----------------------------
/// @name Accessing Row and Section
///-----------------------------

@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, weak) LPATableViewSection *section;
@property (nonatomic, strong) LPATableViewItem *item;
@property (nonatomic, assign, readonly) BOOL loaded;

+ (BOOL)canFocusWithItem:(LPATableViewItem *)item;
+ (CGFloat)heightWithItem:(LPATableViewItem *)item
         tableViewManager:(LPATableViewManager *)tableViewManager;

- (void)cellDidLoad;
- (void)cellWillAppear;
- (void)cellDidDisappear;

@end
