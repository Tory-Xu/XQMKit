//
//  UIView+XQMKit.m
//  Legend
//
//  Created by againXu on 2017/8/15.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "UIView+XQMKit.h"
#import "NSObject+XQMKit.h"
#import <objc/runtime.h>

@implementation UIView (Frame)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

@end

@implementation UIView (LGResponseArea)

+ (void)load {
    NSArray *selStringsArray = @[
        @"hitTest:withEvent:",
        @"pointInside:withEvent:",
    ];
    [self lg_swizzleInstanceMethodList:selStringsArray prefix:@"ag_"];
}

- (UIView *)ag_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden || self.alpha < 0.01f) {
        return nil;
    }
    if (UIEdgeInsetsEqualToEdgeInsets(self.ag_edgeInsets, UIEdgeInsetsZero)) {
        return [self ag_hitTest:point withEvent:event];
    }

    CGPoint currentP = [self convertPoint:point toView:self];
    CGRect rect = CGRectMake(-self.ag_edgeInsets.left,
                             -self.ag_edgeInsets.top,
                             self.width + self.ag_edgeInsets.left + self.ag_edgeInsets.right,
                             self.height + self.ag_edgeInsets.top + self.ag_edgeInsets.bottom);

    if (CGRectContainsPoint(rect, currentP)) {
        if ([self isKindOfClass:[UISwitch class]]) {
            // UISwitch 接受事件的是子视图
            return self.subviews.firstObject;
        }
        return self;
    }

    return [self ag_hitTest:point withEvent:event];
}

- (BOOL)ag_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden || self.alpha < 0.01f) {
        return NO;
    }
    if (UIEdgeInsetsEqualToEdgeInsets(self.ag_edgeInsets, UIEdgeInsetsZero)) {
        return [self ag_pointInside:point withEvent:event];
    }

    CGPoint currentP = [self convertPoint:point toView:self];
    CGRect rect = CGRectMake(-self.ag_edgeInsets.left,
                             -self.ag_edgeInsets.top,
                             self.width + self.ag_edgeInsets.left + self.ag_edgeInsets.right,
                             self.height + self.ag_edgeInsets.top + self.ag_edgeInsets.bottom);
    if (CGRectContainsPoint(rect, currentP)) {
        return YES;
    }
    return [self ag_pointInside:point withEvent:event];
}

#pragma mark ================ Accession ================

- (UIEdgeInsets)ag_edgeInsets {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (void)setAg_edgeInsets:(UIEdgeInsets)ag_edgeInsets {
    objc_setAssociatedObject(self,
                             @selector(ag_edgeInsets),
                             [NSValue valueWithUIEdgeInsets:ag_edgeInsets],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
