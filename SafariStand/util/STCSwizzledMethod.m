//
//  STCSwizzledMethod.m
//  SafariStand
//
//  Created by Ivan Faiustov on 17/10/16.
//
//

#import "STCSwizzledMethod.h"

@implementation STCSwizzledMethod

- (instancetype)initWithProxy:(STCSwizzleProxy *)proxy selector:(SEL)selector classMethod:(BOOL)classMethod {
    self = [super init];
    
    if (self) {
        _proxy = proxy;
        _selector = selector;
        _classMethod = classMethod;
    }
    
    return self;
}

@end
