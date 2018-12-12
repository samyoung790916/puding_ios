//
//  PDFeatureListCell.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFeatureListCell.h"
#import "MitLoadingView.h"
#import "PDFeatureModle.h"
#import "RBResourceManager.h"
@implementation PDFeatureListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
   
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        indexLable = [[UILabel alloc] initWithFrame:CGRectZero];
        indexLable.textAlignment = NSTextAlignmentCenter;
        indexLable.textColor = mRGBToColor(0xa2abb2);
        indexLable.font = [UIFont systemFontOfSize:SX(17)];
        [self.contentView addSubview:indexLable];
        [indexLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(50);
        }];
    
        titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLable.font = [UIFont systemFontOfSize:SX(17)];
        titleLable.textColor = mRGBToColor(0x5d6266);
        titleLable.numberOfLines = 0;
        [self.contentView addSubview:titleLable];
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(indexLable.mas_right);
            make.top.bottom.mas_equalTo(0);
            make.width.lessThanOrEqualTo(@(SC_WIDTH - SX(60) * 2));
        }];
        
        collectionBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [collectionBtn setImage:[UIImage imageNamed:@"ic_more"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:collectionBtn];
        [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(35);
        }];
        [collectionBtn addTarget:self action:@selector(showActionSheet) forControlEvents:(UIControlEventTouchUpInside)];
        collectionBtn.hidden = !RBDataHandle.currentDevice.isStorybox;
        
        stopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SX(53 - 10.5)/2, SX(50 - 10)/2, SX(10.5), SX(10))];
        [self.contentView addSubview:stopImageView];
        
        NSMutableArray * playLoading = [NSMutableArray new];
        for(int i = 1 ; i <  19 ; i++){
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"list_playing_%02d",i]];
            if(image){
                [playLoading addObject:image];
            }
        }
        
        [stopImageView setAnimationImages:playLoading];
        [stopImageView setAnimationDuration:playLoading.count * (1/14)];
        [stopImageView setAnimationRepeatCount:-1];
        
        
    }
    
    return self;
}

- (void)showActionSheet{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *images = [NSMutableArray array];
    if ((_model.fid != nil && [_model.fid integerValue] > 0)) {
        [array addObject:@"저장됨"];
        [images addObject:@"icon_shoucang_sel"];
    }
    else{
        [array addObject:@"저장"];
        [images addObject:@"icon_shoucang"];
    }
    if (_isDIYAlbum) {
        [array addObject:@"사용자 지정 노래 목록에서 제거"];
    }
    else{
        [array addObject:@"사용자 지정 노래 목록에 추가"];
    }
    [images addObject:@"icon_tianjia_pre"];
    @weakify(self)
    [[self viewController] showSheetWithItems:array Images:images Title:[NSString stringWithFormat:@"싱글곡:%@",_model.name] CancelTitle:@"취소" WithBlock:^(int selectIndex) {
        @strongify(self)
        switch (selectIndex) {
            case 0:
                [self collecButtonClicked];
                break;
            case 1:
                [self addToDIYCollection];
                break;
            default:
                break;
        }
    }];
}

- (void)requestAlbum{
    [RBNetworkHandle getAlbumresourceAndBlock:^(id res) {
        if (res&&[[res objectForKey:@"result"] intValue]==0) {
            // 数据解析
            NSArray * arr = [[res objectForKey:@"data"] objectForKey:@"categories"];
            if (arr.count>0) {
                NSNumber *albID = [arr[0] objectForKey:@"id"];
                RBDeviceModel *device = RBDataHandle.currentDevice;
                device.albumId = albID;
                [RBDataHandle updateCurrentDevice:device];
                [self addToDIYCollection];
            }
        }
    }];
}

- (void)addToDIYCollection{
    NSNumber *albumId = RBDataHandle.currentDevice.albumId;
    if (albumId == nil) {
        [self requestAlbum];
        return;
    }
    [MitLoadingView showWithStatus:@"show"];
    
    [RBNetworkHandle addOrDelAlbumresource:!_isDIYAlbum SourceID:_model.mid AlbumId:RBDataHandle.currentDevice.albumId andBlock:^(id res) {
        if ([[res objectForKey:@"result"] integerValue] == 0) {
            if (_isDIYAlbum) {
                [MitLoadingView showSuceedWithStatus:@"삭제성공"];
                if (_delCallBack) {
                    _delCallBack();
                }
            }
            else{
                [MitLoadingView showSuceedWithStatus:@"가입성공"];
            }
        }
        else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}
- (void)collecButtonClicked {
    NSLog(@"点击收藏%@",_model.mid);
    
    if ([_model.fid integerValue] != 0) {
        NSLog(@"已经有了%@:",_model);
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
                        _clickBack(model);
                    }
                    [self deleteLocalData:model.mid];
                    
                    [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"has_cancle_collection", nil) maskType:MitLoadingViewMaskTypeBlack];
                } else {
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
            }
        }];
    }
}


- (void)deleteLocalData:(NSString *)mid {
    
    NSString * userid = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.userid];
//    NSString * currentMcid = [NSString stringWithFormat:@"%@",RBDataHandle..loginData.currentmcid];
//    NSArray *localArr = [[PDFeatureModle search:@{@"mid":mid,@"user_id":userid} Orderby:@[@"tid DESC"]] mutableCopy];
//    if (localArr.count > 0) {
//        PDFeatureModle *localModel = localArr.lastObject;
//        [localModel destroy];
//    }
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
                    _clickBack(model);
                }
                NSString * userid = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.userid];
                model.user_id = userid;
                [RBResourceManager saveFeatureModle:model];

                [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"collect_success", nil) maskType:MitLoadingViewMaskTypeBlack];
                
            } else {
                [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            }
        }
    }];
    
    
}

- (void)setIsPlaying:(BOOL)isPlaying{
    if(isPlaying){
        if(![stopImageView isAnimating]){
            [stopImageView startAnimating];
        }
        stopImageView.hidden = NO;
        indexLable.hidden = YES;
    }else{
        [stopImageView stopAnimating];
        stopImageView.hidden = YES;
        indexLable.hidden = NO;
    }
}

- (void)setTitle:(NSString *)title{
    titleLable.text = title;
}

- (void)setRowIndex:(NSInteger)rowIndex{
    indexLable.text = [NSString stringWithFormat:@"%d",rowIndex + 1];
}
-(void)setModel:(PDFeatureModle *)model{
    _model = model;
    
    if(!model)
        return;
    
    BOOL isColl = NO;
    if ([model.fid integerValue] != 0) {
        isColl = YES;
    }
    // 需要换行显示
//    titleLable.frame = CGRectMake(SX(53), SX(50 - 20)/2, self.width - SX(53),MAX(SX(20),model->contentHeight) );
//    titleLable.textAlignment = NSTextAlignmentLeft;
    //indexLable.center = CGPointMake(indexLable.center.x, self.contentView.center.y);
    
  
   // [self layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
//    if(_isTag){
//        stopImageView.hidden = !selected;
//        indexLable.hidden = selected;
//    }
  
}
@end
