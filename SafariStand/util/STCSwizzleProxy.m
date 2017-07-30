//
//  STCSwizzleProzy.m
//  SafariStand
//
//  Created by Ivan Faiustov on 17/10/16.
//
//

#import "STCSwizzleProxy.h"
#import "STCSwizzleCore.h"
#import "STCOriginalSwizzleProxy.h"

@interface STCSwizzleProxy()

@property (nonatomic, getter=isSwizzlingApplied) BOOL swizzlingApplied;
@property (nonatomic) NSArray<STCSwizzledMethod *> *swizzledMethods;
@property (nonatomic) STCSwizzleVersion *supportedVersions;

@end

@implementation STCSwizzleProxy

static NSMutableDictionary * _sharedInsances = nil;
static dispatch_semaphore_t _semaphore = nil;

+ (instancetype)instance {
    if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"Safari"] == false) {
        return nil;
    }

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInsances = [NSMutableDictionary dictionary];
        _semaphore = dispatch_semaphore_create(1);
    });
    
    __block id object = nil;
    
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *key = NSStringFromClass([self class]);
        
        object = [_sharedInsances objectForKey:key];
        if (!object) {
            object = [[super alloc] init];
            [_sharedInsances setObject:object forKey:key];
        }
        
        dispatch_semaphore_signal(_semaphore);
    });
    
    return object;
}

+ (instancetype)alloc {
    return [self instance];
}

- (void)applySwizzling {
    if (!self.isSupported) {
        NSLog(@"%@ is not supported in current version, so skipping...", NSStringFromClass([self class]));
        return;
    }
    
    if (self.isSwizzlingApplied) {
        return;
    }
    
    for (STCSwizzledMethod *method in self.swizzledMethods) {
        [STCSwizzleCore applySwizzlingWithMethod:method];
    }
    
    self.swizzlingApplied = YES;
}

+ (instancetype)originalWithInstance:(id)instance {
    STCOriginalSwizzleProxy *originalProxy = [STCOriginalSwizzleProxy proxyForInstance:instance];
    
    return (STCSwizzleProxy *)originalProxy;
}

- (BOOL)isSupported {
    if (!self.supportedVersions) {
        return NO;
    }
    
    STCCombinedVersion *currentVersion = [STCCombinedVersion currentVersion];
    
    BOOL isOSVersionSupported = [self isOSSupported:currentVersion.osVersion];
    BOOL isSafariVersionSupported = [self isSafariVersionSupported:currentVersion.safariVersion];
    
    return (isOSVersionSupported && isSafariVersionSupported);
}

- (BOOL)isOSSupported:(STCVersion *)currentOSversion {
    NSComparisonResult leftResult = [self.supportedVersions.minimumVersion.osVersion compare:currentOSversion];
    NSComparisonResult rightResult = [currentOSversion compare:self.supportedVersions.maximumVersion.osVersion];
    
    if ((leftResult == NSOrderedSame || leftResult == NSOrderedAscending) && (rightResult == NSOrderedSame || rightResult == NSOrderedAscending)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isSafariVersionSupported:(STCVersion *)currentSafariVersion {
    NSComparisonResult leftResult = [self.supportedVersions.minimumVersion.safariVersion compare:currentSafariVersion];
    NSComparisonResult rightResult = [currentSafariVersion compare:self.supportedVersions.maximumVersion.safariVersion];
    
    if ((leftResult == NSOrderedSame || leftResult == NSOrderedAscending) && (rightResult == NSOrderedSame || rightResult == NSOrderedAscending)) {
        return YES;
    } else {
        return NO;
    }
}

@end
