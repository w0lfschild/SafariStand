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
@property (nonatomic) Class classObject;

@end

@implementation STCClass

+ (instancetype)classWithObjcClassName:(NSString *)className isMetaClass:(BOOL)metaClass {
    NSParameterAssert(className);
    
    STCClass *class = [[self alloc] init];
    class.metaClass = metaClass;
    class.classObject = metaClass ? objc_getMetaClass([className UTF8String]) : NSClassFromString(className);
    
    return class;
}

- (Method)objcMethodForSelector:(SEL)selector {
    Method method = self.metaClass ? class_getClassMethod(self.classObject, selector) : class_getInstanceMethod(self.classObject, selector);
    
    return method;
}

- (Method)addMethodWithSel:(SEL)sel imp:(IMP)imp andSignature:(const char *)types {
    class_addMethod(self.classObject, sel, imp, types);
    
    Method newMethod = self.metaClass ? class_getClassMethod(self.classObject, sel) : class_getInstanceMethod(self.classObject, sel);
    
    return newMethod;
}

- (void)addPropertyWithName:(const char *)name backingVarName:(const char *)backingVar getter:(SEL)getter setter:(SEL)setter impGetter:(IMP)impGetter impSetter:(IMP)impSetter {
    objc_property_attribute_t type = { "T", "@" };
    objc_property_attribute_t ownership = { "C", "" }; // C = copy
    objc_property_attribute_t backingivar  = { "V", backingVar };
    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
    class_addProperty(self.classObject, name, attrs, 3);
    
    
    class_addMethod(self.classObject, getter, (IMP)impGetter, "@@:");
    class_addMethod(self.classObject, setter, (IMP)impSetter, "v@:@");
}

@end
