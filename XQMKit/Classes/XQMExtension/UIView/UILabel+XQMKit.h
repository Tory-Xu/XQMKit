//
//  UILabel+XQMKit.h
//  PFIMCLientTalkU
//
//  Created by imac on 2018/10/9.
//  Copyright © 2018年 Dington. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 渐变文本，注：暂时不支持富文本 */
@interface UILabel (GradualText)

/** 渐变颜色，注意需要使用 CGColor 数组
    e.g. label.dt_textGradualColors = @[(id)DTColorOfRGB(0xFF7701).CGColor, (id)DTColorOfRGB(0xFE0526).CGColor];
 */
@property (nonatomic, copy) NSArray *dt_textGradualColors;

@end

#pragma mark ==================== iconfont ====================

typedef UILabel DTIconfontWidget;

@interface UILabel (iconfont)

+ (instancetype)widget;

+ (instancetype)iconWithName:(NSString *)iconName
                        size:(CGFloat)size
                       color:(UIColor *)color;

/**
 设置 icon
 
 @param iconName    图片名
 @param size        大小，icon 都是方形的一张图片
 @param color       颜色
 */
- (void)dt_iconName:(NSString *)iconName
               size:(CGFloat)size
              color:(UIColor *)color;

@end

#pragma mark ====================  ====================
