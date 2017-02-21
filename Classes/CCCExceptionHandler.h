//
//  CCCExceptionHandler.h
//
//  Created by realtouchapp on 2016/6/7.
//  Copyright © 2016年 realtouchapp. All rights reserved.
//


#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSString *const CCCExceptionHandlerSignalExceptionName;
FOUNDATION_EXPORT NSString *const CCCExceptionHandlerSignalKey;
FOUNDATION_EXPORT NSString *const CCCExceptionHandlerAddressesKey;

@protocol CCCExceptionHandlerDelegate;

/**
 * Class use to catch uncaught exceptions and signals.
 *
 * @version 0.0.6
 * @author Chih-chieh Chang
 * @date 2017-02-21
 */
@interface CCCExceptionHandler : NSObject

@property (assign, nonatomic) id<CCCExceptionHandlerDelegate> delegate;
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;

+ (instancetype)sharedInstance;

@end

@protocol CCCExceptionHandlerDelegate <NSObject>
@required

- (void)cccExceptionHandler:(CCCExceptionHandler *)handler didReceiveException:(NSException *)exception;

@end

