//
//  STCSwizzleStrategy.h
//  SafariStand
//
//  Created by Ivan Faiustov on 30/07/17.
//
//

#import <Foundation/Foundation.h>
#import "STCSwizzleProxy.h"

@interface STCSwizzleStrategy : NSObject

@property (nonatomic, readonly) NSArray<STCSwizzleProxy *> *proxies;

- (void)applySwizzling;

@end
