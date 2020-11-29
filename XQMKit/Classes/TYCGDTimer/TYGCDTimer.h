//
//  TYCGDTimer.h
//  testGCDTimer
//
//  Created by Tory on 2019/8/4.
//  Copyright © 2019 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYGCDTimer : NSObject

/**
 创建 TYGCDTimer
 定时结束自动关闭；如果需要提前关闭，调用 - (void)invalidate 方法

 @param ti 时间间隔
 @param startTime 开始时间，定时器会在开始时间后进行
 @param repeatTimes 循环次数
 @param queue 队列，NULL 默认使用 dispatch_get_global_queue(0, 0);
 @param backgroundEnabel 是否能够在后台进行
 @param handle 执行事件（主线程）
 @return TYGCDTimer
 */
+ (instancetype)GCDTimerWithTimeInterval:(NSTimeInterval)ti
                               startTime:(NSTimeInterval)startTime
                             repeatTimes:(NSInteger)repeatTimes
                                   queue:(_Nullable dispatch_queue_t)queue
                        backgroundEnabel:(BOOL)backgroundEnabel
                                  handle:(void(^)(NSUInteger residueTimes))handle;

/**
 定时器执行中
 */
@property (nonatomic, assign, readonly) BOOL GCDTimerAvaliable;

- (void)setBackgroundEnabel:(BOOL)backgroundEnabel;

/**
 开始定时器
 */
- (void)fire;

/**
 从新开启定时器
 */
- (void)reFire;

/// 重新开启定时器，并重新设置循环次数
/// @param repeatTimes 循环次数
- (void)reFireWithRepeatTimes:(NSInteger)repeatTimes;

/**
 暂停
 */
- (void)suspend;

/**
 继续
 */
- (void)resume;

/**
 结束定时器
 */
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
