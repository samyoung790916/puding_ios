//
//  PDEditQuesFrameModel.h
//  Pudding
//
//  Created by baxiang on 16/3/7.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDDIYQuesModel.h"
@interface PDEditQuesFrameModel : NSObject
@property (nonatomic, assign, readonly) CGRect contentBackFrame;
@property (nonatomic, assign, readonly) CGRect contentTextFrame;
@property (nonatomic,strong) PDDIYQuesModel *quesModel;
@property (nonatomic,assign) CGFloat cellHeight;
@end
