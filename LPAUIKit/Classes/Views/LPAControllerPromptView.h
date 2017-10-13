//
//  LPAControllerPromptView.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/13.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LPAControllerPromptViewType)
{
    LPAControllerPromptViewUnknow,
    LPAControllerPromptViewNetworkFailure,
    LPAControllerPromptViewNoData
};

@class LPAControllerPromptView;

@protocol LPAControllerPromptViewDelegate<NSObject>

@required

- (UIView *)controllerPromptView:(LPAControllerPromptView *)promptView
               detailViewForType:(LPAControllerPromptViewType)type;

@end

@interface LPAControllerPromptView : UIView

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, weak) id<LPAControllerPromptViewDelegate> delegate;

- (instancetype)initWithView:(UIView *)view;

- (void)showWithType:(LPAControllerPromptViewType)type;
- (void)dismiss;

@end
