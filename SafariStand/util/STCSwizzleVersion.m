//
//  STCSwizzleVersion.m
//  SafariStand
//
//  Created by Ivan Faiustov on 30/07/17.
//
//

#import "STCSwizzleVersion.h"

@interface STCSwizzleVersion()

@property (nonatomic) STCCombinedVersion *minimumVersion;
@property (nonatomic) STCCombinedVersion *maximumVersion;

@end

@implementation STCSwizzleVersion

- (instancetype)initWithMinimumVersion:(STCCombinedVersion *)minimumVersion andMaximumVersion:(STCCombinedVersion *)maximumVersion {
    self = [super init];
    
    if (self) {
        self.minimumVersion = minimumVersion;
        self.maximumVersion = maximumVersion;
    }
    
    return self;
}

+ (instancetype)versionWithMinimumVersion:(STCCombinedVersion *)minimumVersion andMaximumVersion:(STCCombinedVersion *)maximumVersion {
    return [[STCSwizzleVersion alloc] initWithMinimumVersion:minimumVersion andMaximumVersion:maximumVersion];
}

@end
