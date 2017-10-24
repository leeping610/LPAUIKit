//
//  LPATableViewManager.h
//  Pods
//
//  Created by 平果太郎 on 2017/10/23.
//
//

#import <Foundation/Foundation.h>

#import "LPATableViewCell.h"
#import "LPATableViewItem.h"
#import "LPATableViewSection.h"

@protocol LPATableViewManagerDelegate;

@interface LPATableViewManager : NSObject

@property (nonatomic, readonly, copy) NSArray *sections;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *registeredClasses;

@property (nonatomic, weak) id<LPATableViewManagerDelegate> delegate;
@property (strong, readonly, nonatomic) NSArray *errors;

- (instancetype)initWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView delegate:(id<LPATableViewManagerDelegate>)delegate;

- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle;
- (Class)classForCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns cell class at the keyed subscript.
 
 @param key The keyed subscript.
 @return The cell class the keyed subscript.
 */
- (id)objectAtKeyedSubscript:(id <NSCopying>)key;

/**
 Sets a cell class for the keyed subscript.
 
 @param obj The cell class to set for the keyed subscript.
 @param key The keyed subscript.
 */
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

///-----------------------------
/// @name Adding sections
///-----------------------------

- (void)addSection:(LPATableViewSection *)section;
- (void)addSectionsFromArray:(NSArray<LPATableViewSection *> *)array;
- (void)insertSection:(LPATableViewSection *)section atIndex:(NSUInteger)index;
- (void)insertSections:(NSArray<LPATableViewSection *> *)sections atIndexes:(NSIndexSet *)indexes;

///-----------------------------
/// @name Removing Sections
///-----------------------------

- (void)removeSection:(LPATableViewSection *)section;
- (void)removeAllSections;
- (void)removeSectionIdenticalTo:(LPATableViewSection *)section inRange:(NSRange)range;
- (void)removeSectionIdenticalTo:(LPATableViewSection *)section;
- (void)removeSectionsInArray:(NSArray<LPATableViewSection *> *)otherArray;
- (void)removeSectionsInRange:(NSRange)range;
- (void)removeSection:(LPATableViewSection *)section inRange:(NSRange)range;
- (void)removeLastSection;
- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(LPATableViewSection *)section;
- (void)replaceSectionsWithSectionsFromArray:(NSArray<LPATableViewSection *> *)otherArray;
- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray<LPATableViewSection *> *)sections;
- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray<LPATableViewSection *> *)otherArray range:(NSRange)otherRange;
- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray<LPATableViewSection *> *)otherArray;

///-----------------------------
/// @name Rearranging Sections
///-----------------------------

- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2;
- (void)sortSectionsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context;
- (void)sortSectionsUsingSelector:(SEL)comparator;

///-----------------------------
/// @name Util
///-----------------------------

- (NSIndexPath *)indexPathForItem:(id)item;

@end

@protocol LPATableViewManagerDelegate <UITableViewDelegate>

@optional

/*
 Tells the delegate the table view is about to layout a cell for a particular row.
 
 @param tableView The table-view object informing the delegate of this impending event.
 @param cell A table-view cell object that tableView is going to use when drawing the row.
 @param indexPath An index path locating the row in tableView.
 */
- (void)tableView:(UITableView *)tableView willLayoutCellSubviews:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 Tells the delegate the table view is about to create a cell for a particular row and make it reusable.
 
 @param tableView The table-view object informing the delegate of this impending event.
 @param cell A table-view cell object that tableView is going to create.
 @param indexPath An index path locating the row in tableView.
 */
- (void)tableView:(UITableView *)tableView willLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 Tells the delegate the table view has created a cell for a particular row and made it reusable.
 
 @param tableView The table-view object informing the delegate of this event.
 @param cell A table-view cell object that tableView has created.
 @param indexPath An index path locating the row in tableView.
 */
- (void)tableView:(UITableView *)tableView didLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
