//
//  PDSpeechTextModel.h
//  Pudding
//
//  Created by baxiang on 16/2/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDSpeechTextModel : NSObject

@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) BOOL isTipMessage;
@end
