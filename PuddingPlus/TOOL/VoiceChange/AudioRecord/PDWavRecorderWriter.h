//
//  PDWavRecorderWriter.h
//  Pudding
//
//  Created by baxiang on 16/5/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDAudioRecorder.h"
@interface PDWavRecorderWriter : NSObject<FileWriterForPDAudioRecorder>
@property (nonatomic, copy) NSString *filePath;
@end
