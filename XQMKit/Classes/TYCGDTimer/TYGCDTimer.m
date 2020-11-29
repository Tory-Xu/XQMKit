//
//  TYCGDTimer.m
//  testGCDTimer
//
//  Created by Tory on 2019/8/4.
//  Copyright © 2019 imac. All rights reserved.
//

#import "TYGCDTimer.h"
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define LGString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define TYLog(...) printf("[WM CGDTimer] %s 第%d行: %s\n\n", [LGString UTF8String], __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define TYLog(...)
#endif

// 对象弱引用和强引用
#define TYWeakSelf(type) __weak typeof(type) weak##type = type;
#define TYStrongSelf(type) __strong typeof(type) strong##type = type;

@interface TYGCDTimer ()

@property (nonatomic, strong) dispatch_source_t skipTimer;

@property (nonatomic, strong) dispatch_queue_t queue;

/** 执行事件 */
@property (nonatomic, copy) void (^handle)(NSUInteger residueTimes);

/** 间隔时间，单位 s */
@property (readonly) NSTimeInterval timeInterval;
/** 开始时间，单位 s */
@property (nonatomic, assign) NSTimeInterval startTime;
/** 执行次数 */
@property (nonatomic, assign) NSInteger repeatTimes;
/** 剩余执行次数 */
@property (nonatomic, assign) NSInteger residueTimes;

/** 进入到后台的时间 */
@property (nonatomic, assign) CFAbsoluteTime enterBackgroundTime;

/** 进入后台定时器依然可用，defalue YES */
@property (nonatomic, assign) BOOL backgroundEnabel;
@property (nonatomic, strong) id didEnterBackgroundObsever;

@property (nonatomic, assign) BOOL isSuspend;

@end

@implementation TYGCDTimer

+ (instancetype)GCDTimerWithTimeInterval:(NSTimeInterval)ti
                               startTime:(NSTimeInterval)startTime
                             repeatTimes:(NSInteger)repeatTimes
                                   queue:(dispatch_queue_t)queue
                        backgroundEnabel:(BOOL)backgroundEnabel
                                  handle:(void (^)(NSUInteger residueTimes))handle {
    NSAssert(handle, @"没有设置 handle");
    NSAssert(repeatTimes >= 0, @"repeatTimes 不能小于 0");
    if (repeatTimes <= 0) {
        return nil;
    }
    
    TYGCDTimer *timer = [[[self class] alloc] initWithTimeInterval:ti
                                                         startTime:startTime
                                                       repeatTimes:repeatTimes
                                                             queue:queue
                                                  backgroundEnabel:backgroundEnabel
                                                            handle:handle];
    return timer;
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)ti
                           startTime:(NSTimeInterval)startTime
                         repeatTimes:(NSInteger)repeatTimes
                               queue:(dispatch_queue_t)queue
                    backgroundEnabel:(BOOL)backgroundEnabel
                              handle:(void (^)(NSUInteger residueTimes))handle {
    self = [super init];
    if (self) {
        _timeInterval = ti;
        _startTime = startTime;
        _repeatTimes = repeatTimes;
        if (queue) {
            _queue = queue;
        } else {
            _queue = dispatch_get_global_queue(0, 0);
        }
        self.backgroundEnabel = backgroundEnabel;
        _handle = handle;
    }
    return self;
}

- (BOOL)GCDTimerAvaliable {
    return self.skipTimer && !self.isSuspend;
}

- (void)setBackgroundEnabel:(BOOL)backgroundEnabel {
    if (_backgroundEnabel == backgroundEnabel) {
        return;
    }

    _backgroundEnabel = backgroundEnabel;

    if (backgroundEnabel && !self.didEnterBackgroundObsever) {
        TYWeakSelf(self);
        // 对象释放会自动移除监听
        self.didEnterBackgroundObsever = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *_Nonnull note) {
                                                          TYStrongSelf(weakself);
                                                          if (!strongweakself.skipTimer || strongweakself.isSuspend) {
                                                              return;
                                                          }
                                                          
                                                          TYLog(@"进入后台，剩余倒计时次数 %ld，停止定时器~", strongweakself.residueTimes);

                                                          strongweakself.enterBackgroundTime = CFAbsoluteTimeGetCurrent();
                                                          [strongweakself obseverEnterForgroundAndAdjustTimer];
                                                          [strongweakself suspend];
                                                      }];
    } else {
        if (self.didEnterBackgroundObsever) {
            [[NSNotificationCenter defaultCenter] removeObserver:self.didEnterBackgroundObsever];
            self.didEnterBackgroundObsever = nil;
        }
    }
}

- (void)fire {
    if (self.skipTimer) {
        return;
    }

    self.skipTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));

    dispatch_time_t start;
    if (self.startTime > 0.f) {
        start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.startTime * NSEC_PER_SEC));
    } else {
        start = dispatch_walltime(NULL, 0);
    }

    dispatch_source_set_timer(self.skipTimer, start, self.timeInterval * NSEC_PER_SEC, 0);

    TYWeakSelf(self);
    self.residueTimes = self.repeatTimes;
    dispatch_source_set_event_handler(self.skipTimer, ^{
        TYStrongSelf(weakself);
        if (!strongweakself) {
            return;
        }
        
        strongweakself.residueTimes--;
        TYLog(@"计时器执行剩余次数：%ld", strongweakself.residueTimes);
        if (strongweakself) {
            if (strongweakself.handle == nil) {
                return;
            }

            void (^handle)(void) = ^{
                strongweakself.handle(strongweakself.residueTimes);
                if (strongweakself.residueTimes <= 0) {
                    [strongweakself invalidate];
                }
            };

            if ([NSThread isMainThread]) {
                handle();
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handle();
                });
            }
        }
    });
    dispatch_resume(self.skipTimer);
}

- (void)reFire {
    if (self.skipTimer) {
        [self invalidate];
    }

    [self fire];
}

- (void)reFireWithRepeatTimes:(NSInteger)repeatTimes {
    if (self.skipTimer) {
        [self invalidate];
    }
    
    self.repeatTimes = repeatTimes;
    [self fire];
}

- (void)suspend {
    if (!self.skipTimer || self.isSuspend) {
        return;
    }

    self.isSuspend = YES;
    dispatch_suspend(self.skipTimer);
}

- (void)resume {
    if (self.skipTimer && self.isSuspend) {
        dispatch_resume(self.skipTimer);
        self.isSuspend = NO;
    }
}

- (void)invalidate {
    if (self.skipTimer) {
        TYLog(@"------ end timer -------");
        if (self.isSuspend) {
            [self resume];
        }
        dispatch_source_cancel(self.skipTimer);
        self.skipTimer = nil;
    }
}

#pragma mark - private

- (void)obseverEnterForgroundAndAdjustTimer {
    TYWeakSelf(self);
    __block NSObject *observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *_Nonnull note){
                                                      [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                      TYLog(@"进入前台，开始定时器~");
                                                      TYStrongSelf(weakself);
                                                      if (!strongweakself) {
                                                          return;
                                                      }
                                                      
                                                      NSInteger adjustTime = (NSUInteger)ceil(CFAbsoluteTimeGetCurrent() - strongweakself.enterBackgroundTime);
                                                      TYLog(@"时间矫正：进入后台时剩余倒计时时间 %ld, 后台停留时间 %ld，实际剩余倒计时时间 %ld", strongweakself.residueTimes, adjustTime, strongweakself.residueTimes - adjustTime);
                                                      strongweakself.residueTimes = MAX(strongweakself.residueTimes - adjustTime, 0);
                                                      if (strongweakself.residueTimes <= 0) {
                                                          strongweakself.handle(0);
                                                          [strongweakself invalidate];
                                                      } else {
                                                          [strongweakself resume];
                                                      }
                                                  }];
}

- (void)dealloc {
    [self invalidate];
    TYLog(@"%s", __func__);
}

@end

