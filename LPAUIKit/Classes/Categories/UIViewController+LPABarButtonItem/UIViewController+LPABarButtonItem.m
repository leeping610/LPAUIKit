//
//  UIViewController+LPABarButtonItem.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/28.
//

#import "UIViewController+LPABarButtonItem.h"
#import "UIControl+LPAEvent.h"
#import <objc/runtime.h>

static void *kLPAViewControllerBarButtonItemFontKey = &kLPAViewControllerBarButtonItemFontKey;

@implementation UIViewController (LPABarButtonItem)

@dynamic lpa_barItemFont;

#pragma mark - Life Cycle

- (void)lpa_addLeftBarButtonItemWithText:(NSString *)leftBarButtonText handlerBlock:(LPABarButtonItemHandlerBlock)handlerBlock {
    UIBarButtonItem *barButtonItem = [self __barButtonItemWithText:leftBarButtonText handlerBlock:handlerBlock];
    self.navigationItem.leftBarButtonItems = @[[self __spaceBarButtonItem], barButtonItem];
}

- (void)lpa_addLeftBarButtonItemWithTextList:(NSArray *)leftBarButtonTextList handlerBlockList:(NSArray<LPABarButtonItemHandlerBlock> *)handlerBlockList {
    NSMutableArray *barButtomItemList = [[NSMutableArray alloc] init];
    if (leftBarButtonTextList.count == handlerBlockList.count) {
        [leftBarButtonTextList enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL *stop) {
            UIBarButtonItem *barButtonItem = [self __barButtonItemWithText:text handlerBlock:handlerBlockList[idx]];
            [barButtomItemList addObject:barButtonItem];
        }];
    }
    if (barButtomItemList.count) {
        [barButtomItemList insertObject:[self __spaceBarButtonItem] atIndex:0];
    }
    self.navigationItem.leftBarButtonItems = barButtomItemList;
}

- (void)lpa_addLeftBarButtonItemWithImage:(UIImage *)leftBarButtonImage handlerBlock:(LPABarButtonItemHandlerBlock)handlerBlock {
    UIBarButtonItem *barButtonItem = [self __barButtonItemWithImage:leftBarButtonImage handlerBlock:handlerBlock];
    self.navigationItem.leftBarButtonItems = @[[self __spaceBarButtonItem], barButtonItem];
}

- (void)lpa_addLeftBarButtonItemWithImageList:(NSArray<UIImage *> *)leftBarButtonImageList handlerBlock:(NSArray<LPABarButtonItemHandlerBlock> *)handlerBlockList {
    NSMutableArray *barButtomItemList = [[NSMutableArray alloc] init];
    if (leftBarButtonImageList.count == handlerBlockList.count) {
        [leftBarButtonImageList enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
            UIBarButtonItem *barButtonItem = [self __barButtonItemWithImage:image handlerBlock:handlerBlockList[idx]];
            [barButtomItemList addObject:barButtonItem];
        }];
    }
    if (barButtomItemList.count) {
        [barButtomItemList insertObject:[self __spaceBarButtonItem] atIndex:0];
    }
    self.navigationItem.leftBarButtonItems = barButtomItemList;
}

- (void)lpa_addRightBarButtonItemWithText:(NSString *)rightBarButtonText handlerBlock:(LPABarButtonItemHandlerBlock)handlerBlock {
    UIBarButtonItem *barButtonItem = [self __barButtonItemWithText:rightBarButtonText handlerBlock:handlerBlock];
    self.navigationItem.rightBarButtonItems = @[barButtonItem, [self __spaceBarButtonItem]];
}

- (void)lpa_addRightBarButtonItemWithTextList:(NSArray *)rightBarButtonTextList handlerBlockList:(NSArray<LPABarButtonItemHandlerBlock> *)handlerBlockList {
    NSMutableArray *barButtomItemList = [[NSMutableArray alloc] init];
    if (rightBarButtonTextList.count == handlerBlockList.count) {
        [rightBarButtonTextList enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL *stop) {
            UIBarButtonItem *barButtonItem = [self __barButtonItemWithText:text handlerBlock:handlerBlockList[idx]];
            [barButtomItemList addObject:barButtonItem];
        }];
    }
    if (barButtomItemList.count) {
        [barButtomItemList insertObject:[self __spaceBarButtonItem] atIndex:0];
    }
    self.navigationItem.rightBarButtonItems = barButtomItemList;
}

- (void)lpa_addRightBarButtonItemWithImage:(UIImage *)rightBarButtonImage handlerBlock:(LPABarButtonItemHandlerBlock)handlerBlock {
    UIBarButtonItem *barButtonItem = [self __barButtonItemWithImage:rightBarButtonImage handlerBlock:handlerBlock];
    self.navigationItem.rightBarButtonItems = @[barButtonItem, [self __spaceBarButtonItem]];
}

- (void)lpa_addRightBarButtonItemWithImageList:(NSArray<UIImage *> *)rightBarButtonImageList handlerBlock:(NSArray<LPABarButtonItemHandlerBlock> *)handlerBlockList {
    NSMutableArray *barButtomItemList = [[NSMutableArray alloc] init];
    if (rightBarButtonImageList.count == handlerBlockList.count) {
        [rightBarButtonImageList enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
            UIBarButtonItem *barButtonItem = [self __barButtonItemWithImage:image handlerBlock:handlerBlockList[idx]];
            [barButtomItemList addObject:barButtonItem];
        }];
    }
    if (barButtomItemList.count) {
        [barButtomItemList insertObject:[self __spaceBarButtonItem] atIndex:0];
    }
    self.navigationItem.rightBarButtonItems = barButtomItemList;
}

- (void)lpa_removeLeftBarButtonItem {
    [self.navigationItem setLeftBarButtonItems:nil animated:NO];
    [self.navigationItem setLeftBarButtonItems:nil animated:NO];
    [self.navigationItem setLeftBarButtonItems:nil animated:NO];
}

- (void)lpa_removeRightBarButtonItem {
    [self.navigationItem setRightBarButtonItems:nil animated:NO];
    [self.navigationItem setRightBarButtonItems:nil animated:NO];
    [self.navigationItem setRightBarButtonItems:nil animated:NO];
}

#pragma mark - Private Methods

- (UIBarButtonItem *)__barButtonItemWithText:(NSString *)text handlerBlock:(LPABarButtonItemHandlerBlock)handlerBlock {
    UIButton *barButton = [self __barButtonWithText:text];
    [barButton lpa_touchUpInside:^{
        if (handlerBlock) {
            handlerBlock(barButton);
        }
    }];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    return barButtonItem;
}

- (UIBarButtonItem *)__barButtonItemWithImage:(UIImage *)image handlerBlock:(LPABarButtonItemHandlerBlock)handlerBlock {
    UIButton *barButton = [self __barButtonWithImage:image];
    [barButton lpa_touchUpInside:^{
        if (handlerBlock) {
            handlerBlock(barButton);
        }
    }];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    return barButtonItem;
}

- (UIButton *)__barButtonWithText:(NSString *)text {
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [barButton setTintColor:self.navigationController.navigationBar.tintColor];
    [barButton.titleLabel setFont:self.lpa_barItemFont];
    [barButton setTitle:text
               forState:UIControlStateNormal];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: self.lpa_barItemFont,
                                 NSParagraphStyleAttributeName: paragraph};
    CGSize stringSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 22)
                                           options:(NSStringDrawingUsesLineFragmentOrigin |
                                                    NSStringDrawingTruncatesLastVisibleLine)
                                        attributes:attributes
                                           context:nil].size;
    [barButton setFrame:CGRectMake(0, 0, stringSize.width, 22)];
    return barButton;
}

- (UIButton *)__barButtonWithImage:(UIImage *)image {
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setFrame:CGRectMake(0, 0, 22, 22)];
    [barButton setImage:image
               forState:UIControlStateNormal];
    return barButton;
}

- (UIBarButtonItem *)__spaceBarButtonItem {
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
    spaceButtonItem.width = -12.0f;
    return spaceButtonItem;
}

#pragma mark - Custom Accessors

- (UIFont *)lpa_barItemFont {
    UIFont *font = objc_getAssociatedObject(self, kLPAViewControllerBarButtonItemFontKey);
    if (!font) {
        font = [UIFont systemFontOfSize:14];
    }
    return font;
}

- (void)setLpa_barItemFont:(UIFont *)lpa_barItemFont {
    if (lpa_barItemFont) {
        objc_setAssociatedObject(self, kLPAViewControllerBarButtonItemFontKey, lpa_barItemFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
