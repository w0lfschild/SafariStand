//
//  STSTabBarModule.h
//  SafariStand


/*
 ホイールスクロールでタブ切り替え
 */

@import AppKit;
#import "STCModule.h"

@interface STSTabBarModule : STCModule

+(void)_installIconToTabButton:(NSButton*)tabButton ofTabViewItem:(NSTabViewItem*)tabViewItem;

@end


@interface STTabIconLayer : CALayer

+ (id)installedIconLayerInView:(NSView*)view;

- (void)bringLayerToFront;

@end
