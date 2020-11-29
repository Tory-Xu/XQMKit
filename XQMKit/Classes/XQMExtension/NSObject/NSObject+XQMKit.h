//
//  NSObject+XQMKit.h
//  Legend
//
//  Created by againXu on 2017/10/25.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LGRuntime)

/**
 swizzle 类方法
 
 @param methodList 需要替换的方法名数组
 @param prefix     替换的方法前缀（替换的方法为“原方法+前缀”）
 */
+ (void)lg_swizzleInstanceMethodList:(NSArray<NSString *> *)methodList prefix:(NSString *)prefix;

/**
 swizzle 类方法
 
 @param oriSel 原有的方法
 @param swiSel swizzle的方法
 */
+ (void)lg_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

/**
 swizzle 实例方法
 
 @param oriSel 原有的方法
 @param swiSel swizzle的方法
 */
+ (void)lg_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

#pragma mark -

/**
 判断方法是否在子类里override了
 
 @param cls 传入要判断的Class
 @param sel 传入要判断的Selector
 @return 返回判断是否被重载的结果
 */
- (BOOL)lg_isMethodOverride:(Class)cls selector:(SEL)sel;

/**
 动态创建绑定selector的类
 tip：每当无法找到selectorcrash转发过来的所有selector都会追加到当前Class上
 
 @param aSelector 传入selector
 @return 返回创建的类
 */
+ (Class)lg_addMethodToStubClass:(SEL)aSelector;

@end

