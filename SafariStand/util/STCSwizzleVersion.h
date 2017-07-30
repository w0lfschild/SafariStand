//
//  STCSwizzleVersion.h
//  SafariStand
//
//  Created by Ivan Faiustov on 30/07/17.
//
//

#import <Foundation/Foundation.h>
#import "STCCombinedVersion.h"

@interface STCSwizzleVersion: NSObject

@property (nonatomic, readonly) STCCombinedVersion *minimumVersion;
@property (nonatomic, readonly) STCCombinedVersion *maximumVersion;

+ (instancetype)versionWithMinimumVersion:(STCCombinedVersion *)minimumVersion andMaximumVersion:(STCCombinedVersion *)maximumVersion;
- (instancetype)initWithMinimumVersion:(STCCombinedVersion *)minimumVersion andMaximumVersion:(STCCombinedVersion *)maximumVersion;

@end
