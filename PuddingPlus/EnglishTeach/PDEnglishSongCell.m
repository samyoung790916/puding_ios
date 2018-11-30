//
//  PDEnglishSongCell.m
//  Pudding
//
//  Created by baxiang on 16/7/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDEnglishSongCell.h"
#import "RBResourceManager.h"
@interface PDEnglishSongCell ()
/** 动画image */
@property (weak, nonatomic) UIImageView *animateImg;
/** 图片 */
@property (nonatomic, weak) UIImageView * iconImg;
/** 文本 */
@property (nonatomic, weak) UILabel * titleLab;
/** 底部线 */
@property (nonatomic, weak) UIView  * bottomLine;
/** 收藏按钮 */
@property (nonatomic, weak) UIButton *collectBtn;
@end

@implementation PDEnglishSongCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
- (void)setModel:(PDFeatureModle *)model {
    _model = model;
    //设置图片
    if (model.img) {
        NSString * str = [NSString stringWithFormat:@"%@",model.img];
        if (![model.img isKindOfClass:[NSNull class]]) {
            [self.iconImg setImageWithURL:[NSURL URLWithString:str] placeholder:[UIImage imageNamed:NSLocalizedString( @"g_default_cover", nil)]];
        }else{
            [self.iconImg setImageWithURL:[NSURL URLWithString:str] placeholder:[UIImage imageNamed:NSLocalizedString( @"g_default_cover", nil)]];
        }
    }else if(model.pic){
        NSString * str = [NSString stringWithFormat:@"%@",model.pic];
        if (![model.img isKindOfClass:[NSNull class]]) {
            [self.iconImg setImageWithURL:[NSURL URLWithString:str] placeholder:[UIImage imageNamed:NSLocalizedString( @"g_default_cover", nil)]];
        }else{
            [self.iconImg setImageWithURL:[NSURL URLWithString:str] placeholder:[UIImage imageNamed:NSLocalizedString( @"g_default_cover", nil)]];
        }
    } else {
        [self.iconImg setImageWithURL:[NSURL URLWithString:@""] placeholder:[UIImage imageNamed:NSLocalizedString( @"g_default_cover", nil)]];
    }
    
    //设置文本
    if (![model.title isKindOfClass:[NSNull class]]) {
        self.titleLab.text = [NSString stringWithFormat:@"%@",model.title];
    }else{
        self.titleLab.text = [NSString stringWithFormat:@"%@",model.name];
    }
    NSString *imgStr = [model.fid integerValue] == 0 ? @"list_uncollect" : @"list_collect";
    [self.collectBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    if (model.favAble != nil && [model.favAble integerValue] == 0) {
        self.collectBtn.hidden = YES;
    } else {
        self.collectBtn.hidden = NO;
    }
    
}

- (void)collectBtnClicked {
   
    // fix 右划编辑模式 触发收藏按钮时间 baxiang
    UIView *superView = self.superview;
    while (superView&&[superView isKindOfClass:[UITableView class]]== NO) {
          superView = superView.superview;
    }
    if ([superView isKindOfClass:[UITableView class]]&&[(UITableView*)superView isEditing]) {
         return;
    }
    if ([_model.fid integerValue] != 0) {
        [self deleteModel:_model];
    }else{
        _model.user_id = RBDataHandle.loginData.userid;
        _model.current_mcid = RBDataHandle.loginData.currentMcid;
        [self saveModel:_model];
    }
}

- (void)deleteModel:(PDFeatureModle *)model {
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    if (model.fid != nil && [model.fid integerValue] != 0) {
        NSString *mainId = RBDataHandle.currentDevice.mcid;
        [RBNetworkHandle deleteCollectionDataIds:@[model.fid] andMainID:mainId andBlock:^(id res) {
            if (res) {
                if ([[res objectForKey:@"result"] integerValue] == 0) {
                    if (_clickBack) {
                        model.fid = nil;
                        _clickBack();
                    }
                   
                    
                    [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"has_cancle_collection", nil) maskType:MitLoadingViewMaskTypeBlack];
                } else {
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
            }
        }];
    }
}



- (void)saveModel:(PDFeatureModle *)model {
    NSString *act = model.act;
    NSDictionary *dataDict = [NSDictionary dictionary];
    if ([act isEqualToString:@"singleSon"]) {
        if (model.src != nil) {
            dataDict = @{@"cid":[NSNumber numberWithInteger:[model.pid integerValue]],@"rid":model.mid,@"rdb":model.src};// 单曲
        } else {
            dataDict = @{@"cid":[NSNumber numberWithInteger:[model.pid integerValue]],@"rid":model.mid};// 单曲
        }
        
    } else {
        dataDict = @{@"cid":model.mid,@"rid":@0}; // 专辑
    }
    NSArray *arr = @[dataDict];
    NSString *mainId = RBDataHandle.currentDevice.mcid;
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    [RBNetworkHandle addCollectionData:arr andMainID:mainId andBlock:^(id res) {
        if (res) {
            if ([[res objectForKey:@"result"] integerValue] == 0) {
                NSArray *arr = [[res objectForKey:@"data"] objectForKey:@"list"];
                if (arr.count > 0) {
                    NSDictionary *dict = arr.lastObject;
                    NSNumber *fid = [dict objectForKey:[NSString stringWithFormat:@"%@",model.mid]];
                    model.fid = fid;
                }
                if (_clickBack) {
                    _clickBack();
                }
                NSString * userid = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.userid];
                model.user_id = userid;
                model.act = @"singleSon";
                [RBResourceManager saveFeatureModle:model];
                [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"collect_success", nil) maskType:MitLoadingViewMaskTypeBlack];
                
            } else {
                [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            }
        }
    }];
    
    
}

#pragma mark - 创建各个视图

- (UIButton *)collectBtn {
    if (_collectBtn == nil) {
        UIButton *collecBtn = [[UIButton alloc] initWithFrame:CGRectMake(SC_WIDTH - SX(52), 0, SX(50) , self.height)];
        [collecBtn setImage:[UIImage imageNamed:@"list_collect"] forState:UIControlStateNormal];
        [collecBtn addTarget:self action:@selector(collectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:collecBtn];
        _collectBtn = collecBtn;
    }
    return _collectBtn;
}
-(UIImageView *)iconImg{
    if (!_iconImg) {
        UIImageView * vi = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SX(40), SX(40))];
        vi.center = CGPointMake(SX(40), self.height * .5);
        vi.layer.cornerRadius = SX(20);
        vi.layer.masksToBounds = YES;
        [self addSubview:vi];
        _iconImg  = vi;
        
    }
    return _iconImg;
}
-(UIImageView *)animateImg{
    if (!_animateImg) {
        UIImageView * vi = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_playing_01"]];
        [self addSubview:vi];
        _animateImg = vi;
        NSMutableArray * playLoading = [NSMutableArray new];
        for(int i = 1 ; i <  19 ; i++){
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"list_playing_%02d",i]];
            if(image){
                [playLoading addObject:image];
            }
        }
        
        [vi setAnimationImages:playLoading];
        [vi setAnimationDuration:playLoading.count * (1/14)];
        [vi setAnimationRepeatCount:MAXFLOAT];
    }
    return _animateImg;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImg.right+ 15, 0, SC_WIDTH - SX(60) * 2, self.height)];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont systemFontOfSize:SX(17)];
        lab.textColor = mRGBToColor(0x5d6266);
        lab.numberOfLines = 0;
        [self addSubview:lab];
        _titleLab = lab;
    }
    return _titleLab;
}

-(UIView *)bottomLine{
    if (!_bottomLine) {
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 0.5, SC_WIDTH, 0.5)];
        vi.backgroundColor = mRGBToColor(0xeceded);
        [self addSubview:vi];
        _bottomLine = vi;
    }
    return _bottomLine;
}


#pragma mark - action: 设置 play 状态
-(void)setPlay:(BOOL)play{
    _play = play;
    if (_play) {
        self.iconImg.hidden = YES;
        self.animateImg.hidden = NO;
        [self.animateImg startAnimating];
    }else{
        self.iconImg.hidden = NO;
        self.animateImg.hidden = YES;
        [self.animateImg stopAnimating];
    }
    
}

#pragma mark - action: layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconImg.center = CGPointMake(SX(40), self.height * .5);
    self.titleLab.frame = CGRectMake(self.iconImg.right + 15, 0, SC_WIDTH - SX(60) * 2, self.height);
    self.bottomLine.frame = CGRectMake(0, self.height - 1, SC_WIDTH, 1);
    self.animateImg.center = self.iconImg.center;
    self.collectBtn.center = CGPointMake(SC_WIDTH - SX(52) + SX(25), self.height * .5);
    
}


@end
