//
//  PDSpeechFrameModel.m
//  Pudding
//
//  Created by baxiang on 16/2/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDSpeechFrameModel.h"

@implementation PDSpeechFrameModel


-(void)setContentModel:(PDSpeechTextModel *)contentModel{
    _contentModel = contentModel;
    CGSize contentSize = [self sizeWithText:_contentModel.text];
    CGFloat margin = 10;
     CGFloat contentHeight =MAX(contentSize.height+20, 45);
    _contentTextFrame = CGRectMake(10, 0, contentSize.width,contentHeight);
    //CGFloat contentHeight =MAX(contentSize.height+20, 45);
    _contentBackFrame = CGRectMake(70, 10, contentSize.width+30, contentHeight);
    _cellHeight = MAX(CGRectGetMaxY(_contentTextFrame), CGRectGetMaxY(_contentBackFrame)) + margin;
    _contentHeadFrame = CGRectMake(20, _contentBackFrame.origin.y+_contentBackFrame.size.height-45, 45, 45);
}

- (CGSize)sizeWithText:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 130, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                              context:nil].size;
}
@end
