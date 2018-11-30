//
//  RBStudyPrecisionViewController.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/2.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBStudyPrecisionViewController.h"
#import "RBStudyProgressHeaderView.h"
#import "RBEnglishSessionDetailFlowLayout.h"
#import "RBEnglishStudyInfoCell.h"
#import "RBEnglistTypeReusableView.h"
#import "RBEnglishChapterModle.h"
#import "RBNetworkHandle+resouse_device.h"
#import "RBStudyProcisonDetailViewController.h"
#import "MitLoadingView.h"
#import "UIViewController+RBNodataView.h"

#import "RBBabyScoreModle.h"
@interface RBStudyPrecisionViewController ()<RBEnglishSessionDetailFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,weak) RBStudyProgressHeaderView * headerView;

@property (nonatomic ,weak) UICollectionView   * collectionView;

@property (nonatomic, weak) UIView  * headBgView;

@property (nonatomic, strong) NSArray   * dataSource;

@property (nonatomic, strong) RBBabyScoreModle * chaModle;

@end

@implementation RBStudyPrecisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"baby_achievement", nil);
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.headerView.hidden = NO;
    self.headBgView.hidden = NO;
    self.collectionView.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadCache];
    [self loadNetData];
    
    self.tipString =NSLocalizedString(@"baby_has_not_start_to_study_bilingual_courses", nil);
    
}

- (void)loadCache{
    NSDictionary * dict = [PDNetworkCache cacheForKey:[NSString stringWithFormat:@"english_Study_%@",RB_Current_Mcid]];
    if(![dict mIsDictionary]){
        dict = nil;
        [PDNetworkCache saveCache:dict forKey:[NSString stringWithFormat:@"english_Study_%@",RB_Current_Mcid]];
    }
    [self pauseData:dict IsLocalData:YES];
}

- (void)pauseData:(NSDictionary *)res  IsLocalData:(BOOL)islocal{
    RBBabyScoreModle * modle = [RBBabyScoreModle modelWithDictionary:[res objectForKey:@"data"]];
    
    self.chaModle = modle;
    if(!islocal)
    [PDNetworkCache saveCache:res forKey:[NSString stringWithFormat:@"english_Study_%@",RB_Current_Mcid]];
    [self reloadData];
}


- (void)reloadData{
    [self.headerView setScoreModle:self.chaModle];
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
    [RBNetworkHandle babyStudyScoreblock:^(id res) {
        @strongify(self)
        if(res && [[res objectForKey:@"result"] integerValue] == 0){
            [MitLoadingView dismiss];
            [self pauseData:res IsLocalData:NO];

        }else{
            [self pauseData:nil IsLocalData:NO];

            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (RBStudyProgressHeaderView *)headerView{
    if(!_headerView){
        RBStudyProgressHeaderView * v = [RBStudyProgressHeaderView new];
        [self.headBgView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(30));
            make.left.equalTo(self.headBgView.mas_left).offset(20);
            make.right.equalTo(self.headBgView.mas_right).offset(-20);
            make.height.equalTo(@(100));
        }];
        _headerView = v;
    }
    return _headerView;
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
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView setContentInset:UIEdgeInsetsMake(170 , 10, 0, 10)];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        [self.view insertSubview:collectionView belowSubview:self.headBgView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(NAV_HEIGHT));
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        [collectionView registerClass:[RBEnglishStudyInfoCell class] forCellWithReuseIdentifier:NSStringFromClass([RBEnglishStudyInfoCell class])];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        [collectionView registerClass:[RBEnglistTypeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RBEnglistTypeReusableView"];
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - atcion

- (void)toDetailController:(NSInteger) section{
    RBStudyProcisonDetailViewController * controller = [RBStudyProcisonDetailViewController new];
    
    if(section == 0){
        controller.detailString = @"word";
    }else if(section == 1){
        controller.detailString = @"sentence";
    }else if(section == 2){
        controller.detailString = @"listen";
    }
    [self.navigationController pushViewController:controller animated:YES];

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
    NSInteger count = 0;
    if(section == 0){
        count = [self.chaModle.word total];
    }else if(section == 1){
        count = [self.chaModle.sentence total];
    }else if(section == 2){
        count = [self.chaModle.listen total];
    }
    if(count == 0)
        return 0;
    return 18;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView  minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    

    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView referenceSizeForHeaderInSection:(NSInteger)section{
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
    RBEnglishKnowledgeTypeModle * typeModle;
    if(section == 0){
        typeModle = self.chaModle.word;
    }else if(section == 1){
        typeModle = self.chaModle.sentence;
    }else if(section == 2){
        typeModle = self.chaModle.listen;
    }
    return MIN(typeModle.total, typeModle.list.count);
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
        [header setShowMoreBtn:YES];

        if(indexPath.section == 0){
            [header setIconName:@"icon_word"];
            if(typeModle.total > 0){
                [header setTitleString:[NSString stringWithFormat:NSLocalizedString(@"have_study_some_word", nil),typeModle.total] ];
            }else{
                [header setTitleString:NSLocalizedString(@"baby_has_not_study_word", nil) IsDisable:YES ];
            }
        }else if(indexPath.section == 1){
            [header setIconName:@"icon_short"];
            
            if(typeModle.total > 0){
                [header setTitleString:[NSString stringWithFormat:NSLocalizedString( @"already_study_n_sentence", nil),typeModle.total]];
            }else{
                [header setTitleString:NSLocalizedString( @"baby_not_yet_learning_sentence", nil) IsDisable:YES ];
            }
        }else if(indexPath.section == 2){
            [header setIconName:@"icon_ear"];
            NSString * str = nil;
            int time = typeModle.total;
            if(time < 60)
                str = [NSString stringWithFormat:NSLocalizedString( @"finish_the_influence_of_grind_ears_ns", nil),time];
            else if(time < 3600){
                if(time % 60 == 0){
                    str = [NSString stringWithFormat:NSLocalizedString( @"finish_the_influence_of_grind_the_ears_ns", nil),time/60];
                }else{
                    str = [NSString stringWithFormat:NSLocalizedString( @"completed_the_influence_of_grind_ears_minutes_seconds", nil),time/60,time%60];
                }
            
            }else if(time >= 3600){
                if(time  % 3600 == 0){
                    str = [NSString stringWithFormat:NSLocalizedString( @"completed_the_influence_of_grind_ears_clock", nil),time/3600];
                }else if(time % 60 == 0){
                    str = [NSString stringWithFormat:NSLocalizedString( @"completed_the_influence_of_grind_ears_clock_minutes", nil),time/3600,time/60%60];
                }else if(time % 60 != 0 && (time / 60 % 60) == 0){
                    str = [NSString stringWithFormat:NSLocalizedString( @"completed_the_influence_of_grind_ears_clock_seconds", nil),time/3600,time%60];
                }else{
                    str = [NSString stringWithFormat:NSLocalizedString( @"completed_the_confluence_of_grind_ears_clock_minutes_seconds", nil),time/3600,time/60%60,time%60];
                }
            }
            
            if(typeModle.total > 0){
                [header setTitleString:str ];
            }else{
                [header setTitleString:NSLocalizedString( @"baby_not_yet_confluence_of_grind_ears", nil) IsDisable:YES ];
            }
        }
        @weakify(self)
        [header setIndexPath:indexPath];
        [header setMoreContentBlock:^(RBEnglistTypeReusableView * sender) {
            @strongify(self)
            [self toDetailController:sender.indexPath.section];
        }];;
        if(typeModle.list.count == 0){
            header.hidden = YES;
        }else{
            header.hidden = NO;
        }
        
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
