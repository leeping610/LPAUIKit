//
//  UIViewController+LPABarButtonItem.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LPABarButtonItemHandlerBlock)(UIButton *barButton);

@interface UIViewController (LPABarButtonItem)

@property (nonatomic, strong) UIFont *lpa_barItemFont;

- (void)lpa_addLeftBarButtonItemWithText:(NSString *)leftBarButtonText
                            handlerBlock:(LPABarButtonItemHandlerBlock)handlerBlock;
- (void)lpa_addLeftBarButtonItemWithTextList:(NSArray *)leftBarButtonTextList
                            handlerBlockList:(NSArray<LPABarButtonItemHandlerBlock> *)handlerBlockList;

- (void)lpa_addLeftBarButtonItemWithImage:(UIImage *)leftBarButtonImage
                             handlerBlock:(LPABarButtonItemHandlerBlock)handlerBlock;
- (void)lpa_addLeftBarButtonItemWithImageList:(NSArray<UIImage *> *)leftBarButtonImageList
                                 handlerBlock:(NSArray<LPABarButtonItemHandlerBlock> *)handlerBlockList;

- (void)lpa_addRightBarButtonItemWithText:(NSString *)rightBarButtonText
                             handlerBlock:(LPABarButtonItemHandlerBlock)handlerBlock;
- (void)lpa_addRightBarButtonItemWithTextList:(NSArray *)rightBarButtonTextList
                             handlerBlockList:(NSArray<LPABarButtonItemHandlerBlock> *)handlerBlockList;

- (void)lpa_addRightBarButtonItemWithImage:(UIImage *)rightBarButtonImage
                              handlerBlock:(LPABarButtonItemHandlerBlock)handlerBlock;
- (void)lpa_addRightBarButtonItemWithImageList:(NSArray<UIImage *> *)rightBarButtonImageList
                                  handlerBlock:(NSArray<LPABarButtonItemHandlerBlock> *)handlerBlockList;

@end

NS_ASSUME_NONNULL_END
