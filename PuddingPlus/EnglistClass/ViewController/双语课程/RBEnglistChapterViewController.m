//
//  RBEnglistChapterViewController.m
//  PuddingPlus
//
//  Created by kieran on 2017/2/28.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglistChapterViewController.h"
#import "RBEnglishSessionHeaderView.h"
#import "RBEnglishSessionDetailFlowLayout.h"
#import "RBEnglishStudyInfoCell.h"
#import "RBEnglistTypeReusableView.h"
#import "RBEnglishChapterModle.h"
#import "RBNetworkHandle+resouse_device.h"
#import "UIViewController+RBNodataView.h"
#import "UIViewController+RBAlter.h"
#import "NSObject+RBSelectorAvoid.h"


@interface RBEnglistChapterViewController ()<RBEnglishSessionDetailFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,weak) RBEnglishSessionHeaderView * headerView;

@property (nonatomic ,weak) UICollectionView   * collectionView;

@property (nonatomic, weak) UIView  * headBgView;

@property (nonatomic, strong) NSArray   * dataSource;

@property (nonatomic, weak) UIButton  * startStudyBtn;

@property (nonatomic, strong) RBEnglishChapterModle * chaModle;

@end

@implementation RBEnglistChapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"class_info", @"课程详情");
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.headerView.hidden = NO;
    self.headBgView.hidden = NO;
    self.collectionView.hidden = NO;
    self.startStudyBtn.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    [self loadCache];
    [self loadNetData];

}

- (void)loadCache{
    NSDictionary * dict = [PDNetworkCache cacheForKey:[NSString stringWithFormat:@"english_Chapter_%@_%d",RB_Current_Mcid,self.chapterModle.chapter_id]];
    if(![dict mIsDictionary]){
        dict = nil;
        [PDNetworkCache saveCache:dict forKey:[NSString stringWithFormat:@"english_Chapter_%@_%d",RB_Current_Mcid,self.chapterModle.chapter_id]];
    }
    [self pauseData:dict IsLocalData:YES];
}

- (void)pauseData:(NSDictionary *)res IsLocalData:(BOOL)islocal{
    RBEnglishChapterModle * modle = [RBEnglishChapterModle modelWithDictionary:[res objectForKey:@"data"]];
    self.chaModle = modle;
    if(!islocal){
        [PDNetworkCache saveCache:res forKey:[NSString stringWithFormat:@"english_Chapter_%@_%d",RB_Current_Mcid,self.chapterModle.chapter_id]];
    }
    [self reloadData];
}

- (void)reloadData{
    [self.headerView setChaModle:self.chaModle];
    [self.collectionView reloadData];
    
    NSInteger count = 0;
    count += [self.chaModle.word.list count];
    count += [self.chaModle.sentence.list count];
    count += [self.chaModle.listen.list count];
    
    if(count == 0){
        [self showNoDataView];
    }else{
        [self hiddenNoDataView];
    }
}

- (void)loadNetData{
    @weakify(self)
    [MitLoadingView showWithStatus:@"loading"];
    [RBNetworkHandle fetchEnglishChapter:self.chapterModle.chapter_id  block:^(id res) {
        @strongify(self)
        if(res && [[res objectForKey:@"result"] integerValue] == 0){
            [MitLoadingView dismiss];
            [self pauseData:res IsLocalData:NO] ;
        }else{
            [self pauseData:nil IsLocalData:NO] ;

            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (RBEnglishSessionHeaderView *)headerView{
    if(!_headerView){
        RBEnglishSessionHeaderView * v = [RBEnglishSessionHeaderView new];
        [self.headBgView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(30));
            make.left.equalTo(self.headBgView.mas_left).offset(20);
            make.right.equalTo(self.headBgView.mas_right).offset(-20);
            make.height.equalTo(@(110));
        }];
        _headerView = v;
    }
    return _headerView;
}


- (void)studyAction:(id)sender{
    if(!self.chaModle){
        [MitLoadingView showErrorWithStatus:NSLocalizedString(@"data_load_fail", @"数据加载失败")];
        return;
    }
    [RBDataHandle checkConflictPlusApp:@"study" Block:^(BOOL iscon, NSString *tipString, NSArray *tipButItem, NSInteger continueIndex, BOOL canContinue) {
        if(!iscon){ //没有应用冲突，布丁s直接返回
            [self beginstudy];
        }else{
            if(tipString){//是否需要弹窗
                if([tipButItem mCount] > 0){//弹有提示按钮的弹窗
                    [self  tipAlter:tipString ItemsArray:tipButItem :^(int index) {
                        if(index == continueIndex){
                            [self beginstudy];
                        }
                    }];
                }else{
                    [MitLoadingView showErrorWithStatus:tipString];
                }
            }
        }

        
    }];
    
}

- (void)beginstudy{
    [MitLoadingView showWithStatus:@"loading"];

    [RBNetworkHandle studyEnglishChapter:self.chapterModle.chapter_id block:^(id res) {
        if(res && [[res objectForKey:@"result"] integerValue] == 0){
            [MitLoadingView showErrorWithStatus:NSLocalizedString(@"play_scuess_wait", @"点播成功，请稍后")];
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
        
    }];
}

- (UIButton *)startStudyBtn{
    if(!_startStudyBtn){
    
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageWithColor:mRGBToColor(0x8ec31f)] forState:0];
        [btn setTitle:NSLocalizedString(@"begin_study", @"开始学习") forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn addTarget:self action:@selector(studyAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 22;
        btn.clipsToBounds = YES;
        [self.view addSubview:btn];
        
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44);
            make.left.equalTo(self.view.mas_left).offset(35);
            make.right.equalTo(self.view.mas_right).offset(-35);
            if (IS_IPHONE_X){
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);

            } else{
                make.bottom.equalTo(self.view.mas_bottom).offset(-10);

            }
        }];
        
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = mRGBToColor(0xe1e7ec);
        [self.view addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(btn.mas_top).offset(-10);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            
        }];
        
        _startStudyBtn = btn;
        
    }
    return _startStudyBtn;
}

- (UIView *)headBgView{
    if(!_headBgView){
        UIView * v = [UIView new];
        [v setBackgroundColor:[UIColor whiteColor]];
        [self.view insertSubview:v belowSubview:self.navView ];
        
        v.frame = CGRectMake(0, NAV_HEIGHT, SC_WIDTH, 170);
        
        UIView * v1 = [UIView new];
        [v1 setBackgroundColor: mRGBToColor(0xf7f7f7)];
        [v addSubview:v1 ];
        v1.frame = CGRectMake(0, 160, SC_WIDTH, 10);
        _headBgView = v;
    }
    return _headBgView;
}

#pragma mark collectionView create

- (UICollectionView *)collectionView{
    if(!_collectionView){
        RBEnglishSessionDetailFlowLayout *flowLayout = [[RBEnglishSessionDetailFlowLayout alloc] init];
        flowLayout.delegate = self;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView setContentInset:UIEdgeInsetsMake(170 , 10, 0, 10)];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        [self.view insertSubview:collectionView belowSubview:self.headBgView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(NAV_HEIGHT));
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(-64 - SC_FOODER_BOTTON);
        }];
        [collectionView registerClass:[RBEnglishStudyInfoCell class] forCellWithReuseIdentifier:NSStringFromClass([RBEnglishStudyInfoCell class])];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        [collectionView registerClass:[RBEnglistTypeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RBEnglistTypeReusableView"];
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - RBEnglishSessionDetailFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBEnglishKnowledgeModle * ledgemodle = nil;
    
    RBStudyType type ;
    if(indexPath.section == 0){
        ledgemodle = [self.chaModle.word.list objectAtIndex:indexPath.row];
        type =RBStudyTypeWord;
    }else if(indexPath.section == 1){
        ledgemodle = [self.chaModle.sentence.list objectAtIndex:indexPath.row];
        type =RBStudyTypeSentence;

    }else if(indexPath.section == 2){
        ledgemodle = [self.chaModle.listen.list objectAtIndex:indexPath.row];
        type =RBStudyTypeListen;
    }else{
        return CGSizeZero;
    }
    return [RBEnglishStudyInfoCell getCellWidth:ledgemodle.content DesString:ledgemodle.meaning StudyType:type];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 18;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView  minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView referenceSizeForHeaderInSection:(NSInteger)section{
    
    NSInteger count = 0;
    if(section == 0){
        count = [self.chaModle.word.list count];
    }else if(section == 1){
        count = [self.chaModle.sentence.list count];
    }else if(section == 2){
        count = [self.chaModle.listen.list count];
    }else{
        return CGSizeZero;
    }
    if(count == 0)
        return CGSizeZero;
    return CGSizeMake(SC_WIDTH, 46);
}

- (CGSize)collectionView:(UICollectionView *)collectionView referenceSizeForFooterInSection:(NSInteger)section{
    if(section == 2)
        return CGSizeZero;
    
    return CGSizeMake(SC_WIDTH, 0.5);
}

- (UIEdgeInsets)sizeForSessionInset{
    return UIEdgeInsetsMake(3, 8, 18, 8);
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(section == 0){
        return  [self.chaModle.word.list count];
    }else if(section == 1){
        return [self.chaModle.sentence.list count];
    }else if(section == 2){
        return [self.chaModle.listen.list count];
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RBEnglishStudyInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBEnglishStudyInfoCell class]) forIndexPath:indexPath];
  
    RBEnglishKnowledgeModle * ledgemodle = nil;
        if(indexPath.section == 0){
        ledgemodle = [self.chaModle.word.list objectAtIndex:indexPath.row];
        [cell setInfo:ledgemodle.content DesString:ledgemodle.meaning StudyType:RBStudyTypeWord];
    }else if(indexPath.section == 1){
        ledgemodle = [self.chaModle.sentence.list objectAtIndex:indexPath.row];
        [cell setInfo:ledgemodle.content DesString:ledgemodle.meaning StudyType:RBStudyTypeSentence];
    }else if(indexPath.section == 2){
        ledgemodle = [self.chaModle.listen.list objectAtIndex:indexPath.row];
        [cell setInfo:ledgemodle.content DesString:ledgemodle.meaning StudyType:RBStudyTypeListen];
    }

    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    RBEnglishKnowledgeTypeModle * typeModle;
    if(indexPath.section == 0){
        typeModle = self.chaModle.word;
    }else if(indexPath.section == 1){
        typeModle = self.chaModle.sentence;
    }else if(indexPath.section == 2){
        typeModle = self.chaModle.listen;
    }
    
    if (kind == UICollectionElementKindSectionHeader){
        RBEnglistTypeReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RBEnglistTypeReusableView" forIndexPath:indexPath];
        if(indexPath.section == 0){
            [header setIconName:@"icon_word"];
        }else if(indexPath.section == 1){
            [header setIconName:@"icon_short"];
        }else if(indexPath.section == 2){
            [header setIconName:@"icon_ear"];
        }
        [header setTitleString:typeModle.name];

        if(typeModle.list.count == 0){
            header.hidden = YES;
        }else{
            header.hidden = NO;
        }
        [header setShowMoreBtn:NO];
        return header;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footer.backgroundColor = mRGBToColor(0xe1e7ec);
        if(typeModle.list.count == 0){
            footer.hidden = YES;
        }else{
            footer.hidden = NO;
        }
        return footer;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
    CGFloat offset_Y = scrollView.contentOffset.y+ 170;
    if  (offset_Y <1) {
        self.headBgView.top = NAV_HEIGHT;
    }else if (offset_Y >= 1 && offset_Y <= 170 ){
        self.headBgView.top = -offset_Y + NAV_HEIGHT;
    }else if(offset_Y > 170) {
        self.headBgView.top = -170 + NAV_HEIGHT;
    }
}
@end
