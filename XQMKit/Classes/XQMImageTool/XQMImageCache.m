//
//  XQMImageCache.m
//  NSCache
//
//  Created by yons on 16/11/9.
//  Copyright © 2016年 yons. All rights reserved.
//

#import "XQMImageCache.h"
#import "XQMImageGIFTool.h"

@interface XQMImageCache ()

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) dispatch_queue_t loadImageQueue;

@end

@implementation XQMImageCache

static XQMImageCache *obj = nil;

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[XQMImageCache alloc] init];
        NSCache *cache = [[NSCache alloc] init];
        cache.countLimit = 100;
        obj.cache = cache;
        obj.loadImageQueue = dispatch_queue_create("com.imageCache.loadImageQueue", DISPATCH_QUEUE_SERIAL);
    });
    return obj;
}

// 获取图片
- (void)imageWithUrlString:(NSString *)urlString complete:(void (^)(UIImage *image))complete {
    NSData *data = [self objectForKey:urlString];
    if (data) {
        complete([XQMImageGIFTool animatedGIFWithData:data]);
    } else {
        dispatch_async(self.loadImageQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            [self setObject:data forKey:urlString];
            UIImage *image = [XQMImageGIFTool animatedGIFWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(image);
            });
        });
    }
}

- (void)setObject:(id)value forKey:(NSString *)key {
    [self.cache setObject:value forKey:[key MD5]];
}

- (id)objectForKey:(NSString *)key {
    return [self.cache objectForKey:[key MD5]];
}

@end
