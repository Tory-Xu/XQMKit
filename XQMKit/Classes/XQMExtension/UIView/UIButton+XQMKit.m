//
//  UIButton+XQMKit.m
//  HeightLightButton
//
//  Created by againXu on 2017/2/6.
//  Copyright © 2017年 yang_0921. All rights reserved.
//

#import "UIButton+XQMKit.h"
#import "NSObject+XQMKit.h"

@interface UIButton ()

@property (nonatomic, assign, readonly) BOOL hasAddObserver; // 记录是否添加了监听

@end

@implementation UIButton (HeightLightColor)

+ (void)load {
    NSArray *selStringsArray = @[
        @"setEnabled:",
        @"dealloc"
    ];
    [self lg_swizzleInstanceMethodList:selStringsArray prefix:@"lg_"];
}

#pragma mark - public

- (void)ag_addObserverForButtonHighlighted {
    if (self.hasAddObserver) {
        return;
    }
    [self addObserver:self
           forKeyPath:@"highlighted"
              options:NSKeyValueObservingOptionNew
              context:nil];
    self.hasAddObserver = YES;
}

#pragma mark ================ over write ================

- (void)lg_dealloc {
    if (self.hasAddObserver) {
        [self removeObserver:self forKeyPath:@"highlighted"];
    }
    [self lg_dealloc];
}

/**
 *  点击按钮时：
 *      按钮设置 enabled = NO/YES，`highlighted` `state` 发生变化
 */
- (void)lg_setEnabled:(BOOL)enabled {
    [self lg_setEnabled:enabled];

    [self setButtonStyleColor];
}

#pragma mark - private

/**
 通过 button.state 无法监听，因此监听 highlighted
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {

    if (object == self && [keyPath isEqualToString:@"highlighted"]) {
        [self setButtonStyleColor];
    }
}

- (void)setButtonStyleColor {
    if (self.state == UIControlStateNormal) {
        if (self.ag_normalColor) {
            self.backgroundColor = self.ag_normalColor;
        }
        if (self.ag_borderColorNormalColor) {
            self.layer.borderColor = self.ag_borderColorNormalColor.CGColor;
        }
    } else if (self.state == UIControlStateHighlighted || self.state == UIControlStateDisabled) {
        if (self.ag_highlightedColor) {
            self.backgroundColor = self.ag_highlightedColor;
        }
        if (self.ag_borderColorHighlightedColor) {
            self.layer.borderColor = self.ag_borderColorHighlightedColor.CGColor;
        }
    }
    
    if (self.ag_stateDidChangedHandle) {
        self.ag_stateDidChangedHandle(self, self.state);
    }
}

#pragma mark - property

- (UIColor *)ag_normalColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAg_normalColor:(UIColor *)ag_normalColor {
    objc_setAssociatedObject(self, @selector(ag_normalColor), ag_normalColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.backgroundColor = ag_normalColor;
    
    if (self.ag_highlightedColor == nil) {
        self.ag_highlightedColor = [ag_normalColor colorWithAlphaComponent:HeightLightColorDefalutAlphaComponent];
    }
}

- (UIColor *)ag_highlightedColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAg_highlightedColor:(UIColor *)ag_highlightedColor {
    objc_setAssociatedObject(self, @selector(ag_highlightedColor), ag_highlightedColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIColor *)ag_borderColorNormalColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAg_borderColorNormalColor:(UIColor *)ag_borderColorNormalColor {
    objc_setAssociatedObject(self, @selector(ag_borderColorNormalColor), ag_borderColorNormalColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.layer.borderColor = ag_borderColorNormalColor.CGColor;
    
    if (self.ag_borderColorHighlightedColor == nil) {
        self.ag_borderColorHighlightedColor = [ag_borderColorNormalColor colorWithAlphaComponent:HeightLightColorDefalutAlphaComponent];
    }
}

- (UIColor *)ag_borderColorHighlightedColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAg_borderColorHighlightedColor:(UIColor *)ag_borderColorHighlightedColor {
    objc_setAssociatedObject(self, @selector(ag_borderColorHighlightedColor), ag_borderColorHighlightedColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)hasAddObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHasAddObserver:(BOOL)hasAddObserver {
    objc_setAssociatedObject(self, @selector(hasAddObserver), @(hasAddObserver), OBJC_ASSOCIATION_ASSIGN);
}

- (AGStateDidChangedHandle)ag_stateDidChangedHandle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAg_stateDidChangedHandle:(AGStateDidChangedHandle)ag_stateDidChangedHandle {
    objc_setAssociatedObject(self, @selector(ag_stateDidChangedHandle), ag_stateDidChangedHandle, OBJC_ASSOCIATION_COPY);
}

@end
