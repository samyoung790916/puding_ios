//
//  PDSpeechFrameModel.h
//  Pudding
//
//  Created by baxiang on 16/2/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDSpeechTextModel.h"
@interface PDSpeechFrameModel : NSObject

@property (nonatomic,strong)PDSpeechTextModel *contentModel;
@property (nonatomic, assign, readonly) CGRect contentBackFrame;
@property (nonatomic, assign, readonly) CGRect contentTextFrame;
@property (nonatomic, assign, readonly) CGRect contentHeadFrame;
@property (nonatomic, assign) CGFloat cellHeight;
@end
