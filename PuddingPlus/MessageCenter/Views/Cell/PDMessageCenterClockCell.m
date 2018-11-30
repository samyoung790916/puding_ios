//
//  PDAlarmClockCell.m
//  Pudding
//
//  Created by william on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterClockCell.h"
#import "UIImage+TintColor.h"
#import "RBMessageHandle.h"
#import "TimedataFactory.h"

@interface PDMessageCenterClockCell()
/** 重置按钮 */
@property (nonatomic, weak) UIButton *resetBtn;
@end


@implementation PDMessageCenterClockCell
#pragma mark ------------------- 初始化 ------------------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initial];
    }
    
    return self;
}

static const CGFloat kContentLabTopEdge = 8;//文本内容距离背景图片的上方的留白
static const CGFloat kDialogLeftEdge = 10;//对话背景图距离左边Icon 的留白
static const CGFloat kTimeEdge = 13;//时间视图距离左边的距离
static const CGFloat kTimeLabHeight = 20;//时间视图的高度
#pragma mark - inital
- (void)initial{
    /** 编辑状态 */
    self.edit = NO;
    
    
    /** icon 的中心 */
    self.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
    /** Icon */
    self.iconImgV.center = self.iconCenter;
    
    
    
    /** 时间文本的 frame */
    self.timeLabFrame = CGRectMake(SX(80), self.iconImgV.top, 200, kTimeLabHeight);
    /** 时间文本 */
    self.timeLab.frame = self.timeLabFrame;
    
    
    /** 内容文本的 frame */
    self.contentRect = CGRectMake(SX(80), self.timeLab.bottom + kContentLabTopEdge , self.dialogBackWidth - 0.8*kDialogLeftEdge, SX(20));
    /** 内容文本颜色 */
    self.contentTxtColor = [UIColor blackColor];
    /** 文本 */
    self.contentLab.textColor = self.contentTxtColor;
    
    
    /** 编辑按钮 */
    self.editBtn.hidden = YES;

    /** 重置按钮 */
    self.resetBtn.hidden = NO;
    self.resetBtn.center = CGPointMake(SC_WIDTH - SX(60),self.timeLab.center.y);
    //线
    self.linelayer.path = [UIBezierPath bezierPathWithRect:CGRectZero].CGPath;

    
}


#pragma mark - 创建 -> 重置按钮
-(UIButton *)resetBtn{
    if (!_resetBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 50, 50);
        [btn setImage:mImageByName(@"icon_message_revoke") forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
        _resetBtn = btn;
    }
    return _resetBtn;
}

#pragma mark - action: 重置闹钟点击回调
- (void)resetClick{
    if (self.resetCallBack) {
        self.resetCallBack(self.indexPath,self.model);
    }
}

#pragma mark - action: 获取线条
//static inline CGRect getLineRect(BOOL edit,PDLineType lineType,CGFloat height){
//    CGRect lineRect = CGRectZero;
//    if (!edit) {
//        switch (lineType) {
//            case PDLineTypeStart: {
//                lineRect = CGRectMake(kIconImgCenterX - klineWidth*0.5, kIconImgCenterY, klineWidth, height - kIconImgCenterY);
//                break;
//            }
//            case PDLineTypeEnd: {
//                lineRect = CGRectMake(kIconImgCenterX - klineWidth*0.5, 0, klineWidth, kIconImgCenterY);
//                break;
//            }
//            case PDLineTypeMiddle: {
//                lineRect = CGRectMake(kIconImgCenterX - klineWidth*0.5, 0, klineWidth, height);
//                break;
//            }
//            case PDLineTypeSingle: {
//                lineRect = CGRectZero;
//                break;
//            }
//            default: {
//                break;
//            }
//        }
//    }else{
//        switch (lineType) {
//            case PDLineTypeStart: {
//                lineRect = CGRectMake(kIconImgCenterX - klineWidth*0.5+SX(10), kIconImgCenterY, klineWidth, height - kIconImgCenterY);
//                break;
//            }
//            case PDLineTypeEnd: {
//                lineRect = CGRectMake(kIconImgCenterX - klineWidth*0.5+SX(10), 0, klineWidth, kIconImgCenterY);
//                break;
//            }
//            case PDLineTypeMiddle: {
//                lineRect = CGRectMake(kIconImgCenterX - klineWidth*0.5+SX(10), 0, klineWidth, height);
//                break;
//            }
//            case PDLineTypeSingle: {
//                lineRect = CGRectZero;
//                break;
//            }
//            default: {
//                break;
//            }
//        }
//    }
//    return  lineRect;
//}

#pragma mark - action: 画
//-(void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//    /** 画线 */
//    CGRect lineRect = getLineRect(self.edit,self.lineType,self.height);
//    [[UIColor colorWithWhite:0.894 alpha:1.000] set] ;
//    UIBezierPath * path = [UIBezierPath bezierPathWithRect:lineRect];
//    [path fill];
//    
//}


#pragma mark - action: 设置数据
-(void)setModel:(PDMessageCenterModel *)model{
    [super setModel:model];
//    /** 设置Icon图片 */
//    [self loadIconImage:model];
    
    /** 获取内容 */
    if(![model.content length]){
        model.content = @"";
    }
    self.content = model.content;
    
    /** 新的文本的 frame */
    self.contentRect = CGRectMake(self.iconImgV.right + kTimeEdge, self.timeLab.bottom +kContentLabTopEdge , self.dialogBackWidth - 0.8*kDialogLeftEdge, model.titleHeight);

    
    /** 新的背景图片的 frame */
//    self.backImgRect = CGRectMake(self.backImgRect.origin.x, self.backImgRect.origin.y, self.backImgRect.size.width, model.titleHeight + SX(25));
    
    /** 设置编辑按钮 */
    self.editBtn.hidden = !model.isEdit;
    self.editBtn.selected = model.selected;
    
    if (model.isEdit) {
        if (!self.isEdit) {
            [UIView animateWithDuration:kAnimateDuration animations:^{
                self.iconCenter = CGPointMake(kIconImgCenterX+SX(10), kIconImgCenterY);
                self.iconImgV.center = self.iconCenter;

                self.contentRect = CGRectMake(SX(90) , self.timeLab.bottom +kContentLabTopEdge , self.dialogBackWidth - 0.8*kDialogLeftEdge, model.titleHeight);
                self.contentLab.frame = self.contentRect;
                self.timeLabFrame = CGRectMake(SX(90), self.iconImgV.top, 200, kTimeLabHeight);
                self.timeLab.frame = self.timeLabFrame;
            }];
        }else{
            self.iconCenter = CGPointMake(kIconImgCenterX+SX(10), kIconImgCenterY);
            self.iconImgV.center = self.iconCenter;
            
            self.contentRect = CGRectMake(SX(90) , self.timeLab.bottom +kContentLabTopEdge , self.dialogBackWidth - 0.8*kDialogLeftEdge, model.titleHeight);
            self.contentLab.frame = self.contentRect;
            self.timeLabFrame = CGRectMake(SX(90), self.iconImgV.top, 200, kTimeLabHeight);
            self.timeLab.frame = self.timeLabFrame;
            
        }
    }else{
        if (self.isEdit) {
            [UIView animateWithDuration:kAnimateDuration animations:^{
                self.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
                self.iconImgV.center = self.iconCenter;

                self.contentRect = CGRectMake(SX(80) , self.timeLab.bottom +kContentLabTopEdge , self.dialogBackWidth - 0.8*kDialogLeftEdge, model.titleHeight);
                self.contentLab.frame = self.contentRect;
                
                self.timeLabFrame = CGRectMake(SX(80), self.iconImgV.top, 200, kTimeLabHeight);
                self.timeLab.frame = self.timeLabFrame;

            }];
        }else{
            self.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
            self.iconImgV.center = self.iconCenter;

            self.contentRect = CGRectMake(SX(80) , self.timeLab.bottom +kContentLabTopEdge , self.dialogBackWidth - 0.8*kDialogLeftEdge, model.titleHeight);
            self.contentLab.frame = self.contentRect;
            
            self.timeLabFrame = CGRectMake(SX(80), self.iconImgV.top, 200, kTimeLabHeight);
            self.timeLab.frame = self.timeLabFrame;
        }
    }
    self.edit = model.isEdit;
    
    /** 设置重置按钮 */
    self.resetBtn.hidden = YES;
    
    /** 如果是定时提醒 */
    if ([model.category intValue]== CATEGORY_ALARM_REMIND) {
        if ([model.unread intValue]== !0x06 && [model.unread intValue]!=0x07) {
            if (!model.isEdit) {
                _resetBtn.hidden = false;
            }else{
                _resetBtn.hidden = true;
            }
        }else{
            _resetBtn.hidden = true;
        }
    }
    /** 设置内容文本 */
    self.contentLab.text = self.content;
    self.contentLab.textColor = self.contentTxtColor;
    /** 时间文本 */
    self.timeLab.text = getTimeWithTimeInterval(model.timestamp);
    
    [self setNeedsDisplay];
}




#pragma mark - action: 布局
-(void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.getLineRect];
    self.linelayer.path = path.CGPath;
}
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    self.iconImgV.center = CGPointMake(kIconImgCenterX, kIconImgCenterY);
//    self.editBtn.center = CGPointMake(kIconImgCenterX*0.35 , kIconImgCenterY);
//    self.resetBtn.center = CGPointMake(self.editBtn.center.x - SX(5), self.editBtn.center.y + SX(5));
//    self.contentLab.frame = self.contentRect;
//    self.timeLab.frame = CGRectMake(self.iconImgV.right + kTimeEdge, self.iconImgV.top, 200, kTimeLabHeight);
//
////    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.getLineRect];
////    self.linelayer.path = path.CGPath;
//}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
