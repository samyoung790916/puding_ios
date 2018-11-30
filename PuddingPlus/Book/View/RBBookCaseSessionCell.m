//
// Created by kieran on 2018/2/27.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import "RBBookCaseSessionCell.h"
#import "RBBookCaseClassCell.h"
#import "RBBookClassModle.h"
#import "RBBookSourceModle.h"

@implementation RBBookCaseSessionCell

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleLable.hidden = NO;
        self.moreBtn.hidden = NO;
        self.collectionView.hidden = NO;
        self.titleIcon.hidden = NO;
    }
    return self;
}

#pragma mark 懒加载 titleView
- (UIView *)titleView{
    if (!_titleView){
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@(47));
            make.top.equalTo(@(0));
        }];
        
        _titleView = view;
    }
    return _titleView;
}


#pragma mark  titleLable 创建
- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel *titleLabel = [UILabel new];
        [self.titleView addSubview:titleLabel];
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

#pragma mark button action

- (void)moreContentHandle{
    if(_moreContentBlock){
        _moreContentBlock(self.module);
    }
}

- (void)setModule:(RBBookClassModle *)module {
    _module = module;
    self.titleLable.text = module.title;
    
    [self.collectionView reloadData];
}

#pragma mark titleIcon 创建

- (UIImageView * )titleIcon{
    if (!_titleIcon){
        UIImageView * imageV = [UIImageView new];
        if(RBDataHandle.currentDevice.isPuddingPlus){
            imageV.backgroundColor = mRGBToColor(0x8ec31f);
        }else{
            imageV.backgroundColor = mRGBToColor(0x28c2fa);
        }
        imageV.layer.cornerRadius = 2.5;
        imageV.clipsToBounds = YES;
        [self.titleView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(self.moreBtn.mas_centerY);
            make.width.mas_equalTo(5);
            make.height.mas_equalTo(15);
        }];

        _titleIcon = imageV;
    }
    return _titleIcon;
}

#pragma mark  more 创建

- (UIButton *)moreBtn{
    if(!_moreBtn){
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleView addSubview:moreBtn];
        [moreBtn setImage:[UIImage imageNamed:RBDataHandle.currentDevice.isPuddingPlus ? @"ic_more" :  @"hp_icon_more"] forState:UIControlStateNormal];
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

        UIImageView * bgimage = [UIImageView new];
        [bgimage setImage:[[UIImage imageNamed:@"bg_picturebooks_bookshelf"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, SX(20), 5, SX(20))]];
        [self addSubview:bgimage];

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = (self.width - 30 - SX(108)  * 3)/3;
        flowLayout.itemSize = CGSizeMake(SX(108), SX(133));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;

        collectionView.alwaysBounceHorizontal = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self  addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom);
            make.left.equalTo(@((15)));
            make.right.equalTo(self.mas_right).offset(-(15));
            make.height.equalTo(@((SX(133))));
        }];
        [collectionView registerClass:[RBBookCaseClassCell class] forCellWithReuseIdentifier:NSStringFromClass([RBBookCaseClassCell class])];
        _collectionView = collectionView;

        [bgimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.collectionView.mas_bottom).offset(-SX(25));
            make.left.equalTo(@((5)));
            make.right.equalTo(self.mas_right).offset(-5);
            make.height.equalTo(@(30));
        }];


    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RBBookSourceModle *category = [self.module.modules objectAtIndexOrNil:indexPath.row];
    if(_selectBookCategory){
        _selectBookCategory(category);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.module.modules count];
}



- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBBookCaseClassCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBBookCaseClassCell class]) forIndexPath:indexPath];
    RBBookSourceModle * modle = [self.module.modules objectOrNilAtIndex:indexPath.row];
    [cell setBookModle:modle];
    return cell;
}






@end
