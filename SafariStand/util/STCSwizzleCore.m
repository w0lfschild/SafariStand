//
//  STCSwizzleCore.m
//  SafariStand
//
//  Created by Ivan Faiustov on 17/10/16.
//
//

#import "STCSwizzleCore.h"
#import "STCSwizzledMethod.h"
#import "STCSwizzleProxy.h"

@implementation STCSwizzleCore

+ (void)applySwizzlingWithMethod:(STCSwizzledMethod *)method {
    Class class = NSClassFromString(method.proxy.className);
    
    Method originalMethod = method.classMethod ? class_getClassMethod(class, method.selector) : class_getInstanceMethod(class, method.selector);
    Method swizzledMethod = method.classMethod ? class_getClassMethod([method.proxy class], method.selector) : class_getInstanceMethod([method.proxy class], method.selector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    method.selector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            method.selector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
