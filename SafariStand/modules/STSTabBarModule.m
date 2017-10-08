//
//  STSTabBarModule.m
//  SafariStand

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import <mach/mach_time.h>
#import "SafariStand.h"
#import "STSTabBarModule.h"
#import "STTabProxy.h"
#import "STCTabButtonStrategy.h"
#import "STCTabButton.h"

static int STTAB_ICON_VIEW_TAG = 55647;

@implementation STSTabBarModule {
    uint64_t _nextTime;
    uint64_t _duration;
}


-(void)layoutTabBarForExistingWindow
{
    //check exists window
    STSafariEnumerateBrowserWindow(^(NSWindow* win, NSWindowController* winCtl, BOOL* stop){
        if([win isVisible] && [winCtl respondsToSelector:@selector(isTabBarVisible)]
           && [winCtl respondsToSelector:@selector(tabBarView)]
           ){
            if (objc_msgSend(winCtl, @selector(isTabBarVisible))) {
                id tabBarView = objc_msgSend(winCtl, @selector(tabBarView));
                if([tabBarView respondsToSelector:@selector(_updateButtonsAndLayOutAnimated:)]){
                    objc_msgSend(tabBarView, @selector(_updateButtonsAndLayOutAnimated:), YES);
                }
            }
        }
    });
}

- (id)initWithStand:(id)core
{
    self = [super initWithStand:core];
    if (!self) return nil;
    
    //SwitchTabWithWheel
    mach_timebase_info_data_t timebaseInfo;
    mach_timebase_info(&timebaseInfo);
    _duration = ((1000000000 * timebaseInfo.denom) / 3) / timebaseInfo.numer; //1/3sec
    _nextTime=mach_absolute_time();
    
    [[STCTabButtonStrategy new] applySwizzling];
    
    KZRMETHOD_SWIZZLING_("TabBarView", "scrollWheel:", void, call, sel)
    ^void (id slf, NSEvent* event)
    {
        if([[STCSafariStandCore ud]boolForKey:kpSwitchTabWithWheelEnabled]){
            id window=objc_msgSend(slf, @selector(window));
            if([[[window windowController]className]isEqualToString:kSafariBrowserWindowController]){
                if ([self canAction]) {
                    SEL action=nil;
                    //[theEvent deltaY] が+なら上、-なら下
                    CGFloat deltaY=[event deltaY];
                    if(deltaY>0){
                        action=@selector(selectPreviousTab:);
                    }else if(deltaY<0){
                        action=@selector(selectNextTab:);
                    }
                    if(action){
                        [NSApp sendAction:action to:nil from:self];
                        return;
                    }
                }
            }
        }
        
        call(slf, sel, event);
        
    }_WITHBLOCK;
    
    
    //タブバー幅変更
    KZRMETHOD_SWIZZLING_("TabBarView", "_buttonWidthForNumberOfButtons:inWidth:remainderWidth:", double, call, sel)
    ^double (id slf, unsigned long long buttonNum, double inWidth, double* remainderWidth)
    {
        double result=call(slf, sel, buttonNum, inWidth, remainderWidth);
        if ([[STCSafariStandCore ud]boolForKey:kpSuppressTabBarWidthEnabled]) {
            double maxWidth=floor([[STCSafariStandCore ud]doubleForKey:kpSuppressTabBarWidthValue]);
            if (result>maxWidth) {
                //double diff=result-maxWidth;
                //*remainderWidth=diff+*remainderWidth;
                return maxWidth;
            }
        }
        return result;
    }_WITHBLOCK;
    
    KZRMETHOD_SWIZZLING_("TabBarView", "_shouldLayOutButtonsToAlignWithWindowCenter", BOOL, call, sel)
    ^BOOL (id slf)
    {
        if ([[STCSafariStandCore ud]boolForKey:kpSuppressTabBarWidthEnabled]) {
            return NO;
        }
        
        BOOL result=call(slf, sel);
        return result;
    }_WITHBLOCK;
    
    //follow empty space
    KZRMETHOD_SWIZZLING_("TabBarView", "_tabIndexAtPoint:", unsigned long long, call, sel)
    ^NSUInteger(id slf, struct CGPoint arg1)
    {
        NSUInteger result=call(slf, sel, arg1);
        if ([[STCSafariStandCore ud]boolForKey:kpSuppressTabBarWidthEnabled]) {
            if (result==0) {
                double maxWidth=floor([[STCSafariStandCore ud]doubleForKey:kpSuppressTabBarWidthValue]);
                if (arg1.x > maxWidth) {
                    result=NSNotFound;
                }
            }else if (result!=NSNotFound) {
                if ([slf respondsToSelector:@selector(_numberOfTabsForLayout)]) {
                    NSUInteger num=((NSUInteger(*)(id, SEL, ...))objc_msgSend)(slf, @selector(_numberOfTabsForLayout));
                    if (num <= result) {
                        result=NSNotFound;
                    }
                }
            }
        }
        return result;
    }_WITHBLOCK;
    
    //タブバー狭くして空きスペースができているときドロップの対処
    KZRMETHOD_SWIZZLING_("TabBarView", "_moveButton:toIndex:", void, call, sel)
    ^(id slf, id button, unsigned long long index)
    {
        if (index==NSNotFound) {
            index=0;
            if ([slf respondsToSelector:@selector(tabButtons)]) {
                NSArray *tabButtons=((id(*)(id, SEL, ...))objc_msgSend)(slf, @selector(tabButtons));
                NSUInteger num=[tabButtons count];
                if (num>0) {
                    index=num-1;
                }
            }
        }
        
        call(slf, sel, button, index);
    }_WITHBLOCK;
    
    
    double minX=[[STCSafariStandCore ud]doubleForKey:kpSuppressTabBarWidthValue];
    if (minX<140.0 || minX>480.0) minX=240.0;
    if ([[STCSafariStandCore ud]boolForKey:kpSuppressTabBarWidthEnabled]) {
        [self layoutTabBarForExistingWindow];
    }
    [self observePrefValue:kpSuppressTabBarWidthEnabled];
    [self observePrefValue:kpSuppressTabBarWidthValue];
    
    if ([[STCSafariStandCore ud]boolForKey:kpShowIconOnTabBarEnabled]) {
        [self installIconToExistingWindows];
    }
    [self observePrefValue:kpShowIconOnTabBarEnabled];
    

    return self;
}


- (void)dealloc
{

}


- (void)prefValue:(NSString*)key changed:(id)value
{
    if([key isEqualToString:kpSuppressTabBarWidthEnabled]||[key isEqualToString:kpSuppressTabBarWidthValue]){
        [self layoutTabBarForExistingWindow];
    }else if([key isEqualToString:kpShowIconOnTabBarEnabled]){
        if ([value boolValue]) {
            [self installIconToExistingWindows];
        }else{
            [self removeIconFromExistingWindows];
        }
    }
}


- (BOOL)canAction
{
    uint64_t now=mach_absolute_time();
    if (now>_nextTime) {
        _nextTime=now+_duration;
        return YES;
    }
    return NO;
}

#pragma mark -

+(STTabIconView *)_installIconToTabButton:(NSButton *)tabButton ofTabViewItem:(NSTabViewItem*)tabViewItem
{
    STTabIconView *view = [STTabIconView installedIconInView:tabButton];
    if (view) {
        return view;
    }
    
    NSView* closeButton=[tabButton valueForKey:@"_closeButton"];
    if (!closeButton) {
        return nil;
    }
    
    view = [[STTabIconView alloc] initWithFrame:CGRectMake(6, 4, 14, 14)];
    view.tag = STTAB_ICON_VIEW_TAG;
    [[tabButton valueForKey:@"_mainContentContainer"] addSubview:view];
    
    STCVersion *currentSystemVersion = [STCVersion versionWithOSVersion];
    if (currentSystemVersion.major == 10 && currentSystemVersion.minor >= 11) {
        BOOL isPinned = [[tabButton valueForKey:@"isPinned"] boolValue];
        view.hidden = isPinned;
    }

    STTabProxy* tp= [STTabProxy tabProxyForTabViewItem:tabViewItem];
    if (tp) {
        [view bind:@"image" toObject:tp withKeyPath:@"image" options:nil];
    }
    
    return view;
}


- (void)installIconToExistingWindows
{
    STSafariEnumerateTabButton(^(NSButton* tabBtn, BOOL* stop){
        if (![tabBtn respondsToSelector:@selector(tabBarViewItem)]) {
            return;
        }
        NSTabViewItem* tabViewItem=((id(*)(id, SEL, ...))objc_msgSend)(tabBtn, @selector(tabBarViewItem));
        
        [STSTabBarModule _installIconToTabButton:tabBtn ofTabViewItem:tabViewItem];
    });
}


- (void)_removeIconFromTabButton:(NSButton*)tabButton ofTabViewItem:(NSTabViewItem*)tabViewItem
{
    STTabIconView *view= [STTabIconView installedIconInView:tabButton];
    [view removeFromSuperview];
}


- (void)removeIconFromExistingWindows
{
    STSafariEnumerateTabButton(^(NSButton* tabBtn, BOOL* stop){
        if (![tabBtn respondsToSelector:@selector(tabBarViewItem)]) {
            return;
        }
        NSTabViewItem* tabViewItem=((id(*)(id, SEL, ...))objc_msgSend)(tabBtn, @selector(tabBarViewItem));
        
        [self _removeIconFromTabButton:tabBtn ofTabViewItem:tabViewItem];

    });
}

@end



@implementation STTabIconView

+ (id)installedIconInView:(NSView *)view {
    return [view viewWithTag:STTAB_ICON_VIEW_TAG];
}

- (void)dealloc
{
//    [self unbind:NSHiddenBinding];
    [self unbind:@"image"];
    LOG(@"layer d");
}

@end

