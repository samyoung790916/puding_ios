//
//  PDMessageCenterManageCell.m
//  Pudding
//
//  Created by zyqiong on 16/9/18.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterManageCell.h"
#import "UIImageView+YYWebImage.h"
#import "TimedataFactory.h"


@implementation PDMessageCenterManageCell
static const CGFloat kContentLabTopEdge = 13;//文本内容距离背景图片的上方的留白
static const CGFloat kDialogLeftEdge =  10;//对话背景图距离左边Icon 的留白
static const CGFloat kTimeEdge = 13;//时间视图距离左边的距离
static const CGFloat kTimeLabHeight = 20;//时间视图的高度

- (void)setModel:(PDMessageCenterModel *)model {
    [super setModel:model];
    NSArray *urls = model.urls;
    NSString *content = @"";
    if (urls.count > 0) {
        NSDictionary *dataDict = [urls firstObject];
        content = [dataDict objectForKey:@"content"];
        NSString *icon = [dataDict objectForKey:@"icon"];
        if (icon != nil && ![icon isEqualToString:@""]) {
            [self.iconImgV setImageWithURL:[NSURL URLWithString:icon] placeholder:[UIImage imageNamed:@"icon_message_default"]];
        }
    }
    self.contentLab.text = content;
    CGSize size = self.iconImgV.frame.size;
    if (model.isEdit) {
        if (!self.isEdit) {
            [UIView animateWithDuration:kAnimateDuration animations:^{
                self.iconCenter = CGPointMake(kIconImgCenterX+SX(10), kIconImgCenterY);
                [self.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                }];
                [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(model.titleHeight);
                }];
            }];
        } else {
            __weak typeof(self) weakself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakself;
                strongSelf.iconCenter = CGPointMake(kIconImgCenterX+SX(10), kIconImgCenterY);
                [strongSelf.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                }];
                
                [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(model.titleHeight);
                }];
                
            });
        }
    } else {
        if (self.isEdit) {
            [UIView animateWithDuration:kAnimateDuration animations:^{
                self.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
                [self.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                }];
                [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(model.titleHeight);
                }];
                
            }];
        } else {
            __weak typeof(self) weakself = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakself;
                strongSelf.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
                [strongSelf.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                }];
                [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(model.titleHeight);
                }];
                
            });
        }
    }
    self.edit = model.isEdit;
    /** 设置编辑按钮 */
    self.editBtn.hidden = !model.isEdit;
    self.editBtn.selected = model.selected;
    
    /** 时间文本 */
    self.timeLab.text =  getTimeWithTimeInterval(model.timestamp);
    
    [self setNeedsDisplay];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.autoresizingMask = UIViewAutoresizingNone;
        self.backgroundView = [UIView new];
        self.opaque = true;
        
        // 编辑状态
        self.edit = NO;
        // icon 的中心
        self.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
        CGSize size = self.iconImgV.frame.size;
        [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kIconImgCenterX- size.width*.5);
            make.top.mas_equalTo(kIconImgCenterY - size.height * .5);
            make.size.mas_equalTo(size);
        }];
        
        // 时间文本
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
        
        UIButton *contentButton = [[UIButton alloc] init];
        [contentButton addTarget:self action:@selector(contentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:contentButton];
        [contentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self.contentLab);
            make.width.mas_equalTo(self.contentLab.mas_width);
            make.bottom.mas_equalTo(self.contentLab.mas_bottom);
        }];
        
    }
    return self;
}

- (void)contentButtonClick {
    if (_callback) {
        _callback();
    }
}

#pragma mark - action: 布局
-(void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.getLineRect];
    self.linelayer.path = path.CGPath;
    
}
@end
