//
//  STCSafariStandVersion.m
//  SafariStand
//
//  Created by Ivan Faiustov on 21/07/17.
//
//

#import "STCCombinedVersion.h"

@interface STCCombinedVersion()

@property (nonatomic) STCVersion *safariVersion;
@property (nonatomic) STCVersion *osVersion;

@end

@implementation STCCombinedVersion

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSString *currentStringVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSArray *numbers = [self parseNumberStringsArray:[currentStringVersion componentsSeparatedByString:@"."]];
        
        self.safariVersion = [STCVersion versionWithMajor:[numbers[0] integerValue]  minor:[numbers[1] integerValue] andPatch:[numbers[2] integerValue]];
        self.osVersion = [STCVersion versionWithOSVersion];
    }
    
    return self;
}

- (instancetype)initWithSafariVersion:(STCVersion *)standVersion andSupportedOSVersion:(STCVersion *)osVersion {
    self = [super init];
    
    if (self) {
        self.safariVersion = standVersion;
        self.osVersion = osVersion;
    }
    
    return self;
}

+ (instancetype)currentVersion {
    return [[STCCombinedVersion alloc] init];
}

+ (instancetype)versionWithSafariVersion:(STCVersion *)standVersion andSupportedOSVersion:(STCVersion *)osVersion {
    return [[STCCombinedVersion alloc] initWithSafariVersion:standVersion andSupportedOSVersion:osVersion];
}

- (NSArray<NSNumber *> *)parseNumberStringsArray:(NSArray<NSString *> *)stringNumbers {
    NSMutableArray *numbers = [NSMutableArray array];
    
    for (NSString *stringNumber in stringNumbers) {
        [numbers addObject:@([stringNumber integerValue])];
    }
    
    return numbers;
}

@end
