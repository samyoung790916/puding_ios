//
//  NSObject+RBLogHelper.h
//  Pods
//
//  Created by kieran on 2017/5/11.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (RBLogHelper)

#ifdef TARGET_OS_IOS

@property (nonatomic,assign) BOOL enablePushLog;

#endif



@end
