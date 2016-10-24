//
//  STCSwizzleProzy.m
//  SafariStand
//
//  Created by Ivan Faiustov on 17/10/16.
//
//

#import "STCSwizzleProxy.h"
#import "STCSwizzleCore.h"
#import "STCOriginalSwizzleProxy.h"

@interface STCSwizzleProxy()

@property (nonatomic) NSArray<STCSwizzledMethod *> *swizzledMethods;

@end

@implementation STCSwizzleProxy

static id _sharedInsance = nil;

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInsance = [[super alloc] init];
    });
    
    return _sharedInsance;
}

+ (instancetype)alloc {
    return [self instance];
}

- (void)applySwizzling {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (STCSwizzledMethod *method in self.swizzledMethods) {
            [STCSwizzleCore applySwizzlingWithMethod:method];
        }
    });
}

+ (instancetype)originalWithInstance:(id)instance {
    STCOriginalSwizzleProxy *originalProxy = [STCOriginalSwizzleProxy proxyForInstance:instance];
    
    return (STCSwizzleProxy *)originalProxy;
}

@end
