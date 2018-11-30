//
//  PDManageMembersCell.m
//  Pudding
//
//  Created by william on 16/3/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDManageMembersCell.h"
#import "PDManageCornerButton.h"
#import <YYKit/UIImageView+YYWebImage.h>

@interface PDManageMembersCell()
/** 左边按钮 */
@property (nonatomic, weak) PDManageCornerButton * leftBtn;
/** 右边按钮 */
@property (nonatomic, weak) PDManageCornerButton * rightBtn;
/** 左边详情 */
@property (nonatomic, weak) UILabel * leftDetail;
/** 右边详情 */
@property (nonatomic, weak) UILabel * rightDetail;
/** 管理员文本 */
@property (nonatomic, weak) UILabel *manageLab;

@property (nonatomic, strong) NSMutableArray * btnArray;

/** 当前的管理者 */
@property (nonatomic, assign) NSInteger currentManagerNum;

@end

@implementation PDManageMembersCell
#pragma mark ------------------- 初始化 ------------------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self ==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.btnArray addObject:self.leftBtn];
        [self.btnArray addObject:self.rightBtn];
        self.manageLab.hidden = YES;
        _currentManagerNum = 0;
    }
    return self;
}



#pragma mark - 创建 -> 按钮数组
-(NSMutableArray*)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}


#pragma mark - 创建 -> 右按钮
-(PDManageCornerButton *)rightBtn{
    if (!_rightBtn) {
        PDManageCornerButton * btn = [[PDManageCornerButton alloc]initWithImage:[UIImage imageNamed:@"avatar_member"]];
        btn.backgroundColor = [UIColor clearColor];
        btn.userInteractionEnabled = YES;
        btn.layer.cornerRadius = btn.frame.size.height *0.5;

        [self addSubview:btn];
        btn.clickBack = ^(){
            [self configBackModel:1];
            
        };
        _rightBtn = btn;
    }
    return _rightBtn;
}
#pragma mark - 创建 -> 左边按钮
-(PDManageCornerButton *)leftBtn{
    if (!_leftBtn) {
        PDManageCornerButton * btn = [[PDManageCornerButton alloc]initWithImage:[UIImage imageNamed:@"avatar_member"]];
        btn.backgroundColor = [UIColor clearColor];
        btn.userInteractionEnabled = YES;
        [self addSubview:btn];
        btn.clickBack = ^(){
            [self configBackModel:0];
        };
        _leftBtn = btn;
    }
    return _leftBtn;
    
}

#pragma mark - 创建 -> 左边详情
-(UILabel *)leftDetail{
    if (!_leftDetail) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width*0.5, 30)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14];
        lab.backgroundColor = [UIColor clearColor];
        [self addSubview:lab];
        _leftDetail = lab;
    }
    return _leftDetail;
}
#pragma mark - 创建 -> 右边详情
-(UILabel *)rightDetail{
    if (!_rightDetail) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width*0.5, 30)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14];
        lab.backgroundColor = [UIColor clearColor];
        [self addSubview:lab];
        _rightDetail = lab;
    }
    return _rightDetail;
}

#pragma mark - 创建 -> 管理员文本
-(UILabel *)manageLab{
    if (!_manageLab) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        lab.layer.cornerRadius = 10;
        lab.layer.masksToBounds = YES;
        lab.textAlignment = NSTextAlignmentCenter ;
        lab.textColor = [UIColor whiteColor];
        lab.text = NSLocalizedString( @"administrator", nil);
        lab.font = [UIFont systemFontOfSize:14];
        lab.layer. backgroundColor = mRGBToColor(0x637182).CGColor;
        [self addSubview:lab];
        _manageLab = lab;
    }
    return _manageLab;
    
    
}

#pragma mark - action: 回传数据模型
- (void)configBackModel:(NSInteger)num{
    if (self.callBack) {
        self.callBack(self.dataSource[num]);
    }
    
}

#pragma mark - action: 布局
-(void)layoutSubviews{
    [super layoutSubviews];

    self.leftBtn.center = CGPointMake(self.width*0.25, self.height *0.4);
    self.rightBtn.center = CGPointMake(self.width*0.75, self.height*0.4);
   
    self.leftDetail.center = CGPointMake(self.leftBtn.center.x, self.leftBtn.bottom+self.leftDetail.height*0.5);
    self.rightDetail.center = CGPointMake(self.rightBtn.center.x, self.rightBtn.bottom+self.rightDetail.height*0.5);

    if (_currentManagerNum==1) {
        self.manageLab.center = CGPointMake(self.leftDetail.center.x, self.leftDetail.bottom+self.manageLab.height*0.5);
    }else if (_currentManagerNum==2){
        self.manageLab.center = CGPointMake(self.rightDetail.center.x, self.rightDetail.bottom+self.manageLab.height*0.5);
    }else{
        self.manageLab.hidden = YES;
    }
    

}

#pragma mark - action: 设置数据模型


-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    self.leftDetail.hidden = YES;
    self.rightDetail.hidden = YES;
    _currentManagerNum = 0;
    RBUserModel * userModle = [dataSource mObjectAtIndex:0];
    if([userModle isKindOfClass:[RBDeviceUser class]]){
        
        self.leftDetail.text = userModle.name;
        self.leftBtn.hidden = NO;
        self.leftDetail.hidden = NO;
        if ([RBDataHandle.loginData.userid isEqual:userModle.userid]) {
            self.leftBtn.tagImgV.hidden = NO;
        }else{
            self.leftBtn.tagImgV.hidden = YES;
        }
        if([userModle.manager boolValue]){
            LogWarm(@"%@ 是管理员 ",userModle.name);
            self.manageLab.hidden = NO;
            _currentManagerNum = 1;
        }
        
        if(userModle.isAddModle){
            
            [self.leftBtn setMainImg:mImageByName(@"button_member_add_n") state:UIControlStateNormal];
            [self.leftBtn setMainImg:mImageByName(@"button_member_add_p") state:UIControlStateNormal];
            self.leftBtn.image = nil;
            [self.leftDetail setText:NSLocalizedString( @"add_new_member", nil)];
        }else{
            if (userModle.headimg.length>0) {

                [self.leftBtn setImageWithURL:[NSURL URLWithString:userModle.headimg] placeholder:nil options:YYWebImageOptionAvoidSetImage  completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    if (image) {
                        self.leftBtn.mainImg = image;
                    }else{
                        self.leftBtn.mainImg = [UIImage imageNamed:@"avatar_default"];
                        self.leftBtn.image = [UIImage imageNamed:@"avatar_member"];
                    }
                }];
                
            }else{
                [self.leftBtn setMainImg:[UIImage imageNamed:@"avatar_default"] state:UIControlStateNormal];
                self.leftBtn.image = [UIImage imageNamed:@"avatar_member"];
                
            }
        }
    }
    userModle = [dataSource mObjectAtIndex:1];
    if([userModle isKindOfClass:[RBDeviceUser class]]){
        
        self.rightDetail.text = userModle.name;
        self.rightBtn.hidden = NO;
        self.rightDetail.hidden = NO;
        if ([RBDataHandle.loginData.userid isEqual:userModle.userid]) {
            self.rightBtn.tagImgV.hidden = NO;
        }else{
            self.rightBtn.tagImgV.hidden = YES;
        }
        
        
        if([userModle.manager boolValue]){
            LogWarm(@"%@ 是管理员 ",userModle.name);
            self.manageLab.hidden = NO;
            _currentManagerNum = 2;
        }
        
        if(userModle.isAddModle){
            
            [self.rightBtn setMainImg:mImageByName(@"button_member_add_n") state:UIControlStateNormal];
            [self.rightBtn setMainImg:mImageByName(@"button_member_add_p") state:UIControlStateNormal];
            self.rightBtn.image = nil;
            [self.rightDetail setText:NSLocalizedString( @"add_new_member", nil)];
        }else{
            if (userModle.headimg.length>0) {
                [self.rightBtn setImageWithURL:[NSURL URLWithString:userModle.headimg] placeholder:nil options:YYWebImageOptionAvoidSetImage  completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    if (image) {
                        self.rightBtn.mainImg = image;
                    }else{
                        self.rightBtn.mainImg = [UIImage imageNamed:@"avatar_default"];
                        self.rightBtn.image = [UIImage imageNamed:@"avatar_member"];
                    }
                }];
            }else{
                [self.rightBtn setMainImg:[UIImage imageNamed:@"avatar_default"] state:UIControlStateNormal];
                self.rightBtn.image = [UIImage imageNamed:@"avatar_member"];
                
            }
        }
    }
    [self layoutSubviews];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
