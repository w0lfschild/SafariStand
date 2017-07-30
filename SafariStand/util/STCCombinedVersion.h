//
//  STCSafariStandVersion.h
//  SafariStand
//
//  Created by Ivan Faiustov on 21/07/17.
//
//

#import <Foundation/Foundation.h>
#import "STCVersion.h"

@interface STCCombinedVersion : NSObject

@property (nonatomic, readonly) STCVersion *safariVersion;
@property (nonatomic, readonly) STCVersion *osVersion;

+ (instancetype)currentVersion;
+ (instancetype)versionWithSafariVersion:(STCVersion *)standVersion andSupportedOSVersion:(STCVersion *)osVersion;

- (instancetype)init;
- (instancetype)initWithSafariVersion:(STCVersion *)standVersion andSupportedOSVersion:(STCVersion *)osVersion;

@end
