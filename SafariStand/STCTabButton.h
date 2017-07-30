//
//  STCTabButton.h
//  SafariStand
//
//  Created by Ivan Faiustov on 30/07/17.
//
//

#import "STCSwizzleProxy.h"

@interface STCTabButton : STCSwizzleProxy

@property (nonatomic, readonly) BOOL isPinned;
@property (nonatomic, readonly) NSNumber *isShowingCloseButton;

@end
