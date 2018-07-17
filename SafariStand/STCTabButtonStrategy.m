//
//  STCTabButtonStrategy.m
//  SafariStand
//
//  Created by Ivan Faiustov on 30/07/17.
//
//

#import "STCTabButtonStrategy.h"
#import "STCTabButtonYosemite.h"
#import "STCTabButton.h"

@implementation STCTabButtonStrategy

- (NSArray<STCSwizzleProxy *> *)proxies {
    return @[[STCTabButton instance], [STCTabButtonYosemite instance]];
}

@end
