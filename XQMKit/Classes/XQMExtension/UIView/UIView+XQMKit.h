//
//  UIView+XQMKit.h
//  Legend
//
//  Created by againXu on 2017/8/15.
//  Copyright © 2017年 congacademy. All rights reserved.
//

// UI 点击事件接收范围

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@end

@interface UIView (LGResponseArea)

/** 用户设置按钮的点击区域边界 */
@property (nonatomic, assign) UIEdgeInsets ag_edgeInsets;

@end
