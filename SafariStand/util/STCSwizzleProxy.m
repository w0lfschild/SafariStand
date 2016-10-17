//
//  STCSwizzleProzy.m
//  SafariStand
//
//  Created by Ivan Faiustov on 17/10/16.
//
//

#import "STCSwizzleProxy.h"
#import "STCSwizzleCore.h"

@interface STCSwizzleProxy()

@property (nonatomic) NSString *className;

@property (nonatomic) NSArray<STCSwizzledMethod *> *swizzledMethods;

@end

@implementation STCSwizzleProxy

static id _sharedInsance = nil;

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInsance = [self alloc];
    });
    
    return _sharedInsance;
}

+ (instancetype)alloc {
    if (_sharedInsance) {
        return _sharedInsance;
    } else {
        return [super alloc];
    }
}

- (void)applySwizzling {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (STCSwizzledMethod *method in self.swizzledMethods) {
            [STCSwizzleCore applySwizzlingWithMethod:method];
        }
    });
}

@end
