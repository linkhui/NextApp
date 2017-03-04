//
//  ALMUtility.h
//  Pods
//
//  Created by wmy on 15/11/23.
//
//

#import <Foundation/Foundation.h>

#define theDefaultCenter ([NSNotificationCenter defaultCenter])
#define theFileMgr ([NSFileManager defaultManager])
#define theUserDefaults ([NSUserDefaults standardUserDefaults])

#define valuestr(s) ([NSString stringWithUTF8String:#s])
#define onlyMainThread NSAssert([NSThread isMainThread], @"only mainthread")
#define sleep(s) \
    ;            \
    [NSThread sleepForTimeInterval:s];

#define RGBA(r, g, b, a) \
    [UIColor colorWithRed:((float)r) / 255.f green:((float)g) / 255.f blue:((float)b) / 255.f alpha:a]
#define RGB(r, g, b) RGBA(r, g, b, 1.0f)
#define ColorWithHex(hexValue)                                                                       \
    RGBA(((hexValue & 0xFF000000) >> 24), ((hexValue & 0xFF0000) >> 16), ((hexValue & 0xFF00) >> 8), \
         ((float)(hexValue & 0x00FF)) / 255.f)

#ifndef DEF_SINGLETON
#define DEF_SINGLETON                                    \
    +(instancetype)instance {                            \
        static dispatch_once_t once;                     \
        static id __singleton__;                         \
        dispatch_once(&once, ^{                          \
            __singleton__ = [[[self class] alloc] init]; \
        });                                              \
        return __singleton__;                            \
    }
#endif

#define SuppressPerformSelectorLeakWarning(Stuff)                                                                   \
    do {                                                                                                            \
        _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") Stuff; \
        _Pragma("clang diagnostic pop")                                                                             \
    } while (0)

#define SuppressPerformDeprecatedWarning(Stuff)                                                                   \
    do {                                                                                                          \
        _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") Stuff; \
        _Pragma("clang diagnostic pop")                                                                           \
    } while (0)

BOOL isNullForALM(id);
int toInt(id);
BOOL isEmptyString(id);
NSTimeInterval tNow();
extern NSString* str(NSString* fmt, ...);

unsigned long long sizeForPath(NSString* path, BOOL isRecursion);



