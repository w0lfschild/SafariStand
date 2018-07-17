//
//  STCBrowserWindowControllerYosemite.m
//  SafariStand
//
//  Created by Ivan Faiustov on 30/07/17.
//
//

#import "STCBrowserWindowControllerYosemite.h"
#import "STCBrowserTabViewItem.h"
#import "STCTabBarView.h"
#import "STSafariConnect.h"
#import "STTabProxy.h"

#pragma GCC diagnostic ignored "-Wincomplete-implementation"

@implementation STCBrowserWindowControllerYosemite

+ (NSString *)proxiedClassName {
    return @"BrowserWindowController";
}

- (void)_moveTab:(id)tab toIndex:(NSInteger)index isChangingPinnedness:(BOOL)changingPinnedness {
    [[STCBrowserWindowControllerYosemite originalWithInstance:self] _moveTab:tab toIndex:index isChangingPinnedness:changingPinnedness];
    
    NSTabView* tabView=[tab tabView];
    [[NSNotificationCenter defaultCenter]postNotificationName:STTabViewDidChangeNote object:tabView];
}

- (NSMenu *)tabBarView:(NSView *)tabBarView menuForTabBarViewItem:(NSTabViewItem *)tabBarViewItem event:(NSEvent *)event {
    NSMenu *menu = [[STCBrowserWindowControllerYosemite originalWithInstance:self] tabBarView:tabBarView menuForTabBarViewItem:tabBarViewItem event:event];
    
    NSArray *tabViewItems = [[tabBarView tabBarProxy] tabBarViewItems];
    NSInteger selectedIndex = [tabViewItems indexOfObject:tabBarViewItem];
    
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Duplicate Tab" action:@selector(duplicateTab:) keyEquivalent:@""];
    [item setTarget:[STCBrowserWindowControllerYosemite instance]];
    [item setRepresentedObject:tabBarViewItem];
    [item setTag:selectedIndex];
    
    NSMenuItem *separator = [NSMenuItem separatorItem];
    
    [menu insertItem:separator atIndex:2];
    [menu insertItem:item atIndex:2];
    
    return menu;
}

- (NSArray<STCSwizzledMethod *> *)swizzledMethods {
    STCSwizzledMethod *method1 = [[STCSwizzledMethod alloc] initWithProxy:self selector:@selector(tabBarView:menuForTabBarViewItem:event:) classMethod:NO];
    STCSwizzledMethod *method2 = [[STCSwizzledMethod alloc] initWithProxy:self selector:@selector(_moveTab:toIndex:isChangingPinnedness:) classMethod:NO];
    
    return @[method1, method2];
}

- (STCSwizzleVersion *)supportedVersions {
    STCCombinedVersion *minimumVersion = [STCCombinedVersion versionWithSafariVersion:[STCVersion versionWithMajor:10 minor:0 andPatch:1] andSupportedOSVersion:[STCVersion versionWithMajor:10 minor:10 andPatch:1]];
    
    STCCombinedVersion *maximumVersion = [STCCombinedVersion versionWithSafariVersion:[STCVersion maximumVersion] andSupportedOSVersion:[STCVersion versionWithMajor:10 minor:10 andPatch:5]];
    
    return [STCSwizzleVersion versionWithMinimumVersion:minimumVersion andMaximumVersion:maximumVersion];
}

- (void)duplicateTab:(NSMenuItem *)item {
    id object = [item representedObject];
    
    NSString *urlString = [object valueForKey:@"URLString"];
    
    STSafariCreateTabForURLAtIndex([NSURL URLWithString:urlString], item.tag+1);
}

@end
