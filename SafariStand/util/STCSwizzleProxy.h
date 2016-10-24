//
//  STCSwizzleProzy.h
//  SafariStand
//
//  Created by Ivan Faiustov on 17/10/16.
//
//

#import <Foundation/Foundation.h>
#import "STCSwizzledMethod.h"

@interface STCSwizzleProxy : NSObject

@property (nonatomic, readonly) NSString *proxiedClassName;

@property (nonatomic, readonly) NSArray<STCSwizzledMethod *> *swizzledMethods;

+ (instancetype)instance;
+ (instancetype)originalWithInstance:(id)instance;

- (void)applySwizzling;

@end
