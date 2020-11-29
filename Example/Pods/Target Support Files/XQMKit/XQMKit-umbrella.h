#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSObject+XQMKit.h"
#import "UIButton+XQMKit.h"
#import "UILabel+XQMKit.h"
#import "UIView+XQMKit.h"
#import "XQMGCDTimer.h"
#import "XQMImageCache.h"
#import "XQMImageGIFTool.h"

FOUNDATION_EXPORT double XQMKitVersionNumber;
FOUNDATION_EXPORT const unsigned char XQMKitVersionString[];

