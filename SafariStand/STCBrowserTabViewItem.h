//
//  STCBrowserTabViewItem.h
//  SafariStand
//
//  Created by Ivan Faiustov on 24/10/2016.
//
//

#import "STCProxy.h"
#import "STSafariConnect.h"

//typedef const struct OpaqueBrowserContentViewController *BrowserContentViewController;

@interface STCBrowserTabViewItem : STCProxy

- (struct BrowserContentViewController *)browserContentViewController;

@end

@interface NSTabViewItem (STCBrowserTabViewItem)

- (STCBrowserTabViewItem *)proxy;

@end
