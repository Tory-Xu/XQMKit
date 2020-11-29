//
//  NSObject+XQMKit.m
//  Legend
//
//  Created by againXu on 2017/10/25.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "NSObject+XQMKit.h"
#import <objc/runtime.h>

char * const kProtectCrashProtectorName = "kProtectCrashProtector";

void ProtectCrashProtected(id self, SEL sel) {
}


@implementation NSObject (LGRuntime)

+ (void)lg_swizzleInstanceMethodList:(NSArray<NSString *> *)methodList prefix:(NSString *)prefix {
    [methodList enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
        NSString *mySelString = [prefix stringByAppendingString:selString];
        Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
        Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
        method_exchangeImplementations(originalMethod, myMethod);
    }];
}

+ (void)lg_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Class cls = object_getClass(self);
    
    Method originAddObserverMethod = class_getClassMethod(cls, oriSel);
    Method swizzledAddObserverMethod = class_getClassMethod(cls, swiSel);
    
    [self lg_swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:cls];
}

+ (void)lg_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self lg_swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:self];
}

+ (void)lg_swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}

#pragma mark -

+ (Class)lg_addMethodToStubClass:(SEL)aSelector {
    Class ProtectCrashProtector = objc_getClass(kProtectCrashProtectorName);
    
    if (!ProtectCrashProtector) {
        ProtectCrashProtector = objc_allocateClassPair([NSObject class], kProtectCrashProtectorName, sizeof([NSObject class]));
        objc_registerClassPair(ProtectCrashProtector);
    }
    
    class_addMethod(ProtectCrashProtector, aSelector, (IMP)ProtectCrashProtected, "v@:");
    return ProtectCrashProtector;
}

- (BOOL)lg_isMethodOverride:(Class)cls selector:(SEL)sel {
    IMP clsIMP = class_getMethodImplementation(cls, sel);
    IMP superClsIMP = class_getMethodImplementation([cls superclass], sel);
    
    return clsIMP != superClsIMP;
}

@end
