//
//  PDMessageCenterBaseCell.m
//  Pudding
//
//  Created by william on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterBaseCell.h"
#import "RBMessageHandle.h"
#import "UIImageView+YYWebImage.h"


@implementation PDMessageCenterBaseCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark ------------------- LazyLoad ------------------------
#pragma mark - 创建: 图片Icon
-(YYAnimatedImageView *)iconImgV{
    if (!_iconImgV) {
        YYAnimatedImageView * imgV = [[YYAnimatedImageView alloc]initWithImage:[UIImage imageNamed:@"icon_message_default"]];
        [self addSubview:imgV];
        _iconImgV = imgV;
    }
    return _iconImgV;
}

#pragma mark - 创建 -> 背景视图
-(UIImageView *)dialogBackV{
    if (!_dialogBackV) {
        UIImageView*vi = [[UIImageView alloc]initWithImage:[mImageByName(@"bg_message") resizableImageWithCapInsets:UIEdgeInsetsMake(34, 20, 10, 10)]];
        [self addSubview:vi];
        _dialogBackV = vi;
    }
    return _dialogBackV;
}
#pragma mark - 创建 -> 文本视图
-(YYLabel *)contentLab{
    if (!_contentLab) {
        YYLabel *lab = [[YYLabel alloc]initWithFrame:CGRectZero];
        lab.font = [UIFont systemFontOfSize:SX(FontSize + 1)];
        lab.numberOfLines = 0;
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = mRGBToColor(0x505a66);
        lab.textVerticalAlignment = 0;
        [self addSubview:lab];
        _contentLab = lab;
    }
    return _contentLab;
}


#pragma mark - 创建 -> 创建编辑按钮
-(UIButton *)editBtn{
    if (!_editBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 54, 54);
        btn.center = CGPointMake(kIconImgCenterX*0.40 , kIconImgCenterY);
        [btn setImage:[UIImage imageNamed:@"icon_message_unselected"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_message_selected"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _editBtn = btn;
    }
    return _editBtn;
}

#pragma mark - 创建 -> 时间视图
-(YYLabel *)timeLab{
    if (!_timeLab) {
        YYLabel *lab = [[YYLabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        lab.textColor = mRGBToColor(0xa2abb2);
        lab.font = [UIFont systemFontOfSize:FontSize - 3];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.backgroundColor = [UIColor clearColor];
        lab.opaque = true;
        [self addSubview:lab];
        _timeLab = lab;
    }
    return _timeLab;
}

#pragma mark - 创建 -> 线 Layer
-(CAShapeLayer *)linelayer{
    if (!_linelayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.backgroundColor = [UIColor colorWithWhite:0.894 alpha:1.000].CGColor;
        layer.strokeColor = [UIColor colorWithWhite:0.894 alpha:1.000].CGColor;
        layer.fillColor = [UIColor colorWithWhite:0.894 alpha:1.000].CGColor;
        [self.layer insertSublayer:layer atIndex:0];
        _linelayer = layer;
    }
    return _linelayer;
}

#pragma mark - 创建 -> 线的路径
-(UIBezierPath *)bezirPath{
    if (!_bezirPath) {
        UIBezierPath *path = [[UIBezierPath alloc]init];
        _bezirPath = path;
    }
    return _bezirPath;
}



#pragma mark ------------------- Action ------------------------
#pragma mark - action: 设置线的类型
-(void)setLineType:(PDLineType)lineType{
    _lineType = lineType;
//    [self setNeedsDisplay];
}



#pragma mark - action: 获取线条
-(CGRect)getLineRect{
    CGRect lineRect = CGRectZero;
    if (!self.edit) {
        switch (self.lineType) {
            case PDLineTypeStart: {
                lineRect = CGRectMake(kIconImgCenterX - klineWidth*0.5, kIconImgCenterY, klineWidth, self.height - kIconImgCenterY);
                break;
            }
            case PDLineTypeEnd: {
                lineRect = CGRectMake(kIconImgCenterX - klineWidth*0.5, 0, klineWidth, kIconImgCenterY);
                break;
            }
            case PDLineTypeMiddle: {
                lineRect = CGRectMake(kIconImgCenterX - klineWidth*0.5, 0, klineWidth, self.height);
                break;
            }
            case PDLineTypeSingle: {
                lineRect = CGRectZero;
                break;
            }
            default: {
                break;
            }
        }
    }else{
        switch (self.lineType) {
            case PDLineTypeStart: {
                lineRect = CGRectMake(kIconImgCenterX - klineWidth*0.5+SX(10), kIconImgCenterY, klineWidth, self.height - kIconImgCenterY);
                break;
            }
            case PDLineTypeEnd: {
                lineRect = CGRectMake(kIconImgCenterX - klineWidth*0.5+SX(10), 0, klineWidth, kIconImgCenterY);
                break;
            }
            case PDLineTypeMiddle: {
                lineRect = CGRectMake(kIconImgCenterX - klineWidth*0.5+SX(10), 0, klineWidth, self.height);
                break;
            }
            case PDLineTypeSingle: {
                lineRect = CGRectZero;
                break;
            }
            default: {
                break;
            }
        }
    }
    return  lineRect;
}





#pragma mark - action: 编辑点击
-(void)editClick{
    self.editBtn.selected = !self.editBtn.selected;
    self.model.selected = self.editBtn.selected;
    if (self.editCallBack) {
        self.editCallBack(self.model,self.indexPath);
    }
}

#pragma mark - action: 设置Icon图片
- (void)loadIconImage:(PDMessageCenterModel * ) modle {
    NSString * imageName = @"";
    switch ([modle.category intValue]){
       
        case CATEGORY_ALARM_WIFI_BREAK:
        {
            NSLog(@"网络断开") ;
            imageName = @"icon_message_wifi_off";
            [self.iconImgV setImage:mImageByName(imageName)];
        }
            break;
        case CATEGORY_ALARM_WIFI_CONNECT:
        {
            NSLog(@"网络连接") ;
            imageName = @"icon_message_wifi_on";
            [self.iconImgV setImage:mImageByName(imageName)];
        }
            break;
        case CATEGORY_ALARM_MASTER_NO_POWER:
        case CATEGORY_POWER_LOW:
        
        {
            NSLog(@"电量低") ;
            imageName = @"icon_message_battery2";
            [self.iconImgV setImage:mImageByName(imageName)];
        }
            break;
        case CATEGORY_MOTION_DTECTED:
        {
            imageName = @"icon_message_video2";
            [self.iconImgV setImage:mImageByName(imageName)];
            NSLog(@"视频侦测到移动");
        }
            break;
        //case MSGTYPE_ALARM_MEMBER_BIND_REQ:
        case CATEGORY_ALARM_ADD_NEW_MEMBER:
       
        case CATEGORY_BIND_REQ_ACCEPT:
        case CATEGORY_BIND_REQ_REJECT:
        case MSGTYPE_UNBIND:
        //case MSGTYPE_REMOVE_MEMBER_NOTIFY_FAMILY:
        case CATEGORY_MC_START_VIDEO:
        {
            imageName = @"icon_message_video";
            [self.iconImgV setImage:mImageByName(imageName)];
        }
            break;
        case CATEGORY_MESSAGECENTER_VIDEO:
        {
            imageName = @"icon_message_video";
            [self.iconImgV setImage:mImageByName(imageName)];
        }
            break;
        case CATEGORY_INVITE:
        case MSGTYPE_REMOVE_MEMBER:
        {
            imageName = modle.headimage;
            [self.iconImgV setImageWithURL:[NSURL URLWithString:imageName] placeholder:mImageByName(@"icon_message_default")];
            NSLog(@"用户头像");
        }
            break;
        case CATEGORY_NEWS:
        {
            // 消息中心图文消息样式
            imageName = @"message_center_icon_system_information";
            [self.iconImgV setImage:mImageByName(imageName)];
        }
            break;
        case CATEGORY_ALARM_REMIND:
        {
            if([self.model.unread intValue] == 0x06 || [modle.unread intValue]==0x07){
                self.contentTxtColor = mRGBToColor(0xc9c9c9);
                imageName = @"icon_message_clock_disable";
            }else{
                self.contentTxtColor = mRGBToColor(0x505a66);
                imageName = @"icon_message_clock2";
            }
            [self.iconImgV setImage:mImageByName(imageName)];
            NSLog(@"定时提醒");
        }
            break;
        
        default:
        {
            imageName = @"icon_message_default";
            [self.iconImgV setImage:mImageByName(imageName)];
        }
            break;
    }
}

#pragma mark - action: 获取对话背景图片长度
- (CGFloat)dialogBackWidth{
    CGFloat width = SX(270);
    return width;
}

-(void)setModel:(PDMessageCenterModel *)model{
    _model = model;
    [self loadIconImage:model];
    [self setNeedsDisplay];
}



static const CGFloat kTableRowHeight = 55;
+ (CGFloat)height:(PDMessageCenterModel *) modle{
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [modle.content boundingRectWithSize:CGSizeMake(SX(245), CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FontSize - 1]} context:nil];
    rect.size.height = MAX(CGRectGetHeight(rect), SX(20));
    modle.titleHeight = CGRectGetHeight(rect);
    CGFloat height = CGRectGetHeight(rect) + SX(28) + SX(30);
    switch ([modle.category intValue]) {
        case CATEGORY_MOTION_DTECTED:
        {
            if(modle.images.count > 0){
                height += SX(155) ;
                modle.cellHeight = MAX( rect.size.height + SX(60) + SX(153), kTableRowHeight + SX(153));
            }else{
                modle.cellHeight = MAX( rect.size.height + SX(60), kTableRowHeight);
            }
        }
            break;
        case CATEGORY_ALARM_MEMBER_BIND_REQ:
        {
            int read = [modle.unread intValue];
            if(read < 0x01){
                height += 50 ;
                //后加
                modle.cellHeight = MAX( rect.size.height + SX(60) + 50, kTableRowHeight + 50);
            }
        }
        break;
        default:
        {
            modle.cellHeight = MAX( rect.size.height + SX(60), kTableRowHeight);
        }
            break;
    }
    return modle.cellHeight;

}


@end
