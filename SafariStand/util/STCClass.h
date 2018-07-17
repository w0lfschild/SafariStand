//
//  STCClass.h
//  SafariStand
//
//  Created by Ivan Faiustov on 24/10/2016.
//
//

#import <Foundation/Foundation.h>

@interface STCClass : NSObject

@property (nonatomic, readonly) BOOL metaClass;
@property (nonatomic, readonly) Class classObject;

+ (instancetype)classWithObjcClassName:(NSString *)className isMetaClass:(BOOL)metaClass;

- (Method)objcMethodForSelector:(SEL)selector;
- (Method)addMethodWithSel:(SEL)sel imp:(IMP)imp andSignature:(const char *)types;
- (void)addPropertyWithName:(const char *)name backingVarName:(const char *)backingVar getter:(SEL)getter setter:(SEL)setter impGetter:(IMP)impGetter impSetter:(IMP)impSetter;

@end
