//
//  STCSwizzleStrategy.m
//  SafariStand
//
//  Created by Ivan Faiustov on 30/07/17.
//
//

#import "STCSwizzleStrategy.h"

@interface STCSwizzleStrategy()

@property (nonatomic) NSArray<STCSwizzleProxy *> *proxies;

@end

@implementation STCSwizzleStrategy

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)applySwizzling {
    for (STCSwizzleProxy* proxy in self.proxies) {
        if (proxy.isSupported) {
            [proxy applySwizzling];
            
            return;
        }
    }
}

@end
