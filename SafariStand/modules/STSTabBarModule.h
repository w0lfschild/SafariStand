//
//  STSTabBarModule.h
//  SafariStand


/*
 ホイールスクロールでタブ切り替え
 */

@import AppKit;
#import "STCModule.h"

@class STCTabButton;

@interface STTabIconView : NSImageView

+ (id)installedIconInView:(NSView *)view;

@end

@interface STSTabBarModule : STCModule

+(STTabIconView *)_installIconToTabButton:(NSButton *)tabButton ofTabViewItem:(NSTabViewItem*)tabViewItem;

@end
