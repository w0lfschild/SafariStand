//
//  STCSimblLorder.m
//  SafariStand

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC
#endif


#import "SafariStand.h"
#import "STCSimblLorder.h"

__attribute__((constructor)) void cDockLoad() {
    NSLog(@"Hello construct");
    [STCSafariStandCore si];
}

@implementation STCSimblLorder

//SIMBL
//+ (void)install {
//    NSLog(@"Hello load");
//    [STCSafariStandCore si];
//}

//+ (void)load {
//    NSLog(@"Hello load");
//    [STCSafariStandCore si];
//}

@end
