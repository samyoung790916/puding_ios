//
//  PDMainBabyDynamicCollectView.m
//  PuddingPlus
//
//  Created by kieran on 2017/5/3.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDMainBabyDynamicCollectView.h"
#import "PDMainBabyCell.h"

@interface  PDMainBabyDynamicCollectView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak) UILabel           *titleLable;
@property(nonatomic,weak) UIImageView       *titleIcon;
@property(nonatomic,weak) UIButton          *moreBtn;
@property(nonatomic,weak) UICollectionView  *collectionView;



@property(nonatomic,weak) UIImageView       *tipImageView;
@property(nonatomic,weak) UILabel           *tipLable;

@end


@implementation PDMainBabyDynamicCollectView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleLable.hidden = NO;
        self.titleIcon.hidden = NO;
        self.moreBtn.hidden = NO;
        self.collectionView.hidden = YES;
    }
    return self;
}

- (UILabel *)tipLable{
    if(_tipLable == nil){
        UILabel * lable = [[UILabel alloc ] init];
        lable.font = [UIFont systemFontOfSize:16];
        lable.textColor = mRGBToColor(0x3d4857);
        lable.numberOfLines = 0;
        [self addSubview:lable];
        lable.text = NSLocalizedString( @"open_baby_dynamic_and_grab_wonderful_moment", nil);
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tipImageView.mas_right).offset((20));
            make.right.equalTo(self.mas_right).offset(-((50)));
            make.centerY.equalTo(self.tipImageView.mas_centerY);
            make.height.equalTo(@((70)));
        }];
        
        _tipLable = lable;
    }
    return _tipLable;
}

- (UIImageView *)tipImageView{
    if(_tipImageView == nil){
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = NO;
        [self addSubview:imageView];
        
        imageView.image = [UIImage imageNamed:@"img_home_baby_default_unlock"];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@((115)));
            make.height.equalTo(@((80)));
            make.top.mas_equalTo((54));
            make.left.equalTo(@((17)));
        }];
        
        _tipImageView = imageView;
    }
    return _tipImageView;
}
#pragma mark  titleLable 创建



- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.userInteractionEnabled = NO;

        titleLabel.textColor = mRGBToColor(0x4a4a4a);
        titleLabel.font = [UIFont systemFontOfSize:17];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleIcon.mas_right).offset((5));
            make.top.mas_equalTo(0);
            make.height.mas_equalTo((47));
        }];
        _titleLable = titleLabel;
    }
    return _titleLable;
}

#pragma mark  more 创建

- (UIButton *)moreBtn{
    if(!_moreBtn){
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:moreBtn];
        [moreBtn setImage:[UIImage imageNamed:RBDataHandle.currentDevice.isPuddingPlus ? @"ic_more":@"hp_icon_more"] forState:UIControlStateNormal];
        [moreBtn setTitleColor:mRGBToColor(0x9b9b9b) forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(47);
            make.right.mas_equalTo(-5);
            make.width.mas_equalTo(@(46));
        }];
        [moreBtn addTarget:self action:@selector(moreContentHandle) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton * hidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self insertSubview:hidBtn belowSubview:moreBtn];
        
        [hidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.right.equalTo(moreBtn.mas_left);
            make.top.equalTo(moreBtn.mas_top);
            make.bottom.equalTo(moreBtn.mas_bottom);
        }];
        
        [hidBtn addTarget:self action:@selector(moreContentHandle) forControlEvents:UIControlEventTouchUpInside];
        
        _moreBtn = moreBtn;
    }
    return _moreBtn;
}

#pragma mark collectionView create

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = (17);
        //        flowLayout.sectionInset = UIEdgeInsetsMake(0, 17, 0, 17);
        flowLayout.minimumInteritemSpacing = (17);
        flowLayout.itemSize = CGSizeMake((116), 95);

        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.alwaysBounceHorizontal = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self  addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo((47));
            make.left.equalTo(self.mas_left).offset((15));
            make.right.equalTo(self.mas_right).offset((-15));
            make.height.equalTo(@(95));
        }];
        [collectionView registerClass:[PDMainBabyCell class] forCellWithReuseIdentifier:NSStringFromClass([PDMainBabyCell class])];
        
//        collectionView.contentInset = UIEdgeInsetsMake(0, (17), 0, (17));
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PDCategory *category = [self.module.categories objectAtIndexOrNil:indexPath.row];
    PDMainBabyCell * cell = (PDMainBabyCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if([cell isKindOfClass:[PDMainBabyCell class]]){
        if([category.type intValue] == 0 || [category.type intValue] == 10){
            NSLog(@"宝宝动态选择 图片");
            [self getAllPhoto:indexPath.row Block:^(NSArray *photo, NSInteger index) {
                if(_selectPhotoCategory){
                    _selectPhotoCategory(photo,index,cell.menuImageView);
                }
            }];
        }else if([category.type intValue] == 1 || [category.type intValue] == 11){
            NSLog(@"宝宝动态选择 视频");
            if(_selecrtVideoCategory){
                _selecrtVideoCategory([self getVideoModle:indexPath.row],cell.menuImageView);
            }
        }
    }
    
   
    
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return MIN(8, [self.module.categories count]);
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PDMainBabyCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDMainBabyCell class]) forIndexPath:indexPath];
    PDCategory *category = [self.module.categories objectAtIndexOrNil:indexPath.row];
    [cell setCategoty:category];
    return cell;
}

#pragma mark  titleicon 创建

- (UIImageView *)titleIcon{
    if(!_titleIcon){
        UIImageView  *titleIcon = [UIImageView new];
        [self addSubview:titleIcon];
        titleIcon.contentMode = UIViewContentModeScaleAspectFit;
        titleIcon.image = [UIImage imageNamed:@"hp_icon_default_small"];
        [titleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((15));
            make.centerY.equalTo(self.moreBtn.mas_centerY);
            make.width.mas_equalTo((21));
            make.height.mas_equalTo((21));
        }];
        _titleIcon = titleIcon;
    }
    return _titleIcon;
}


#pragma mark button action

- (void)moreContentHandle{
    if(_MoreContentBlock){
        _MoreContentBlock();
    }
}


#pragma mark  set Datasource

- (PDFamilyMoment *)getVideoModle:(NSInteger)index{
    NSArray * res = _module.categories;
    PDCategory * cate = [res mObjectAtIndex:index];
    PDFamilyMoment * moment = [[PDFamilyMoment alloc]  init];
    moment.ID = [cate.category_id intValue];
    moment.content = cate.src;
    moment.thumb = cate.preview;
    moment.type = [cate.type intValue];
    return moment;
}

- (void)getAllPhoto:(NSInteger)selectindex Block:(void (^)(NSArray * photo,NSInteger index)) block{
    if(block == nil)
        return;
    NSArray * res = _module.categories;
    
    int phptoindex = 0;
    int currentIndex = 0;
    NSMutableArray * array = [NSMutableArray new];
    
    for(int i = 0 ; i < res.count ; i ++){
        PDCategory * cate = [res objectAtIndex:i];
        if([cate.type intValue] == 0 || [cate.type intValue] == 10){
            if(i == selectindex){
                currentIndex = phptoindex;
            }
            PDFamilyMoment * moment = [[PDFamilyMoment alloc]  init];
            moment.ID = [cate.category_id intValue];
            moment.content = cate.src;
            moment.thumb = cate.preview;
            moment.type = [cate.type intValue];
            [array addObject:moment];
            phptoindex ++;
        }
    }
    block(array,currentIndex);
}


-(void)setModule:(PDModule *)module{
    if(_module == module){
        return;
    }
    _module = module;
    int type = [module.isopen intValue];
    if(type == 0){
        self.tipImageView.image = [UIImage imageNamed:@"img_home_baby_default_unlock"];
        self.tipImageView.hidden = NO;
        self.tipLable.hidden = NO;
        self.tipLable.text = NSLocalizedString( @"click_to_open_baby_dynamic_then_pudding_capture", nil);

        self.collectionView.hidden = YES;
    }else if(type == 1 && module.categories.count > 0){ //如果宝宝动态打开，并且有宝宝动态数据
        self.tipImageView.hidden = YES;
        self.tipLable.hidden = YES;
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }else if(type == 2 || module.categories.count == 0){ //如果宝宝动态识别不准备，获取宝宝动态数据为空
        self.tipImageView.image = [UIImage imageNamed:@"img_home_baby_default"];
        self.tipLable.text = NSLocalizedString( @"parent_can_see_wonderful_moment_here", nil);
        self.collectionView.hidden = YES;

        
        self.tipImageView.hidden = NO;
        self.tipLable.hidden = NO;
    }
    self.titleLable.text = module.title;
    [self.moreBtn setImage:[UIImage imageNamed:RBDataHandle.currentDevice.isPuddingPlus ? @"ic_more":@"hp_icon_more"] forState:UIControlStateNormal];

    [self.titleIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",module.icon]] placeholder:[UIImage imageNamed:@"hp_icon_default_small"]];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    int type = [_module.isopen intValue];
    if(type == 0){
        if(_BabySettingBlock){
            _BabySettingBlock();
        }
    }else if(type == 1 || type == 2){
        if(_MoreContentBlock){
            _MoreContentBlock();
        }
    }

}
@end
