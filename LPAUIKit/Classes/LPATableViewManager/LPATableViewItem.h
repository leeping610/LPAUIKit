//
//  LPATableViewItem.h
//  Pods
//
//  Created by 平果太郎 on 2017/10/23.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const LPATableViewItemErrorDomain;
FOUNDATION_EXTERN NSInteger const LPATableViewItemErrorCode;
FOUNDATION_EXTERN NSString *const LPATableViewItemErrorDescription;

@class LPATableViewSection;

@interface LPATableViewItem : NSObject

// Properties
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, weak) LPATableViewSection *section;
@property (nonatomic, copy) NSString *detailLabelText;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong, readonly) NSIndexPath *indexPath;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;

// Error validation
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *validators;
@property (nonatomic, strong) NSError *error;

+ (instancetype)item;
+ (instancetype)itemWithTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title;

- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation;

@end
