//
//  AGImageCache.h
//  NSCache
//
//  Created by yons on 16/11/9.
//  Copyright © 2016年 yons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kAGImageCache(key) [NSString stringWithFormat:@"ag_imageCache%@", key]
#define kAGGifInfoCache(key) [NSString stringWithFormat:@"ag_gifInfoCache%@", key]

@interface AGImageCache : NSObject

+ (instancetype)share;

// 获取图片
- (void)imageWithUrlString:(NSString *)urlString complete:(void (^)(UIImage *image))complete;

- (void)setObject:(id)value forKey:(NSString *)key;

- (id)objectForKey:(NSString *)key;

@end
