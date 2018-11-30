//
//  PDMainMenuHeadCollectView.m
//  Pudding
//
//  Created by baxiang on 16/9/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMainMenuHeadCollectView.h"
#import "PDChildDevepTagCell.h"
#import "RBEnglishClassCell.h"
#pragma mark - PDMainMenuHeadCollectView
#import "UIImage+TintColor.h"
#import "NSDate+RBAdd.h"
#import "RBPuddingSelectTypeCell.h"
#import "PDBabyScoreView.h"
#import "RBMainBannerCell.h"
#import "NSArray+RBExtension.h"
#import "NSObject+RBSelectorAvoid.h"
#import "RBBookCaseClassCell.h"
@interface RBMainHeaderClsLayout : UICollectionViewFlowLayout
//  一行中 cell 的个数
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (assign,nonatomic) CGFloat contentWidth;
@end

@implementation RBMainHeaderClsLayout

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];
    
    
    float xValue = 0;
    float yValue = 0;
    
    float sWidth = self.collectionView.width;
    float sHeight = self.collectionView.height;
    self.itemAttributes = [NSMutableArray array];

    NSInteger sessionCount = [[self collectionView] numberOfSections];
    
    for (int i =  0; i < sessionCount; i ++) {
        NSInteger itemCount = [[self collectionView] numberOfItemsInSection:i];
        
        xValue = i * sWidth;
        yValue = 0;
        
        NSInteger lineMaxItem = floor((sWidth - self.sectionInset.left - self.sectionInset.right +  self.minimumInteritemSpacing)/(self.itemSize.width + self.minimumInteritemSpacing)) ;
        float interitemSpacing = 0;
        if(lineMaxItem > 1){
            interitemSpacing = (sWidth - self.sectionInset.left - self.sectionInset.right - self.itemSize.width)/(lineMaxItem -1)  - self.itemSize.width;
        }
        
        
        
        NSInteger maxLines = floor(sHeight - self.sectionInset.top - self.sectionInset.bottom + self.minimumLineSpacing)/(self.itemSize.height + self.minimumLineSpacing);
        float lineSpace = 0;
        if(maxLines > 1)
           lineSpace = (sHeight - self.sectionInset.top - self.sectionInset.bottom - self.itemSize.height * maxLines)/(maxLines - 1);
        
        for(int j = 0 ; j < itemCount ; j ++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *layoutAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
  
            xValue = self.sectionInset.left + (self.itemSize.width + interitemSpacing) * (j % lineMaxItem) + i * sWidth;
            yValue = self.sectionInset.top + (self.itemSize.height + lineSpace) * floor(j / lineMaxItem);
            
            
            layoutAttributes.frame = CGRectMake(xValue, yValue, self.itemSize.width, self.itemSize.height);
            [_itemAttributes addObject:layoutAttributes];
        }
    }
    
    
    self.contentWidth = sessionCount * sWidth;
  
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (CGSize)collectionViewContentSize {
    //重新计算布局
    [self prepareLayout];
    CGSize contentSize  = CGSizeMake(self.contentWidth, self.collectionView.frame.size.height);
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}

@end


@interface PDMainMenuHeadCollectView()<UIGestureRecognizerDelegate>
@property(nonatomic,weak) UILabel *titleLabel;
@property(nonatomic,weak) UIImageView *titleIcon;
@property(nonatomic,weak) UIButton *moreBtn;
@property(nonatomic,weak) UIImageView *arrow;
@end
@implementation PDMainMenuHeadCollectView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView  *titleIcon = [UIImageView new];
        [self addSubview:titleIcon];
        titleIcon.contentMode = UIViewContentModeScaleAspectFit;
        titleIcon.image = [UIImage imageNamed:@"hp_icon_default_small"];
        
        self.titleIcon = titleIcon;
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.textColor = mRGBToColor(0x4a4a4a);
        titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleIcon.mas_right).offset(5);
            make.top.bottom.mas_equalTo(0);
            //make.height.mas_equalTo(20);
        }];
        
        [titleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((15));
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.width.mas_equalTo((21));
            make.height.mas_equalTo((21));
        }];
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_arrow"]];
        arrow.contentMode = UIViewContentModeCenter;
        [self addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(@(10));
            make.right.mas_equalTo(-10);
        }];
        self.arrow = arrow;
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:moreBtn];
//        [moreBtn setImage:[UIImage imageNamed:RBDataHandle.currentDevice.isPuddingPlus ? @"ic_more" :  @"hp_icon_more"] forState:UIControlStateNormal];
        [moreBtn setTitle:@"更多" forState:(UIControlStateNormal)];
        [moreBtn setTitleColor:mRGBToColor(0x9b9b9b) forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(arrow.mas_centerY);
            make.right.mas_equalTo(arrow.mas_left).offset(5);
            make.width.mas_equalTo(@(46));
        }];
        self.moreBtn = moreBtn;

        [moreBtn addTarget:self action:@selector(moreContentHandle) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}



-(void)moreContentHandle{
    if (_moreContentBlock) {
        _moreContentBlock();
    }
}
-(void)setModule:(PDModule *)module{
    _module = module;
    if ([module.attr isEqualToString:@"habit"]) {
        self.moreBtn.hidden = YES;
        self.arrow.hidden = YES;
    }else{
        self.moreBtn.hidden = NO;
        self.arrow.hidden = NO;
        UITapGestureRecognizer *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreContentHandle)];
        [self addGestureRecognizer:moreTap];
    }
//    [self.moreBtn setImage:[UIImage imageNamed:RBDataHandle.currentDevice.isPuddingPlus ? @"ic_more":@"hp_icon_more"] forState:UIControlStateNormal];

    self.titleLabel.text = module.title;
    [self.titleIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",module.icon]] placeholder:[UIImage imageNamed:@"hp_icon_default_small"]];
}
@end

#pragma mark - PDBabyDevelopHeadCollectView

/**
 *  宝宝成长计划
 */
@interface PDBabyDevelopHeadCollectView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,weak) UICollectionView  *collectionView;
@end
@implementation PDBabyDevelopHeadCollectView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
      
        self.headIconImage.hidden = NO;
        self.titleLabel.hidden = NO;
        self.moreButton.hidden = NO;
        self.collectionView.hidden = NO;
    
    }
    return self;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
       
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 7;
        flowLayout.minimumInteritemSpacing = 3;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.scrollEnabled = NO;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.alwaysBounceHorizontal = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self  addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headIconImage.mas_bottom).offset(9);
            make.left.mas_equalTo(18);
            make.right.mas_equalTo(-18);
            make.height.mas_equalTo(20);
        }];
        [collectionView registerClass:[PDChildDevepTagCell class] forCellWithReuseIdentifier:NSStringFromClass([PDChildDevepTagCell class])];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIButton *)moreButton{
    if(!_moreButton){
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:moreBtn];
//        [moreBtn setImage:[UIImage imageNamed:RBDataHandle.currentDevice.isPuddingPlus ? @"ic_more":@"hp_icon_more"] forState:UIControlStateNormal];
        [moreBtn setTitle:@"更多" forState:(UIControlStateNormal)];
        [moreBtn setTitleColor:mRGBToColor(0x9b9b9b) forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.right.mas_equalTo(-5);
            make.width.mas_equalTo(@(46));
        }];
        [moreBtn addTarget:self action:@selector(developDetailHandle) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(developDetailHandle)];
        [self addGestureRecognizer:moreTap];
        
        _moreButton = moreBtn;
    }
    return _moreButton;
}

- (UIImageView *)headIconImage{
    if(!_headIconImage){
        
        UIImageView  *headIcon = [UIImageView new];
        headIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:headIcon];
        headIcon.image = [UIImage imageNamed:@"hp_icon_growup"];
        [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(12));
            make.left.mas_equalTo(20);
            make.width.height.mas_equalTo(21);
        }];
        
        _headIconImage = headIcon;
    }
    return _headIconImage;
}



- (UILabel *)titleLabel{
    if(!_titleLabel){
        UILabel * lable = [[UILabel alloc] init];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.textColor = mRGBToColor(0x4a4a4a);
        lable.font = [UIFont systemFontOfSize:17];
        [self addSubview:lable];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headIconImage.mas_right).offset(5);
            make.centerY.equalTo(self.headIconImage.mas_centerY);
        }];
        _titleLabel = lable;
    }
    return _titleLabel;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return MIN(5, self.tags.count);
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = [[self.tags objectAtIndexOrNil:indexPath.row] mObjectAtIndex:0];
    CGRect rect = [string boundingRectWithSize:(CGSize){CGFLOAT_MAX, 20} options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:12] } context:nil];
    return CGSizeMake(rect.size.width+15, 20);
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PDChildDevepTagCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDChildDevepTagCell class]) forIndexPath:indexPath];
    NSString * string = [[self.tags objectAtIndexOrNil:indexPath.row] mObjectAtIndex:0];

    cell.tagName = string;
    return cell;
}
-(void)developDetailHandle{
    if (_developDetailBlock) {
        _developDetailBlock();
    }
}

- (void)setTags:(NSArray *)tags{
    _tags = tags;
    [self.collectionView reloadData];

}

@end




#pragma mark - RBEnglishClassCollectView
@interface RBEnglishClassCollectView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak) UILabel * titleLable;
@property(nonatomic,weak) UILabel * descLable;
@property(nonatomic,weak) UIImageView   *titleIcon;
@property(nonatomic,weak) UICollectionView *collectionView;
@property(nonatomic,weak) PDBabyScoreView * userStudyScoreView;

@end

#import "PDBabyScoreView.h"
@implementation RBEnglishClassCollectView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleLable.hidden = NO;
        self.titleIcon.hidden = NO;
        self.moreBtn.hidden = NO;
        self.collectionView.hidden = NO;
        self.userStudyScoreView.hidden = NO;
        
    }
    return self;
}

#pragma mark  more 创建

- (UIButton *)moreBtn{
    if(!_moreBtn){
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:moreBtn];
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

-  (PDBabyScoreView *)userStudyScoreView{
    if(!_userStudyScoreView){
        PDBabyScoreView  * neb = [[PDBabyScoreView alloc] initWithFrame:CGRectZero];
        [self addSubview:neb];
        [neb addTarget:self action:@selector(babyScoreActin:) forControlEvents:UIControlEventTouchUpInside];
        [neb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@((15)));
            make.right.equalTo(@(-(15)));
            make.top.equalTo(@((53)));
            make.height.equalTo(@((95)));
        }];
        
        _userStudyScoreView = neb;
    }
    return _userStudyScoreView;
}

#pragma mark collectionView create

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = (17);
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 17, 0, 17);
        flowLayout.minimumInteritemSpacing = (17);
        flowLayout.itemSize = CGSizeMake((116), (144));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.alwaysBounceHorizontal = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self  addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-(0));
            make.left.equalTo(@((15)));
            make.right.equalTo(self.mas_right).offset(-(15));
            make.height.equalTo(@((144)));
        }];
        [collectionView registerClass:[RBEnglishClassCell class] forCellWithReuseIdentifier:NSStringFromClass([RBEnglishClassCell class])];
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PDCategory *category = [self.module.categories objectAtIndexOrNil:indexPath.row];
    if(_selectClassCategory){
        _selectClassCategory(category);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.module.categories count];
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBEnglishClassCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBEnglishClassCell class]) forIndexPath:indexPath];
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
            make.centerY.mas_equalTo(self.moreBtn.mas_centerY);
            make.width.mas_equalTo((21));
            make.height.mas_equalTo((21));
        }];
        _titleIcon = titleIcon;
    }
    return _titleIcon;
}

#pragma mark  titleLable 创建
- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.textColor = mRGBToColor(0x4a4a4a);
        titleLabel.font = [UIFont systemFontOfSize:17];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleIcon.mas_right).offset((5));
            make.top.mas_equalTo(0);
            make.height.mas_equalTo((47));
        }];
        _titleLable = titleLabel;
        
        UILabel *descLab = [UILabel new];
        [self addSubview:descLab];
        descLab.textColor = mRGBToColor(0x919bAA);
        descLab.font = [UIFont systemFontOfSize:13];
        [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLable.mas_right).offset((6));
            make.top.mas_equalTo(0);
            make.height.mas_equalTo((47));
        }];
        _descLable = descLab;
        
    }
    return _titleLable;
}

#pragma mark button action

- (void)moreContentHandle{
    if(_moreContentBlock){
        _moreContentBlock();
    }
}


- (void)babyScoreActin:(id)sender{
    if(_babyEnglisStudy){
        _babyEnglisStudy();
    }
}

#pragma mark  set Datasource

-(void)setModule:(PDModule *)module{
    if(_module == module){
        return;
    }
    _module = module;
    
    int scorllIndex = 0;
    
    for(int i =0 ; i < module.categories.count ; i++){
        PDCategory * cate = [module.categories objectAtIndex:i];
        if(!cate.locked){
            scorllIndex = i;
        }else{
            break;
        }
    }
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:scorllIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    });
    self.titleLable.text = module.title;
    NSString *topicName =  [NSString stringWithFormat:@"%@",module.topicname];
    if ([topicName length]>20) {
        NSString *name= [topicName substringToIndex:20];
        self.descLable.text = [NSString stringWithFormat:@"[%@...]",name];
    }else{
        self.descLable.text = [NSString stringWithFormat:@"[%@]",topicName];
    }
    [self.titleIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",module.icon]] placeholder:[UIImage imageNamed:@"hp_icon_default_small"]];
//    [self.moreBtn setImage:[UIImage imageNamed:RBDataHandle.currentDevice.isPuddingPlus ? @"ic_more":@"hp_icon_more"] forState:UIControlStateNormal];

    self.userStudyScoreView.level = module.level;
    self.userStudyScoreView.wordNub = module.word;
    self.userStudyScoreView.sentenceCount = module.sentence;
    self.userStudyScoreView.studyTime = module.listen;
    self.userStudyScoreView.process = module.process;
    
}
@end


@implementation RBBookClassCollectView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleView.hidden = NO;
        self.titleLable.hidden = NO;
        self.titleIcon.hidden = NO;
        self.moreBtn.hidden = NO;
        self.collectionView.hidden = NO;
        self.newHotImage.hidden = NO;
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
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(47);
            make.width.mas_equalTo(self.mas_width);
            make.centerX.equalTo(self.mas_centerX);
        }];
        _titleView = view;
    }
    return _titleView;
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
    PDCategory *category = [self.module.categories objectAtIndexOrNil:indexPath.row];
    if(_selectBookCategory){
        _selectBookCategory(category);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.module.categories count];
}



- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBBookCaseClassCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBBookCaseClassCell class]) forIndexPath:indexPath];
    PDCategory *category = [self.module.categories objectAtIndexOrNil:indexPath.row];
    [cell setCategoty:category];
    return cell;
}

#pragma mark  titleicon 创建

- (UIImageView *)titleIcon{
    if(!_titleIcon){
        UIImageView  *titleIcon = [UIImageView new];
        [self.titleView addSubview:titleIcon];
        titleIcon.contentMode = UIViewContentModeScaleAspectFit;
        titleIcon.image = [UIImage imageNamed:@"hp_icon_default_small"];
        [titleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((15));
            make.centerY.mas_equalTo(self.moreBtn.mas_centerY);
            make.width.mas_equalTo((21));
            make.height.mas_equalTo((21));
        }];
        _titleIcon = titleIcon;
    }
    return _titleIcon;
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

#pragma mark hot

- (UIImageView *)newHotImage {
    if(!_newHotImage){
        UIImageView * hotImage = [UIImageView new];
        hotImage.image = [UIImage imageNamed:@"homepage_new_guide"];
        [self.titleView addSubview:hotImage];

        [hotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLable.mas_right).offset(8);
            make.centerY.equalTo(self.titleLable.mas_centerY);
        }];
        _newHotImage = hotImage;
    }
    return _newHotImage;
}

#pragma mark button action

- (void)moreContentHandle{
    if(_moreContentBlock){
        _moreContentBlock();
    }
}



#pragma mark  set Datasource

-(void)setModule:(PDModule *)module{
    if(_module == module){
        return;
    }
    _module = module;
    [self.collectionView reloadData];

    self.titleLable.text = module.title;

    [self.titleIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",module.icon]] placeholder:[UIImage imageNamed:@"hp_icon_default_small"]];
//    [self.moreBtn setImage:[UIImage imageNamed:RBDataHandle.currentDevice.isPuddingPlus ? @"ic_more":@"hp_icon_more"] forState:UIControlStateNormal];

}
@end


@interface RBPuddingMessageLine : UIView

@end

@implementation RBPuddingMessageLine

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 0, self.bounds.size.height/2);
    CGContextAddLineToPoint(context, (25), self.bounds.size.height/2);
    
    CGContextMoveToPoint(context, CGRectGetWidth(rect) - (25), self.bounds.size.height/2);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), self.bounds.size.height/2);
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, mRGBToColor(0xcccccc).CGColor);
    CGContextStrokePath(context);
}

@end


@implementation RBPuddingSelectiveMesCollectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    }
    return self;
}

- (UILabel *)contentLable{
    if(!_contentLable ){
        UILabel * lable = [[UILabel alloc] init];
        lable.textColor = mRGBToColor(0x9da5b3);
        lable.font = [UIFont systemFontOfSize:(14)];
        lable.preferredMaxLayoutWidth = self.width - (60 * 2);
        [lable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:lable];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-(5));
            make.height.equalTo(@((16)));
        }];
        
        
        RBPuddingMessageLine * bgView = [[RBPuddingMessageLine alloc] init];
        bgView.backgroundColor = [UIColor clearColor];
        [self insertSubview:bgView belowSubview:lable];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(lable);
            make.height.equalTo(lable.mas_height).offset((12));
            make.width.equalTo(lable.mas_width).offset((85));
        }];
        _contentLable = lable;
    }
    return _contentLable;
}


- (void)setContentMessage:(NSString *)contentMessage{
    self.contentLable.text = contentMessage;
}
@end


@implementation RBPuddingSelectTypeCollectView
//背景圆角最上面距离下边高度
#define round_top 46
//背圆角最下面距离下边高度
#define round_bottom 20
//内容页面背景距顶部高度
#define internal_top 0
//内容页面背景两边边距
#define internal_padding 15
//内容页面背景圆角
#define internal_radius 15
//内容页面背景高度
//#define internal_height 176
//内容页面两侧边距
#define content_padding 15.5
//内容页面icon 距离
#define content_margin (13)
//内容页面上边距
#define content_up_padding 15
//内容页面下边距
#define content_bottom_padding 32.5

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        self.bgColor = [UIColor colorWithRed:142/255.0 green:194/255.0 blue:31/255.0 alpha:1];

        [self configCollectionView];
        [self configPageView];
    }
    return self;
}


- (void)setBgColor:(UIColor *)bgColor{
//mRGBToColor(0x26bef5)

    _bgColor = bgColor;

    [self setNeedsDisplay];
}

- (void)setDataSources:(NSArray *)dataSources{
    
    NSMutableArray * array = [NSMutableArray new];
    for(int i = 0 ; i < (int)ceil(dataSources.count / 8.0);i++){
        
        [array addObject:[dataSources subarrayWithRange:NSMakeRange(i * 8, MIN(8, dataSources.count - i * 8))]];
    }
    
    _dataSources = array;
    [self.collectionView reloadData];
    self.pageView.numberOfPages = self.dataSources.count;
    
}



- (void)configPageView{
    UIPageControl * pageView = [[UIPageControl alloc] initWithFrame:CGRectMake(internal_padding,  self.collectionView.bottom  - internal_padding - 6, CGRectGetWidth(self.frame) - internal_padding *2, 15)];
    pageView.userInteractionEnabled = NO;
    pageView.backgroundColor = [UIColor clearColor];
    [self addSubview:pageView];
    pageView.pageIndicatorTintColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    pageView.currentPageIndicatorTintColor = [UIColor colorWithRed:142/255.0 green:195/255.0 blue:31/255.0 alpha:1];
    pageView.currentPage = 0;
    pageView.numberOfPages = 5;
    pageView.transform=CGAffineTransformScale(CGAffineTransformIdentity, .6, .6);
    
    pageView.hidesForSinglePage = YES;
    self.pageView = pageView;
}




- (void)configCollectionView {
    CGFloat itemWidth = SX(70);
    CGFloat itemheight = 55;
    
    float collectWidth = CGRectGetWidth(self.frame) - internal_padding * 2;
    
    RBMainHeaderClsLayout *flowLayout = [[RBMainHeaderClsLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(content_up_padding, content_padding, content_bottom_padding, content_padding);
    flowLayout.itemSize = CGSizeMake(itemWidth, itemheight);
    flowLayout.minimumLineSpacing = (collectWidth - itemWidth * 4 - content_padding * 2)/3.0f;
    flowLayout.minimumInteritemSpacing = 0;
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(internal_padding, internal_top, collectWidth , self.height  - internal_top) collectionViewLayout:flowLayout];
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [self  addSubview:collectionView];
    collectionView.bounces = NO;
    [collectionView setCanCancelContentTouches:YES];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [collectionView registerClass:[RBPuddingSelectTypeCell class] forCellWithReuseIdentifier:NSStringFromClass([RBPuddingSelectTypeCell class])];
    
    
    self.collectionView = collectionView;
    UIImageView *maskView = [[UIImageView alloc] init];
    maskView.image = [UIImage imageNamed:@"hp_mask"];
    [self addSubview:maskView];
}


#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.dataSources.count;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell ;
    
    if([[self.dataSources objectAtIndex:indexPath.section] count] > indexPath.row ){
        PDCategory * modle = [[self.dataSources objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBPuddingSelectTypeCell class]) forIndexPath:indexPath];
        [((RBPuddingSelectTypeCell *)cell) setModle:modle ];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor clearColor];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.SelectDataBlock && [[self.dataSources objectAtIndex:indexPath.section] count]){
        PDCategory * modle = [[self.dataSources objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        self.SelectDataBlock(modle);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    [self.pageView setCurrentPage:page];
}


#pragma mark -

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    //1.获取图形上下文
    CGContextRef ctx=UIGraphicsGetCurrentContext();

    //2.绘图
    //2.1创建一条直线绘图的路径
    //注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CGMutablePathRef path=CGPathCreateMutable();
    //2.2把绘图信息添加到路径里
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMaxY(rect) - round_top);
    CGPathAddQuadCurveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMaxY(rect) - round_bottom, CGRectGetMinX(rect), CGRectGetMaxY(rect) - round_top);
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));


    CGContextSetLineWidth(ctx, 0);
    CGContextSetFillColorWithColor(ctx, [RBCommonConfig getCommonColor].CGColor);
    //2.3把路径添加到上下文中
    //把绘制直线的绘图信息保存到图形上下文中




    CGContextAddPath(ctx, path);

    CGContextDrawPath(ctx, kCGPathFill);
    CGContextFillPath(ctx);
    //4.释放前面创建的两条路径
    //第一种方法
    CGPathRelease(path);

    CGRect drawRect = {internal_padding,internal_top,CGRectGetWidth(rect) - internal_padding * 2,self.collectionView.height};

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);


    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:internal_radius];
    CGContextAddPath(context, bezierPath.CGPath);

    CGContextDrawPath(context, kCGPathFill);
    CGContextFillPath(context);


}



@end

#define GroupCount 20 //制造4组数据，给无限滚动提供足够多的数据
#define UpdateTime 5
#import "RBMainBannerLayout.h"

@interface RBPuddingBannerCollectView()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableArray * dataGroups;
    NSTimer        * timer;
}
@property (nonatomic,weak) UICollectionView * collectView;

@end

@implementation RBPuddingBannerCollectView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
//        self.bgColor = [UIColor colorWithRed:142/255.0 green:194/255.0 blue:31/255.0 alpha:1];
        self.collectView.hidden = NO;
    }
    return self;
}
- (void)setDataSource:(NSArray<PDCategory *> *)dataSource{
    _dataSource = dataSource;
    if(dataGroups == nil){
        dataGroups = [NSMutableArray new];
    }else{
        [dataGroups removeAllObjects];
    }
    for (int i = 0 ; i < GroupCount ; i ++) {
        [dataGroups addObject:[dataSource copy]];
    }
    [self.collectView reloadData];
    
    
    // 定位到 第2组(中间那组)
    [self.collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:GroupCount/2] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer timerWithTimeInterval:UpdateTime target:self selector:@selector(selectNextBanner:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}


- (UICollectionView *)collectView{
    if(!_collectView){
        
        RBMainBannerLayout * layout = [RBMainBannerLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 1;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = CGSizeMake((210), (110));
        
        UICollectionView * view = [[UICollectionView alloc] initWithFrame:CGRectMake((15), (15), self.width - (30), self.height - (30)) collectionViewLayout:layout];
        view.backgroundColor = [UIColor clearColor];
        view.delegate = self;
        view.dataSource = self;
        [self addSubview:view];
        
        view.showsHorizontalScrollIndicator = false ;
        [view registerClass:[RBMainBannerCell class] forCellWithReuseIdentifier:@"RBMainBannerCell"];
        
        _collectView = view;
    }
    return _collectView;
}


#pragma mark - handle timer method
-(void)pauseTimer{
    if (![timer isValid]) {
        return ;
    }
    [timer setFireDate:[NSDate distantFuture]]; //如果给我一个期限，我希望是20001-01-01 00:00:00 +0000
}

-(void)resumeTimer{
    if (![timer isValid]) {
        return ;
    }
    [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:UpdateTime]];
}

#pragma mark - handle scroll method

- (void)scrollToMiddleSession{
    NSIndexPath * indexNow = [self getCurrentIndex];
    [self.collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexNow.row inSection:GroupCount/2] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    
}

- (NSIndexPath *)getCurrentIndex{
    CGPoint point = [self convertPoint:self.collectView.center toView:self.collectView];
    NSIndexPath * indexNow = [self.collectView indexPathForItemAtPoint:point];
    return indexNow;
}

- (void)selectNextBanner:(NSTimer *)sender{
    NSIndexPath * index = [self getCurrentIndex];
    if(index.row < (self.dataSource.count - 1)){
        index = [NSIndexPath indexPathForRow:index.row + 1 inSection:index.section];
    }else{
        index = [NSIndexPath indexPathForRow:0 inSection:index.section + 1];
    }
    
    [self.collectView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
}

#pragma mark -  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[dataGroups objectAtIndex:section] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBMainBannerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RBMainBannerCell" forIndexPath:indexPath];
    PDCategory * m = [[dataGroups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setImageURL:m.img];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self resumeTimer];
    
    NSIndexPath * midIndex = [self getCurrentIndex];
    if([midIndex isEqual:indexPath]){
        NSLog(@"点中的是最中间的");
        PDCategory * m = [[dataGroups mObjectAtIndex:indexPath.section] mObjectAtIndex:indexPath.row];

        if(self.SelectDataBlock && m){
            PDCategory * m1 = [m copy];
            m1.img = NULL;
            self.SelectDataBlock(m1);
            
        }
        
    }else{
        NSLog(@"点中的是边上");
        [self.collectView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 5);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [dataGroups count];
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
    
    
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

#pragma mark - UIScrollViewDelegate

////设置滑动速度
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self pauseTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollToMiddleSession];
    [self resumeTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollToMiddleSession];
}

//减少自动滚动的距离
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
 
    CGRect targetRect = CGRectMake(targetContentOffset->x, targetContentOffset->y, scrollView.frame.size.width, scrollView.frame.size.height);
    // 目标区域中包含的cell
    NSArray * attArray = [self.collectView.collectionViewLayout layoutAttributesForElementsInRect:targetRect];
    // collectionView落在屏幕中点的x坐标
    float horizontalCenterX = CGRectGetMidX(targetRect);
    
    float offsetAdjustment = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes * att in attArray) {
        float centerx = att.center.x;
        if(fabsf(horizontalCenterX - centerx) < fabsf(offsetAdjustment)){
            offsetAdjustment = centerx - horizontalCenterX;
        }
    }

    targetContentOffset->x = targetContentOffset->x + offsetAdjustment;

}

@end


#pragma mark - RBGrowthGuideClassCollectView
@interface RBGrowthGuideClassCollectView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak) UILabel * titleLable;
@property(nonatomic,weak) UILabel * descLable;
@property(nonatomic,weak) UIImageView   *titleIcon;
@property(nonatomic,weak) UICollectionView *collectionView;

@end

#import "RBGrowthGuideCell.h"
@implementation RBGrowthGuideClassCollectView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleLable.hidden = NO;
        self.titleIcon.hidden = NO;
        self.moreBtn.hidden = NO;
        self.collectionView.hidden = NO;
        
    }
    return self;
}

#pragma mark  more 创建

- (UIButton *)moreBtn{
    if(!_moreBtn){
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:moreBtn];
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
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = (10);
        //        flowLayout.sectionInset = UIEdgeInsetsMake(0, 17, 0, 17);
        flowLayout.minimumInteritemSpacing = (10);
        flowLayout.itemSize = CGSizeMake(SX(116), SX(115));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.alwaysBounceHorizontal = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self  addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mas_bottom).offset(-(16));
            make.left.equalTo(@((15)));
            make.right.equalTo(self.mas_right).offset(-(15));
            make.height.equalTo(@(SX(120)));
            make.top.mas_equalTo(self.descLable.mas_bottom).offset(SX(10));
        }];
        [collectionView registerClass:[RBGrowthGuideCell class] forCellWithReuseIdentifier:NSStringFromClass([RBGrowthGuideCell class])];
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    PDCategory *category = [self.module.categories objectAtIndexOrNil:indexPath.row];
    if(_selectClassCategory){
        _selectClassCategory(indexPath.row);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.module.categories count];
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBGrowthGuideCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBGrowthGuideCell class]) forIndexPath:indexPath];
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
            make.centerY.mas_equalTo(self.moreBtn.mas_centerY);
            make.width.mas_equalTo((21));
            make.height.mas_equalTo((21));
        }];
        _titleIcon = titleIcon;
    }
    return _titleIcon;
}

#pragma mark  titleLable 创建
- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.textColor = mRGBToColor(0x4a4a4a);
        titleLabel.font = [UIFont systemFontOfSize:17];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleIcon.mas_right).offset((5));
            make.top.mas_equalTo(0);
            make.height.mas_equalTo((47));
        }];
        _titleLable = titleLabel;
        
        UILabel *descLab = [UILabel new];
        [self addSubview:descLab];
        descLab.textColor = mRGBToColor(0x919bAA);
        descLab.font = [UIFont systemFontOfSize:13];
        descLab.backgroundColor =RGB(245, 246, 247);
        descLab.layer.cornerRadius = 10;
        descLab.layer.masksToBounds = YES;
        [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleIcon.mas_left);
            make.top.mas_equalTo(_titleIcon.mas_bottom).offset((5));
            make.height.mas_equalTo(20);
        }];
        _descLable = descLab;
        
    }
    return _titleLable;
}

#pragma mark button action

- (void)moreContentHandle{
    if(_moreContentBlock){
        _moreContentBlock();
    }
}

#pragma mark  set Datasource

-(void)setModule:(PDModule *)module{
    if(_module == module){
        return;
    }
    _module = module;
    [self.collectionView reloadData];
    self.titleLable.text = module.title;
    NSMutableString *descStr = [NSMutableString stringWithString:@"  培养"];
    for (int i=0; i<module.tags.count; i++) {
        NSString *str = [module.tags[i] lastObject];
        [descStr appendString:str];
        if (i != module.tags.count-1) {
            [descStr appendString:@" / "];
        }
        else{
            [descStr appendString:@"  "];
        }
    }
    self.descLable.text = descStr;
    [self.titleIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",module.icon]] placeholder:[UIImage imageNamed:@"hp_icon_default_small"]];
//    [self.moreBtn setImage:[UIImage imageNamed:RBDataHandle.currentDevice.isPuddingPlus ? @"ic_more":@"hp_icon_more"] forState:UIControlStateNormal];
}
@end

#pragma mark - RBTodayPlainCollectView
@interface RBTodayPlainCollectView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak) UILabel * titleLable;
@property(nonatomic,weak) UIImageView   *titleIcon;
@property(nonatomic,weak) UICollectionView *collectionView;

@end

#import "RBTodayPlainCollectionViewCell.h"
@implementation RBTodayPlainCollectView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleLable.hidden = NO;
        self.titleIcon.hidden = NO;
        self.moreBtn.hidden = NO;
        self.collectionView.hidden = NO;
        
    }
    return self;
}

#pragma mark  more 创建

- (UIButton *)moreBtn{
    if(!_moreBtn){
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_arrow"]];
        arrow.contentMode = UIViewContentModeCenter;
        [self addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(16);
            make.width.mas_equalTo(@(10));
            make.right.mas_equalTo(-10);
        }];
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:moreBtn];
//        [moreBtn setImage:[UIImage imageNamed:RBDataHandle.currentDevice.isPuddingPlus ? @"ic_more" :  @"hp_icon_more"] forState:UIControlStateNormal];
        [moreBtn setTitle:@"本周计划" forState:(UIControlStateNormal)];
        [moreBtn setTitleColor:mRGBToColor(0x9b9b9b) forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(arrow.mas_centerY);
            make.right.mas_equalTo(arrow.mas_left).offset(-3);
            make.width.mas_equalTo(@(60));
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
        flowLayout.minimumLineSpacing = (10);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        flowLayout.minimumInteritemSpacing = (5);
        flowLayout.itemSize = CGSizeMake(190, 82);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.alwaysBounceHorizontal = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self  addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.bottom.equalTo(self.mas_bottom).offset(-(16));
            make.left.equalTo(@((0)));
            make.right.equalTo(self.mas_right).offset(0);
            make.height.equalTo(@(192));
            make.top.mas_equalTo(self.titleLable.mas_bottom).offset(SX(10));
        }];
        [collectionView registerNib:[UINib nibWithNibName:@"RBTodayPlainCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([RBTodayPlainCollectionViewCell class])];
        [collectionView registerClass:[RBTodayPlainCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([RBTodayPlainCollectionViewCell class])];
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    PDCategory *category = [self.module.categories objectAtIndexOrNil:indexPath.row];
    if(_selectClassCategory){
        _selectClassCategory(indexPath.row);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.module.categories count];
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBTodayPlainCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBTodayPlainCollectionViewCell class]) forIndexPath:indexPath];
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
            make.centerY.mas_equalTo(self.moreBtn.mas_centerY);
            make.width.mas_equalTo((21));
            make.height.mas_equalTo((21));
        }];
        _titleIcon = titleIcon;
    }
    return _titleIcon;
}

#pragma mark  titleLable 创建
- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.textColor = mRGBToColor(0x4a4a4a);
        titleLabel.text = @"今日计划";
        titleLabel.font = [UIFont systemFontOfSize:15];
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
        _moreContentBlock();
    }
}

#pragma mark  set Datasource

-(void)setModule:(PDModule *)module{
    if(_module == module){
        return;
    }
    _module = module;
    [self.collectionView reloadData];
    self.titleLable.text = module.title;
    NSMutableString *descStr = [NSMutableString stringWithString:@"  培养"];
    for (int i=0; i<module.tags.count; i++) {
        NSString *str = [module.tags[i] lastObject];
        [descStr appendString:str];
        if (i != module.tags.count-1) {
            [descStr appendString:@" / "];
        }
        else{
            [descStr appendString:@"  "];
        }
    }
        [self.titleIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",module.icon]] placeholder:[UIImage imageNamed:@"hp_icon_default_small"]];
    //    [self.moreBtn setImage:[UIImage imageNamed:RBDataHandle.currentDevice.isPuddingPlus ? @"ic_more":@"hp_icon_more"] forState:UIControlStateNormal];
}

@end
#pragma mark - RBMainMenuHeader_XCollectView
@interface RBMainMenuHeader_XCollectView()

@end

#import "RBMainMenuHeader_X.h"
@implementation RBMainMenuHeader_XCollectView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        RBMainMenuHeader_X *headerView = [[[NSBundle mainBundle] loadNibNamed:@"RBMainMenuHeader_X" owner:nil options:nil] firstObject];
        [self addSubview: headerView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end
