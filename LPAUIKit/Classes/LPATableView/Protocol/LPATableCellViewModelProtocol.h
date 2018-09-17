//
//  LPATableCellViewModelProtocol.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/29.
//

#import <Foundation/Foundation.h>

@protocol LPATableCellViewModelProtocol <NSObject>

@required

- (Class)reuseViewClass;
- (NSString *)cellIdentifier;

@optional

- (CGFloat)cellHeight;
- (CGFloat)estimatedHeight;

- (NSString *)detailText;
- (NSString *)titleText;
- (UIEdgeInsets)separatorInset;
- (UITableViewCellStyle)tableViewCellStyle;
- (UITableViewCellSelectionStyle)tableViewCellSelectionStyle;
- (UITableViewCellAccessoryType)tableViewCellAccessoryType;
- (UITableViewCellEditingStyle)tableViewCellEditingStyle;
- (NSString *)titleForDeleteConfirmationButton;

- (BOOL)tableViewCellshouldHighlight;
- (BOOL)canEditRow;
- (BOOL)canMoveRow;

- (BOOL)shouldIndentWhileEditing;
- (NSInteger)indentationLevelForRowAtIndexPath;

@end
