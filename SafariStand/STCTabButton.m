//
//  STCTabButton.m
//  SafariStand
//
//  Created by Ivan Faiustov on 30/07/17.
//
//

#import "STCTabButton.h"
#import "STCSafariStandCore.h"
#import "STTabProxy.h"
#import "STSTabBarModule.h"

@implementation STCTabButton

#pragma mark - Overrides

+ (NSString *)proxiedClassName {
    return @"TabButton";
}

- (STCSwizzleVersion *)supportedVersions {
    STCCombinedVersion *minimumVersion = [STCCombinedVersion versionWithSafariVersion:[STCVersion versionWithMajor:10 minor:0 andPatch:1] andSupportedOSVersion:[STCVersion versionWithMajor:10 minor:11 andPatch:1]];
    
    STCCombinedVersion *maximumVersion = [STCCombinedVersion versionWithSafariVersion:[STCVersion maximumVersion] andSupportedOSVersion:[STCVersion maximumVersion]];
    
    return [STCSwizzleVersion versionWithMinimumVersion:minimumVersion andMaximumVersion:maximumVersion];
}

- (NSArray<STCSwizzledMethod *> *)swizzledMethods {
    STCSwizzledMethod *method1 = [[STCSwizzledMethod alloc] initWithProxy:self selector:@selector(setHasMouseOverHighlight:shouldAnimateCloseButton:) classMethod:NO];
    STCSwizzledMethod *method2 = [[STCSwizzledMethod alloc] initWithProxy:self selector:@selector(setPinned:) classMethod:NO];
    STCSwizzledMethod *method3 = [[STCSwizzledMethod alloc] initWithProxy:self selector:@selector(initWithFrame:tabBarViewItem:) classMethod:NO];
    
    return @[method1, method2, method3];
}

#pragma mark - Methods

- (id)initWithFrame:(CGRect)frame tabBarViewItem:(id)tabBarViewItem {
    self = [[STCTabButton originalWithInstance:self] initWithFrame:frame tabBarViewItem:tabBarViewItem];
    
    if (self) {
        if ([[STCSafariStandCore ud]boolForKey:kpShowIconOnTabBarEnabled]) {
            [STSTabBarModule _installIconToTabButton:(NSButton *)self ofTabViewItem:tabBarViewItem];
        }
    }
    
    return self;
}

- (void)setHasMouseOverHighlight:(BOOL)highlight shouldAnimateCloseButton:(BOOL)shouldAnimate {
    [[STCTabButton originalWithInstance:self] setHasMouseOverHighlight:highlight shouldAnimateCloseButton:shouldAnimate];
    
    STTabIconView *layer = [STTabIconView installedIconInView:(NSButton *)self];
    
    if (layer && !self.isPinned) {
        layer.hidden = highlight;
    }
}

- (void)setPinned:(BOOL)isPinned {
    [[STCTabButton originalWithInstance:self] setPinned:isPinned];
    
    STTabIconView *layer = [STTabIconView installedIconInView:(NSButton *)self];
    if (layer) {
        layer.hidden = isPinned || [self.isShowingCloseButton boolValue];
    }
}

@end
