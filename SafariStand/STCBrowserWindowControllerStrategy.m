//
//  STCBrowserWindowControllerStrategy.m
//  SafariStand
//
//  Created by Ivan Faiustov on 30/07/17.
//
//

#import "STCBrowserWindowControllerStrategy.h"
#import "STCBrowserWindowControllerYosemite.h"
#import "STCBrowserWindowController.h"

@implementation STCBrowserWindowControllerStrategy

- (NSArray<STCSwizzleProxy *> *)proxies {
    return @[[STCBrowserWindowControllerYosemite instance], [STCBrowserWindowController instance]];
}

@end
