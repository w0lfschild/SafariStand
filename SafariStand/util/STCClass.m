//
//  STCClass.m
//  SafariStand
//
//  Created by Ivan Faiustov on 24/10/2016.
//
//

#import "STCClass.h"

@interface STCClass()

@property (nonatomic) BOOL metaClass;
@property (nonatomic) Class class;

@end

@implementation STCClass

+ (instancetype)classWithObjcClassName:(NSString *)className isMetaClass:(BOOL)metaClass {
    NSParameterAssert(className);
    
    STCClass *class = [[self alloc] init];
    class.metaClass = metaClass;
    class.class = metaClass ? objc_getMetaClass([className UTF8String]) : NSClassFromString(className);
    
    return class;
}

- (Method)objcMethodForSelector:(SEL)selector {
    Method method = self.metaClass ? class_getClassMethod(self.class, selector) : class_getInstanceMethod(self.class, selector);
    
    return method;
}

- (Method)addMethodWithSel:(SEL)sel imp:(IMP)imp andSignature:(const char *)types {
    class_addMethod(self.class, sel, imp, types);
    
    Method newMethod = self.metaClass ? class_getClassMethod(self.class, sel) : class_getInstanceMethod(self.class, sel);
    
    return newMethod;
}

@end
