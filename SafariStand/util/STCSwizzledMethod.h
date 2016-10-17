//
//  STCSwizzledMethod.h
//  SafariStand
//
//  Created by Ivan Faiustov on 17/10/16.
//
//

#import <Foundation/Foundation.h>

@class STCSwizzleProxy;

@interface STCSwizzledMethod : NSObject

@property (nonatomic) STCSwizzleProxy *proxy;
@property (nonatomic) SEL selector;
@property BOOL classMethod;

- (instancetype)initWithProxy:(STCSwizzleProxy *)proxy selector:(SEL)selector classMethod:(BOOL)classMethod;

@end
