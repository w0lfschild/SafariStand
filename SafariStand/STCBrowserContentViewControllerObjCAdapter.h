//
//  STCBrowserContentViewControllerObjCAdapter.h
//  SafariStand
//
//  Created by Ivan Faiustov on 24/10/2016.
//
//

#import "STCProxy.h"
#import "STSafariConnect.h"

@interface STCBrowserContentViewControllerObjCAdapter : STCProxy

- (instancetype)initWithBrowserContentViewController:(BrowserContentViewController *)contentVC;
- (void)loadURL:(NSURL *)URL tabLabel:(NSString *)label httpReferrer:(id)referrer;

@end
