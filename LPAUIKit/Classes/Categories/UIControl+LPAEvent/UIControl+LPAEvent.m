//
//  UIControl+LPAEvent.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/28.
//

#import "UIControl+LPAEvent.h"
#import <objc/runtime.h>

#define LPA_UICONTROL_EVENT(methodName, eventName)                                \
-(void)methodName : (void (^)(void))eventBlock {                              \
objc_setAssociatedObject(self, @selector(methodName:), eventBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);\
[self addTarget:self                                                        \
action:@selector(methodName##Action:)                                       \
forControlEvents:UIControlEvent##eventName];                                \
}                                                                               \
-(void)methodName##Action:(id)sender {                                        \
void (^block)(void) = objc_getAssociatedObject(self, @selector(methodName:));  \
if (block) {                                                                \
block();                                                                \
}                                                                           \
}

@implementation UIControl (LPAEvent)

LPA_UICONTROL_EVENT(lpa_touchDown, TouchDown)
LPA_UICONTROL_EVENT(lpa_touchDownRepeat, TouchDownRepeat)
LPA_UICONTROL_EVENT(lpa_touchDragInside, TouchDragInside)
LPA_UICONTROL_EVENT(lpa_touchDragOutside, TouchDragOutside)
LPA_UICONTROL_EVENT(lpa_touchDragEnter, TouchDragEnter)
LPA_UICONTROL_EVENT(lpa_touchDragExit, TouchDragExit)
LPA_UICONTROL_EVENT(lpa_touchUpInside, TouchUpInside)
LPA_UICONTROL_EVENT(lpa_touchUpOutside, TouchUpOutside)
LPA_UICONTROL_EVENT(lpa_touchCancel, TouchCancel)
LPA_UICONTROL_EVENT(lpa_valueChanged, ValueChanged)
LPA_UICONTROL_EVENT(lpa_editingDidBegin, EditingDidBegin)
LPA_UICONTROL_EVENT(lpa_editingChanged, EditingChanged)
LPA_UICONTROL_EVENT(lpa_editingDidEnd, EditingDidEnd)
LPA_UICONTROL_EVENT(lpa_editingDidEndOnExit, EditingDidEndOnExit)

@end
