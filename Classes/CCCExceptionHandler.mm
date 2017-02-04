//
//  CCCExceptionHandler.m
//
//  Created by realtouchapp on 2016/6/7.
//  Copyright © 2016年 realtouchapp. All rights reserved.
//

#import "CCCExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"

NSString *const CCCExceptionHandlerSignalExceptionName = @"CCCExceptionHandlerSignalExceptionName";
NSString *const CCCExceptionHandlerSignalKey = @"CCCExceptionHandlerSignalKey";
NSString *const CCCExceptionHandlerAddressesKey = @"CCCExceptionHandlerAddressesKey";
volatile int32_t CCCExceptionCount = 0;
const int32_t CCCExceptionMaximum = 10;
const NSInteger CCCExceptionHandlerSkipAddressCount = 4;
const NSInteger CCCExceptionHandlerReportAddressCount = 5;

@interface CCCExceptionHandler ()
@property (nonatomic) BOOL didCaughtException;
@end

@implementation CCCExceptionHandler

static void CCCUncaughtExceptionHandler(NSException *exception) {
    int32_t exceptionCount = OSAtomicIncrement32(&CCCExceptionCount);
    if (exceptionCount > CCCExceptionMaximum) {
        [CCCExceptionHandler sharedInstance].didCaughtException = NO;
        return;
    }
#if DEBUG
    NSLog(@"uncaught exception");
#endif
    
    [CCCExceptionHandler sharedInstance].didCaughtException = YES;
    
    NSArray *callStack = [CCCExceptionHandler _backtrace];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:exception.userInfo];
    [userInfo setObject:callStack forKey:CCCExceptionHandlerAddressesKey];
    exception = [NSException exceptionWithName:exception.name
                                        reason:exception.reason
                                      userInfo:userInfo];
    
    [[CCCExceptionHandler sharedInstance] performSelectorOnMainThread:@selector(_handleException:)
                                                           withObject:exception
                                                        waitUntilDone:YES];
}

static void CCCRunLoopArrayApplierFunction(const void *value, void *context) {
    CFRunLoopRunInMode((CFStringRef)value, 0.1, false);
}

static void CCCSignalHandler(int signal) {
    int32_t exceptionCount = OSAtomicIncrement32(&CCCExceptionCount);
    if (exceptionCount > CCCExceptionMaximum) {
        return;
    }
#if DEBUG
    NSLog(@"uncaught signal");
#endif
    if ([CCCExceptionHandler sharedInstance].didCaughtException) {
        return;
    }
    
    NSArray *callStack = [CCCExceptionHandler _backtrace];
    NSDictionary *userInfo = @{CCCExceptionHandlerSignalKey:@(signal), CCCExceptionHandlerAddressesKey:callStack};
    NSException *exception = [NSException exceptionWithName:CCCExceptionHandlerSignalExceptionName
                                                     reason:[NSString stringWithFormat:@"Signal %d was raised.", signal]
                                                   userInfo:userInfo];
    
    [[CCCExceptionHandler sharedInstance] performSelectorOnMainThread:@selector(_handleException:)
                                                           withObject:exception
                                                        waitUntilDone:YES];
}

+ (instancetype)sharedInstance {
    static CCCExceptionHandler *shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[CCCExceptionHandler alloc] init];
    });
    
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _enabled = NO;
        _didCaughtException = NO;
    }
    return self;
}

- (void)dealloc {
    NSSetUncaughtExceptionHandler(NULL);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    
    if (_enabled) {
        signal(SIGABRT, CCCSignalHandler);
        signal(SIGILL, CCCSignalHandler);
        signal(SIGSEGV, CCCSignalHandler);
        signal(SIGFPE, CCCSignalHandler);
        signal(SIGBUS, CCCSignalHandler);
        signal(SIGPIPE, CCCSignalHandler);
        NSSetUncaughtExceptionHandler(&CCCUncaughtExceptionHandler);
    }
    else {
        NSSetUncaughtExceptionHandler(NULL);
        signal(SIGABRT, SIG_DFL);
        signal(SIGILL, SIG_DFL);
        signal(SIGSEGV, SIG_DFL);
        signal(SIGFPE, SIG_DFL);
        signal(SIGBUS, SIG_DFL);
        signal(SIGPIPE, SIG_DFL);
    }
    
}

+ (NSArray*)_backtrace {
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i = CCCExceptionHandlerSkipAddressCount;
         i < CCCExceptionHandlerSkipAddressCount+CCCExceptionHandlerReportAddressCount;
         i ++) {
        
        if (NULL != strs[i]) {
            NSString *backtraceString = [NSString stringWithUTF8String:strs[i]];
            if (backtraceString) {
                [backtrace addObject:backtraceString];
            }
        }
    }
    free(strs);
    
    return backtrace;
}

- (void)_handleException:(NSException*)exception {
    CCCExceptionHandler *handler = [CCCExceptionHandler sharedInstance];
    if (handler.delegate && [handler.delegate respondsToSelector:@selector(cccExceptionHandler:didReceiveException:)]) {
        [handler.delegate cccExceptionHandler:handler didReceiveException:exception];
    }
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"喔喔！程式發生了異常！"
//                                                    message:[NSString stringWithFormat:@"為了讓 App 可以更好，請將錯誤訊息回報給開發人員！\n\n"@"異常原因如下:\n%@\n%@",exception.reason,[exception.userInfo objectForKey:CCCExceptionHandlerAddressesKey]]
//                                                   delegate:self
//                                          cancelButtonTitle:@"退出"
//                                          otherButtonTitles:@"回報", nil];
//    [alert show];
    
    
//    while (1) {
//        CFRunLoopRef runLoop = CFRunLoopGetMain();
//        CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
//        CFArrayApplyFunction(allModes, CFRangeMake(0, CFArrayGetCount(allModes)), CCCRunLoopArrayApplierFunction, NULL);
//        CFRelease(allModes);
//    }
    
//    if ([[exception name] isEqual:CCCExceptionHandlerSignalExceptionName]) {
//        kill(getpid(), [[[exception userInfo] objectForKey:CCCExceptionHandlerSignalKey] intValue]);
//    }
//    else {
//        [exception raise];
//    }
}

@end

#pragma clang diagnostic pop
