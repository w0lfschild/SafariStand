//
//  STCProxy.m
//  SafariStand
//
//  Created by Ivan Faiustov on 17/10/16.
//
//

#import "STCProxy.h"

@interface STCProxy()

@property (nonatomic) id object;

@end

@implementation STCProxy

- (instancetype)initWithObject:(id)object {
    self = [super init];
    
    if (self) {
        _object = object;
    }
    
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    if ([self respondsToSelector:sel]) {
        return [self methodSignatureForSelector:sel];
    } else {
        return [self.object methodSignatureForSelector:sel];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.object];
}

@end
