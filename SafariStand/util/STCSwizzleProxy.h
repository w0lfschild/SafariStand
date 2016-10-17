//
//  STCSwizzleProzy.h
//  SafariStand
//
//  Created by Ivan Faiustov on 17/10/16.
//
//

#import <Foundation/Foundation.h>
#import "STCSwizzledMethod.h"

@interface STCSwizzleProxy : NSProxy

@property (nonatomic, readonly) NSString *className;

@property (nonatomic, readonly) NSArray<STCSwizzledMethod *> *swizzledMethods;

+ (instancetype)instance;

- (void)applySwizzling;

@end
