//
//  STCOneStepBookmarkingButtonController.m
//  SafariStand
//
//  Created by Ivan Faiustov on 17/10/16.
//
//

#import "STCOneStepBookmarkingButtonController.h"
#import "STCBookmarksController.h"

@implementation STCOneStepBookmarkingButtonController

- (NSString *)className {
    return @"OneStepBookmarkingButtonController";
}

- (void)_addBookmarkToReadingListWithoutAskingAndMakeDefault:(BOOL)arg1 {
    STCBookmarksController *controller = [STCBookmarksController sharedController];
    id bookmarksObject = [controller bookmarksMenuCollection];
    
    // Self here is not our object but Safari's OneStepBookmarkingButtonController cause of the method swizzling
    [self _addBookmarkWithoutAskingToFolder:bookmarksObject andMakeDefault:arg1];
}

- (void)_addBookmarkWithoutAskingToFolder:(id)bookmarksObject andMakeDefault:(BOOL)arg1 {
    // This one is here just so we can trick the compile in a thinking that the method is actually defined :)
}

- (NSString *)oneStepBookmarkingButtonActionDescription {
    return @"Add page to Bookmarks List";
}

- (NSArray<STCSwizzledMethod *> *)swizzledMethods {
    STCSwizzledMethod *method1 = [[STCSwizzledMethod alloc] initWithProxy:self selector:@selector(_addBookmarkToReadingListWithoutAskingAndMakeDefault:) classMethod:NO];
    STCSwizzledMethod *method2 = [[STCSwizzledMethod alloc] initWithProxy:self selector:@selector(oneStepBookmarkingButtonActionDescription) classMethod:NO];
    
    return @[method1, method2];
}

@end
