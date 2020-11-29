//
//  UILabel+XQMKit.m
//  PFIMCLientTalkU
//
//  Created by imac on 2018/10/9.
//  Copyright © 2018年 Dington. All rights reserved.
//
// 实现：https://www.jianshu.com/p/fe06704e11a0

#import "UILabel+XQMKit.h"
#import "NSObject+XQMKit.h"

#pragma mark -

@interface UILabel ()

@property (nonatomic, strong) CAGradientLayer *dt_textGradientLayer;
@property (nonatomic, strong) UILabel *dt_label;

@end

@implementation UILabel (GradualText)

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.dt_textGradualColors) {
        // 创建渐变层
        if (self.dt_textGradientLayer == nil) {
            self.dt_textGradientLayer = [CAGradientLayer layer];
            self.dt_textGradientLayer.startPoint = CGPointMake(0, 0);
            self.dt_textGradientLayer.endPoint = CGPointMake(1, 0);
            [self.layer addSublayer:self.dt_textGradientLayer];

            self.dt_label = [[UILabel alloc] init];
            self.dt_label.font = self.font;
            self.dt_label.numberOfLines = self.numberOfLines;
            self.dt_label.textAlignment = self.textAlignment;
            [self addSubview:self.dt_label];

            self.dt_textGradientLayer.mask = self.dt_label.layer;

            // 渐变层颜色随机
            self.dt_textGradientLayer.colors = self.dt_textGradualColors;
            self.textColor = [UIColor clearColor];
        }
        self.dt_label.text = self.text;
        self.dt_textGradientLayer.frame = self.bounds;
        // 注意:一旦把label层设置为mask层，label层就不能显示了,会直接从父层中移除，然后作为渐变层的mask层，且label层的父层会指向渐变层
        // 父层改了，坐标系也就改了，需要重新设置label的位置，才能正确的设置裁剪区域。
        self.dt_label.frame = self.dt_textGradientLayer.bounds;
    }
}

#pragma mark - setter & getter

- (NSArray *)dt_textGradualColors {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDt_textGradualColors:(NSArray *)dt_textGradualColors {
    objc_setAssociatedObject(self,
                             @selector(dt_textGradualColors),
                             dt_textGradualColors,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CAGradientLayer *)dt_textGradientLayer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDt_textGradientLayer:(CAGradientLayer *)dt_textGradientLayer {
    objc_setAssociatedObject(self,
                             @selector(dt_textGradientLayer),
                             dt_textGradientLayer,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)dt_label {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDt_label:(UILabel *)dt_label {
    objc_setAssociatedObject(self,
                             @selector(dt_label),
                             dt_label,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark ==================== iconfont ====================

@implementation UILabel (iconfont)

+ (instancetype)widget {
    DTIconfontWidget *widget = [[DTIconfontWidget alloc] init];
    return widget;
}

+ (instancetype)iconWithName:(NSString *)iconName
                        size:(CGFloat)size
                       color:(UIColor *)color {
    DTIconfontWidget *widget = [[DTIconfontWidget alloc] init];
    widget.text = iconName;
    widget.font = DTIconfont(size);
    widget.textColor = color;
    return widget;
}

- (void)dt_iconName:(NSString *)iconName
               size:(CGFloat)size
              color:(UIColor *)color {
    self.text = iconName;
    self.font = DTIconfont(size);
    self.textColor = color;
}

@end

#pragma mark ====================  ====================
