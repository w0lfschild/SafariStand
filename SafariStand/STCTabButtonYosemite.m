//
//  STCTabButtonYosemite.m
//  SafariStand
//
//  Created by Ivan Faiustov on 30/07/17.
//
//

#import "STCTabButtonYosemite.h"
#import "STSTabBarModule.h"
#import "STCSafariStandCore.h"
#import "STTabProxy.h"
//#import "STCIconDatabase.h"

@implementation STCTabButtonYosemite

#pragma mark - Overrides

+ (NSString *)proxiedClassName {
    return @"TabButton";
}

- (STCSwizzleVersion *)supportedVersions {
    STCCombinedVersion *minimumVersion = [STCCombinedVersion versionWithSafariVersion:[STCVersion versionWithMajor:10 minor:0 andPatch:1] andSupportedOSVersion:[STCVersion versionWithMajor:10 minor:10 andPatch:1]];
    
    STCCombinedVersion *maximumVersion = [STCCombinedVersion versionWithSafariVersion:[STCVersion maximumVersion] andSupportedOSVersion:[STCVersion versionWithMajor:10 minor:10 andPatch:5]];
    
    return [STCSwizzleVersion versionWithMinimumVersion:minimumVersion andMaximumVersion:maximumVersion];
}

- (NSArray<STCSwizzledMethod *> *)swizzledMethods {
    STCSwizzledMethod *method1 = [[STCSwizzledMethod alloc] initWithProxy:self selector:@selector(setHasMouseOverHighlight:shouldAnimateCloseButton:) classMethod:NO];
    STCSwizzledMethod *method2 = [[STCSwizzledMethod alloc] initWithProxy:self selector:@selector(initWithFrame:tabBarViewItem:) classMethod:NO];

    return @[method1, method2];
}

#pragma mark - Methods

- (void)setHasMouseOverHighlight:(BOOL)highlight shouldAnimateCloseButton:(BOOL)shouldAnimate {
    [[STCTabButtonYosemite originalWithInstance:self] setHasMouseOverHighlight:highlight shouldAnimateCloseButton:shouldAnimate];
    
    STTabIconView *layer = [STTabIconView installedIconInView:(NSButton *)self];
    
    if (layer) {
        layer.hidden = highlight;
    }
}

- (id)initWithFrame:(CGRect)frame tabBarViewItem:(id)tabBarViewItem {
    self = [[STCTabButtonYosemite originalWithInstance:self] initWithFrame:frame tabBarViewItem:tabBarViewItem];
    
    if (self) {
        if ([[STCSafariStandCore ud]boolForKey:kpShowIconOnTabBarEnabled]) {
            [STSTabBarModule _installIconToTabButton:(NSButton *)self ofTabViewItem:tabBarViewItem];
        }
    }
    
    return self;
}

@end
