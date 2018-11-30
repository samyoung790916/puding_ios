//
//  PDMessageCenterSystemCell.m
//  Pudding
//
//  Created by william on 16/2/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterNormalCell.h"
#import "PDMessageCenterModel.h"
#import "RBMessageHandle.h"
#import "TimedataFactory.h"

@interface PDMessageCenterNormalCell()

@end

@implementation PDMessageCenterNormalCell



#pragma mark ------------------- 初始化 ------------------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /** 初始化 */
        [self initial];


    }
    return self;
}



static const CGFloat kContentLabTopEdge = 8;//文本内容距离背景图片的上方的留白
static const CGFloat kDialogLeftEdge = 10;//对话背景图距离左边Icon 的留白
static const CGFloat kTimeEdge = 13;//时间视图距离左边的距离
static const CGFloat kTimeLabHeight = 20;//时间视图的高度
#pragma mark - action: 初始化
- (void)initial{
    /** 编辑状态 */
    self.edit = NO;
    
    
    /** icon 的中心 */
    self.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
    CGSize size = self.iconImgV.frame.size;
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kIconImgCenterX- size.width*.5);
        make.top.mas_equalTo(kIconImgCenterY - size.height * .5);
        make.size.mas_equalTo(size);
    }];
    
     /** 时间文本 */
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgV.mas_right).offset(kTimeEdge);
        make.top.mas_equalTo(self.iconImgV.mas_top);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(kTimeLabHeight);
    }];
     /** 内容文本 */
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLab);
        make.top.mas_equalTo(self.timeLab.mas_bottom).offset(kContentLabTopEdge);
        make.width.mas_equalTo(self.dialogBackWidth - 0.8*kDialogLeftEdge);
    }];
    /** 编辑按钮 */
    self.editBtn.hidden = YES;

    self.linelayer.path = [UIBezierPath bezierPathWithRect:CGRectZero].CGPath;

    
}

#pragma mark - action: 设置数据
-(void)setModel:(PDMessageCenterModel *)model{
    [super setModel:model];
    /** 重设文本 */
    if(![model.content length]){
        model.content = @"";
    }

    NSString *contentStr = model.content;
    if ([model.category intValue] == CATEGORY_MC_START_VIDEO) {
        if (model.videoContent != nil && ![model.videoContent isEqualToString:@""]) {
            contentStr = model.videoContent;
        }
    }
    self.content = contentStr;
    /** 编辑按钮 */
    self.editBtn.hidden = !model.isEdit;
    self.editBtn.selected = model.selected;
    
    
    /** 内容文本 */
    self.contentLab.text = self.content;
//    self.contentLab.textColor = self.contentTxtColor;
    
    /** 时间文本 */
    self.timeLab.text = getTimeWithTimeInterval(model.timestamp);
    
    CGSize size = self.iconImgV.frame.size;
    if (model.isEdit) {
        if (!self.isEdit) {
            [UIView animateWithDuration:kAnimateDuration animations:^{
                self.iconCenter = CGPointMake(kIconImgCenterX+SX(10), kIconImgCenterY);
                
                [self.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                    make.top.mas_equalTo(self.iconCenter.y - size.height * .5);
                    make.size.mas_equalTo(size);
                }];
                
                [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(model.cellHeight-20);
                }];
  
            }];
        }else{
            self.iconCenter = CGPointMake(kIconImgCenterX+SX(10), kIconImgCenterY);
            [self.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                make.top.mas_equalTo(self.iconCenter.y - size.height * .5);
                make.size.mas_equalTo(size);
            }];
            [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(model.cellHeight-20);
            }];
   
        }
    }else{
        if (self.isEdit) {
            [UIView animateWithDuration:kAnimateDuration animations:^{
                self.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);

                [self.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                    make.top.mas_equalTo(self.iconCenter.y - size.height * .5);
                    make.size.mas_equalTo(size);
                }];
                [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(model.cellHeight-20);
                }];
  
            }];
        }else{
            self.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
            [self.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                make.top.mas_equalTo(self.iconCenter.y - size.height * .5);
                make.size.mas_equalTo(size);
            }];
            [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(model.cellHeight-20);
            }];

        }
    }
    self.edit = model.isEdit;
    [self setNeedsDisplay];
}

#pragma mark - action: 布局
-(void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.getLineRect];
    self.linelayer.path = path.CGPath;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
