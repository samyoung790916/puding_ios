//
//  RBLogFileManagerDefault.m
//  RBLoger
//
//  Created by william on 16/10/17.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBLogFileManagerDefault.h"
#import "RBLogManager.h"

@implementation RBLogFileManagerDefault

/**
 *  当创建下一个文件的时候调用
 *
 */
-(void)didRollAndArchiveLogFile:(NSString *)logFilePath{
    [RBLogManager uploadActionWithRollFile:true];
}


@end
