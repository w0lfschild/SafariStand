//
//  STCSwizzleCore.h
//  SafariStand
//
//  Created by Ivan Faiustov on 17/10/16.
//
//

#import <Foundation/Foundation.h>

@class STCSwizzledMethod;

@interface STCSwizzleCore : NSObject

+ (void)applySwizzlingWithMethod:(STCSwizzledMethod *)method;

@end
