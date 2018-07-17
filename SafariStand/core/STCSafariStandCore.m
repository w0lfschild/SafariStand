//
//  STCSafariStandCore.m
//  SafariStand

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC
#endif


#import "SafariStand.h"
#import <WebKit/WebKit.h>
#import "STTabProxyController.h"
#import "STWKClientHook.h"
#import "STCUserDefaultsController.h"
#import "STCVersion.h"

FOUNDATION_EXPORT NSString *kSafariBrowserWindowController;
FOUNDATION_EXPORT NSString *kSafariBrowserWindowControllerCstr;

@implementation STCSafariStandCore {
    BOOL _startup;
    NSMutableDictionary* _modules;
    NSMutableArray* _browserWindowKeyDownHandlers;
    
    NSMutableDictionary* _menuItemGroups;
}

static STCSafariStandCore *sharedInstance;

+ (STCSafariStandCore *)si
{
    kSafariBrowserWindowController = @"BrowserWindowController";
    kSafariBrowserWindowControllerCstr = @"BrowserWindowController";

    if (sharedInstance == nil){
        sharedInstance = [[STCSafariStandCore alloc]init];
        [sharedInstance startup];
    }
    
    return sharedInstance;
}


+ (id)mi:(NSString*)moduleClassName
{
    return [[STCSafariStandCore si]moduleForClassName:moduleClassName];
}


+ (NSString *)standLibraryPath:(NSString*)subPath
{
    NSString* path=[NSHomeDirectory() stringByStandardizingPath];
    path=[path stringByAppendingPathComponent:@"Library/Safari/Stand"];
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (!subPath) {
        return path;
    }
    
    path=[path stringByAppendingPathComponent:subPath];
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}


+ (NSUserDefaults *)ud
{
    return [[STCSafariStandCore si]userDefaults];
}


- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    
    _startup=NO;
    _missMatchAlertShown=NO;
    _userDefaults=[[STCUserDefaults alloc]initWithSuiteName:kSafariStandPrefDomain];
    _browserWindowKeyDownHandlers=[[NSMutableArray alloc]init];
    _menuItemGroups=[[NSMutableDictionary alloc]init];
    
    return self;
}


- (void)registerBuiltInModules
{
#define registerAndAddOrder(name) module=[self registerModule:name];if(module)[orderedModule addObject:module];
    
    id module;
    NSMutableArray* orderedModule=[[NSMutableArray alloc]initWithCapacity:16];
    registerAndAddOrder(@"STSToolbarModule");
    registerAndAddOrder(@"STPrefWindowModule");
    registerAndAddOrder(@"STConsolePanelModule");

    registerAndAddOrder(@"STSContextMenuModule"); //STQuickSearchModule
    registerAndAddOrder(@"STQuickSearchModule"); //STPrefWindowModule
    registerAndAddOrder(@"STBookmarkSeparator");
    registerAndAddOrder(@"STActionMessageModule");

    registerAndAddOrder(@"STSTabBarModule");

    registerAndAddOrder(@"STSTitleBarModule");
    registerAndAddOrder(@"STSDownloadModule");
    
    
    registerAndAddOrder(@"STActionMenuModule"); //must after STSToolbarModule
    registerAndAddOrder(@"STSidebarModule");
    registerAndAddOrder(@"STKeyHandlerModule");
    registerAndAddOrder(@"STTabPickerModule");
    registerAndAddOrder(@"STTabStockerModule");
    registerAndAddOrder(@"STFavoriteButtonModule");

    registerAndAddOrder(@"STSelfUpdaterModule");

#undef registerAndAddOrder
    
    for (id module in orderedModule) {
        if ([module respondsToSelector:@selector(modulesDidFinishLoading:)]) {
            [module modulesDidFinishLoading:self];
        }
    }
}


- (void)startup
{
    if(_startup)return;    
    _startup=YES;
    
    NSString* vstr=[[NSBundle bundleWithIdentifier:kSafariStandBundleID]objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    self.currentVersionString=vstr;

    NSString* shortVersionString=[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* revision=[shortVersionString stand_revisionFromVersionString];
    if (!revision) {
        revision=@"-";
    }
    _safariRevision=revision;

    NSDictionary* systemVersion=[NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];
    NSString* productVersion=systemVersion[@"ProductVersion"];
    if ([productVersion hasPrefix:@"10.14"]) {
        _systemCodeName=@"Mojave";
    } else if ([productVersion hasPrefix:@"10.13"]) {
        _systemCodeName=@"High Sierra";
    } else if ([productVersion hasPrefix:@"10.12"]) {
        _systemCodeName=@"Sierra";
    } else if ([productVersion hasPrefix:@"10.10"]) {
        _systemCodeName=@"Yosemite";
    }else if ([productVersion hasPrefix:@"10.11"]) {
        _systemCodeName=@"ElCapitan";
    }else{
        _systemCodeName=nil;
        [self showMissMatchAlert];
    }
    if ([_currentVersionString hasSuffix:@"Sierra"]) {
        _standCodeName=@"Sierra";
    } else if ([_currentVersionString hasSuffix:@"Yosemite"]) {
        _standCodeName=@"Yosemite";
    }else if ([_currentVersionString hasSuffix:@"ElCapitan"]) {
        _standCodeName=@"ElCapitan";
    }else{
        _standCodeName=nil;
    }


    LOG(@"Startup.... %@", revision);
    
    [self migrateSetting];

    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [NSNumber numberWithBool:YES], kpQuickSearchMenuEnabled,
                       [NSNumber numberWithDouble:250.0], kpSuppressTabBarWidthValue,
                       [NSNumber numberWithBool:YES], kpEnhanceVisualTabPicker,
                       [NSNumber numberWithBool:YES], kpSidebarIsRightSide,
                       @YES, kpSelfUpdateEnabled,
                       @0, kpPlusButtonModeKey,
                       //@"-", kpCheckedLatestVariosn,
                       nil];
    [self.userDefaults registerDefaults:dic];

    //アプリ終了をobserve
    [[NSNotificationCenter defaultCenter]addObserver:self
                        selector:@selector(noteAppWillTerminate:)
                        name:NSApplicationWillTerminateNotification object:NSApp];


    [self hookBrowserWindowKeyDown];
    [self setupStandMenu];
    
    [STTabProxyController si];
    STWKClientHook();

    [self registerBuiltInModules];

}


//保存のタイミング
- (void)noteAppWillTerminate:(NSNotification*)notification
{
    [self sendMessage:@selector(applicationWillTerminate:) toAllModule:self];
    
    [self.userDefaults synchronize];
}


- (id)registerModule:(NSString*)aClassName
{
    id aIns=nil;
    if(_modules==nil){
        _modules=[[NSMutableDictionary alloc]initWithCapacity:16];
    }
    Class aClass=NSClassFromString(aClassName);
    if([aClass instancesRespondToSelector:@selector(initWithStand:)] && [aClass respondsToSelector:@selector(canRegisterModule)]){
        if ([aClass canRegisterModule]) {
            aIns=[[aClass alloc]initWithStand:self];
            if(aIns)[_modules setObject:aIns forKey:aClassName];
        }else{
            NSLog(@"SafariStand:%@ was not loaded because of canRegisterModule==NO.", aClassName);
        }
    }
    return aIns;
}


- (id)moduleForClassName:(NSString*)name
{
    return [_modules objectForKey:name];
}


- (void)sendMessage:(SEL)selector toAllModule:(id)sender
{
    NSEnumerator *enumerator = [_modules objectEnumerator];
    for (id plgin in enumerator) {
        if([plgin respondsToSelector:selector]){
            objc_msgSend(plgin, selector, sender);
        }
    }
}

#pragma mark - StandMenu


//overrides same groupName
- (void)addGroupToStandMenu:(NSArray*)items name:(NSString*)groupName
{
    if (groupName && items) {
        [_menuItemGroups setObject:items forKey:groupName];
        [self updateStandMenu];
    }
}

- (void)removeGroupFromStandMenu:(NSString*)groupName
{
    if (groupName) {
        [_menuItemGroups removeObjectForKey:groupName];
        [self updateStandMenu];
    }
}


- (void)updateStandMenu
{
    [_standMenu removeAllItems];
    
    NSArray* keys=[[_menuItemGroups allKeys]sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSArray* key in keys) {
        NSArray* group=_menuItemGroups[key];
        for (NSMenuItem* itm in group) {
            [_standMenu addItem:itm];
        }
    }
}


- (void)setupStandMenu
{
    _standMenu=[[NSMenu alloc]initWithTitle:@"Stand"];
	NSMenu*	mainMenuBar=[NSApp mainMenu];
    NSMenuItem *myMenuItem=[[NSMenuItem alloc]initWithTitle:@"Stand" action:NULL keyEquivalent:@""];
	if(mainMenuBar && myMenuItem){

        [_standMenu setTitle:@"Stand"];
        [myMenuItem setSubmenu:_standMenu];

        NSInteger menuCount=8;
        if([mainMenuBar numberOfItems]<8) menuCount=[mainMenuBar numberOfItems];
        [mainMenuBar insertItem:myMenuItem atIndex:menuCount];
        
    }
}


#pragma mark - KeyDownHandler

- (void)registerBrowserWindowKeyDownHandler:(BrowserWindowKeyDownHandler)block
{
    [_browserWindowKeyDownHandlers addObject:[block copy]];
}

- (void)hookBrowserWindowKeyDown
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KZRMETHOD_SWIZZLING_("BrowserWindow", "keyDown:", void, call, sel)
        ^(id slf, NSEvent* event)
        {
            BOOL interrupt=NO;
            
            for (BrowserWindowKeyDownHandler block in _browserWindowKeyDownHandlers) {
                interrupt=block(event, slf);
                if (interrupt) {
                    break;
                }
            }
            
            if (!interrupt) {
                call(slf, sel, event);
            }
        }_WITHBLOCK;

    });
}

#pragma mark -

- (void)openWebSite
{
    NSURL* url=[NSURL URLWithString:@"https://github.com/anakinsk/SafariStand"];
    STSafariGoToURLWithPolicy(url, poNewTab);
}


- (void)showMissMatchAlert
{
    if (self.missMatchAlertShown) {
        return;
    }
    self.missMatchAlertShown=YES;
    [self performSelector:@selector(showMissMatchAlertM) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];

}


- (void)showMissMatchAlertM
{
    NSString* messageTitle=LOCALIZE(@"Miss Match Title");
    NSString* info=LOCALIZE(@"Miss Match Info");
    
    messageTitle=[NSString stringWithFormat:messageTitle, self.currentVersionString];
    NSAlert* alert=[[NSAlert alloc]init];
    alert.messageText=messageTitle;
    alert.informativeText=info;
    [alert addButtonWithTitle:@"OK"]; //1000
    [alert addButtonWithTitle:@"Visit SafariStand web site"]; //1001
    
    NSModalResponse returnCode=[alert runModal];
    if (returnCode==1001) {
        [self openWebSite];
    }

}


- (void)missMatchAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    //ok=1, visit=0
    [[alert window]orderOut:nil];
    if (returnCode==0) {
        [self openWebSite];
    }
}



- (void)migrateSetting
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kpSettingMigratedV1]) {
        return;
    }
    if ([self.userDefaults boolForKey:kpSettingMigratedV1]) {
        return;
    }
    
    NSArray* keys=@[kpActionMessageEnabled,
                    kpQuickSearchMenuEnabled,
                    kpQuickSearchMenuPlace,
                    kpQuickSearchMenuIsFlat,
                    kpQuickSearchTabPolicy,
                    kpQuickSearchMenuGroupingEnabled,
                    kpSwitchTabWithWheelEnabled,
                    kpSwitchTabWithOneKeyEnabled,
                    kpShowCopyLinkTagContextMenu,
                    kpCopyLinkTagAddTargetBlank,
                    kpShowCopyLinkAndTitleContextMenu,
                    kpShowCopyLinkTitleContextMenu,
                    kpShowClipWebArchiveContextMenu,
                    kpShowGoogleImageSearchContextMenu,
                    kpImprovePathPopupMenu,
                    kpSidebarShowsDefault,
                    kpSidebarIsRightSide,
                    kpSidebarWidth,
                    kpSquashContextMenuItemEnabled,
                    kpSquashContextMenuItemTags,
                    kpClassifyDownloadFolderBasicEnabled,
                    kpDownloadMonitorMovesToConsolePanel,
                    kpSuppressTabBarWidthEnabled,
                    kpSuppressTabBarWidthValue,
                    kpShowIconOnTabBarEnabled,
                    kpExpandAddressBarWidthEnabled,
                    kpExpandAddressBarWidthValue,
                    kpShowIconOnSidebarBookmarkEnabled,
                    kpShowBrowserWindowTitlebar,
                    kpEnhanceVisualTabPicker,
                    kpDontStackVisualTabPicker,
                    kpCtlTabTriggersVisualTabPicker,
                    @"HTFilePresetPopUpButtonCurrentValue_HTWebClipwin",
                    @"HTFilePresetPopUpButtonAllValues_HTWebClipwin"];
    
    for (NSString* key in keys) {
        id val=[[NSUserDefaults standardUserDefaults]objectForKey:key];
        if (val) {
            [self.userDefaults setObject:val forKey:key];
        }
    }
    
    [self.userDefaults setObject:[NSNumber numberWithBool:YES] forKey:kpSettingMigratedV1];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kpSettingMigratedV1];
    
    NSLog(@"SafariStand setting was migrated (V1)");
    
    [self.userDefaults synchronize];
}


@end


@implementation STCSafariStandCore (STCSafariStandCore_Pref)


- (id)objectForKey:(NSString*)key
{
    id result=(__bridge id)CFPreferencesCopyAppValue((__bridge CFStringRef)key, (CFStringRef)kSafariStandPrefDomain);
    return result;
}


- (BOOL)boolForKey:(NSString*)key
{
	return [self boolForKey:key defaultValue:NO];
}


- (BOOL)boolForKey:(NSString*)key  defaultValue:(BOOL)inValue
{
	BOOL	tempB;
    Boolean isValid;
    tempB=CFPreferencesGetAppBooleanValue((__bridge CFStringRef)key, (CFStringRef)kSafariStandPrefDomain, &isValid);
    
	if(isValid)	return tempB;
	else		return inValue;
}


- (id)mutableObjectForKey:(NSString*)key
{
	return [self makeMutablePlistCopy:[self objectForKey:key]];
}


- (void)setObject:(id)value forKey:(NSString*)key
{
    CFPreferencesSetAppValue( (__bridge CFStringRef) key, (__bridge CFPropertyListRef) value, (CFStringRef)kSafariStandPrefDomain);
}


- (void)setBool:(BOOL)value forKey:(NSString*)key
{
    CFPreferencesSetAppValue((__bridge CFStringRef)key, (CFPropertyListRef)(value ? kCFBooleanTrue : kCFBooleanFalse),
                             (CFStringRef)kSafariStandPrefDomain);
}


- (BOOL)synchronize
{
    return CFPreferencesAppSynchronize((CFStringRef)kSafariStandPrefDomain);
}



- (id)makeMutablePlistCopy:(id)plist
{
	id copyPlist;
	if ([plist isKindOfClass:[NSArray class]]) {
		copyPlist = [self makeMutableArrayCopy:plist];
	}else if ([plist isKindOfClass:[NSDictionary class]]) {
		copyPlist = [self makeMutableDictionaryCopy:plist];
	}else {
		copyPlist = plist;
	}
	return copyPlist;
}


- (NSMutableArray*)makeMutableArrayCopy:(NSArray*)array
{
	id  copy;
	int i;
    
	// Make copy
	copy = [[NSMutableArray alloc] initWithCapacity:[array count]];
    
    
	// Enumerate object
	for (i = 0; i < [array count]; i++) {
		id      object;
        
		object = [array objectAtIndex:i];
		if ([object isKindOfClass:[NSArray class]]) {
			object=[self makeMutableArrayCopy:object];
        }else if ([object isKindOfClass:[NSDictionary class]]) {
			object=[self makeMutableDictionaryCopy:object];
		}
		[copy addObject:object];
	}
    
	return copy;
}


- (NSMutableDictionary*)makeMutableDictionaryCopy:(NSDictionary*)dict
{
	id		copy = [[NSMutableDictionary alloc] initWithCapacity:[dict count]];
	
	// Enumerate object
	NSEnumerator* enumerator = [dict keyEnumerator];
    for (id key in enumerator) {
		id object;
		object = [dict objectForKey:key];
		if ([object isKindOfClass:[NSArray class]]) {
			object=[self makeMutableArrayCopy:object];
        }else if ([object isKindOfClass:[NSDictionary class]]) {
			object=[self makeMutableDictionaryCopy:object];
		}
		[copy setObject:object forKey:key];
	}
    
	return copy;
}


@end
