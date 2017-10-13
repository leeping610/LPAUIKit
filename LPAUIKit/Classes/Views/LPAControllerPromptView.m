//
//  LPAControllerPromptView.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/13.
//

#import "LPAControllerPromptView.h"

@interface LPAControllerPromptView ()

@property (nonatomic, weak) UIView *promptView;

@end

@implementation LPAControllerPromptView

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view
{
    self = [super initWithFrame:view.bounds];
    if (self) {
        [view addSubview:self];
        [self setHidden:YES];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)showWithType:(LPAControllerPromptViewType)type
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(controllerPromptView:detailViewForType:)]) {
        // Get prompt view
        UIView *promptView = [self.delegate controllerPromptView:self
                                               detailViewForType:type];
        self.hidden = NO;
        if (promptView) {
            [self addSubview:promptView];
        }
    }
}

- (void)dismiss
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.hidden = YES;
}

@end
