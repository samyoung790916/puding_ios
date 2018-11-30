//
//  PDEditQuesFrameModel.m
//  Pudding
//
//  Created by baxiang on 16/3/7.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDEditQuesFrameModel.h"

@implementation PDEditQuesFrameModel


-(void)setQuesModel:(PDDIYQuesModel *)quesModel{
    _quesModel = quesModel;
    CGSize contentSize = [self sizeWithText:_quesModel.text];
    // CGFloat cellWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat margin = 10;
    _contentTextFrame = CGRectMake(20, 10, contentSize.width, contentSize.height);
    _contentBackFrame = CGRectMake(60, 10, contentSize.width+35, contentSize.height+20);
    _cellHeight = MAX(CGRectGetMaxY(_contentTextFrame), CGRectGetMaxY(_contentBackFrame)) + margin;
}
- (CGSize)sizeWithText:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 120, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                              context:nil].size;
}

@end
