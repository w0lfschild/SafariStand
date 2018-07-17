//
//  STCSwizzleProzy.h
//  SafariStand
//
//  Created by Ivan Faiustov on 17/10/16.
//
//

#import "STCProxy.h"
#import "STCSwizzledMethod.h"
#import "STCSwizzleVersion.h"

@interface STCSwizzleProxy : STCProxy

@property (nonatomic, readonly) BOOL isSupported;

@property (nonatomic, readonly) NSArray<STCSwizzledMethod *> *swizzledMethods;
@property (nonatomic, readonly) STCSwizzleVersion *supportedVersions;

+ (instancetype)instance;
+ (instancetype)originalWithInstance:(id)instance;

- (void)applySwizzling;

@end
