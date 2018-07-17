//
//  STCVersion.h
//  SafariStand
//
//  Created by Ivan Faiustov on 21/07/17.
//
//

#import <Foundation/Foundation.h>

@interface STCVersion : NSObject

@property (nonatomic, readonly) NSInteger major;
@property (nonatomic, readonly) NSInteger minor;
@property (nonatomic, readonly) NSInteger patch;

- (NSComparisonResult)compare:(STCVersion *)other;
- (BOOL)isEqualToVersion:(STCVersion *)object;

+ (instancetype)versionWithMajor:(NSInteger)major minor:(NSInteger)minor andPatch:(NSInteger)patch;
+ (instancetype)versionWithOSVersion;

- (instancetype)initWithMajor:(NSInteger)major minor:(NSInteger)minor andPatch:(NSInteger)patch;
- (instancetype)initWithOSVersion;

// Like a distant future function on NSDate
+ (instancetype)maximumVersion;

@end
