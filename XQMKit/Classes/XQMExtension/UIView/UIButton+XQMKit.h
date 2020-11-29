//
//  UIButton+XQMKit.h
//  HeightLightButton
//
//  Created by againXu on 2017/2/6.
//  Copyright © 2017年 yang_0921. All rights reserved.
//

/**
 按钮的高亮状态
 */

typedef void(^AGStateDidChangedHandle)(UIButton *btn, UIControlState state);

#import <UIKit/UIKit.h>

/** 高亮默认颜色参数 */
#define HeightLightColorDefalutAlphaComponent 0.4f

@interface UIButton (HeightLightColor)

/** 正常状态颜色 */
@property (nonatomic, strong) UIColor *ag_normalColor;
/** 高亮状态颜色，如果没有设置，默认为 ag_normalColor 透明度 0.4 */
@property (nonatomic, strong) UIColor *ag_highlightedColor;

/** 正常状态border颜色 */
@property (nonatomic, strong) UIColor *ag_borderColorNormalColor;
/** 高亮状态border颜色，如果没有设置，默认为 ag_normalColor 透明度 0.4 */
@property (nonatomic, strong) UIColor *ag_borderColorHighlightedColor;

/** 按钮状态发生变化 */
@property (nonatomic, copy) AGStateDidChangedHandle ag_stateDidChangedHandle;

/** 开启监听按钮状态，如果没有开启，高亮效果无效 */
- (void)ag_addObserverForButtonHighlighted;

@end
