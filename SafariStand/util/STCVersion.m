//
//  STCVersion.m
//  SafariStand
//
//  Created by Ivan Faiustov on 21/07/17.
//
//

#import "STCVersion.h"

@interface STCVersion()

@property (nonatomic) NSInteger major;
@property (nonatomic) NSInteger minor;
@property (nonatomic) NSInteger patch;

@end

@implementation STCVersion

- (instancetype)initWithMajor:(NSInteger)major minor:(NSInteger)minor andPatch:(NSInteger)patch {
    self = [super init];
    
    if (self) {
        self.major = major;
        self.minor = minor;
        self.patch = patch;
    }
    
    return self;
}

- (instancetype)initWithOSVersion {
    self = [super init];
    
    if (self) {
        NSOperatingSystemVersion version = [[NSProcessInfo processInfo] operatingSystemVersion];
        self.major = version.majorVersion;
        self.minor = version.minorVersion;
        self.patch = version.patchVersion;
    }
    
    return self;
}

+ (instancetype)versionWithMajor:(NSInteger)major minor:(NSInteger)minor andPatch:(NSInteger)patch {
    return [[STCVersion alloc] initWithMajor:major minor:minor andPatch:patch];
}

+ (instancetype)versionWithOSVersion {
    return [[STCVersion alloc] initWithOSVersion];
}

+ (instancetype)maximumVersion {
    return [[STCVersion alloc] initWithMajor:NSIntegerMax minor:NSIntegerMax andPatch:NSIntegerMax];
}

- (NSComparisonResult)compare:(STCVersion *)other {
    if (self.major > other.major) {
        return NSOrderedDescending;
    } else if (self.major < other.major) {
        return NSOrderedAscending;
    } else {
        if (self.minor > other.minor) {
            return NSOrderedDescending;
        } else if (self.minor < other.minor) {
            return NSOrderedAscending;
        } else {
            if (self.patch > other.patch) {
                return NSOrderedDescending;
            } else if (self.patch < other.patch) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }
    }
}

- (BOOL)isEqualToVersion:(STCVersion *)object {
    return [self compare:object] == NSOrderedSame;
}

@end
