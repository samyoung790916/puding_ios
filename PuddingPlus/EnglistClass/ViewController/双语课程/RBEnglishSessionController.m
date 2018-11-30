//
//  RBEnglishSessionController.m
//  PuddingPlus
//
//  Created by kieran on 2017/2/28.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglishSessionController.h"
#import "RBEnglishSessionListHeader.h"
#import "RBEnglishSessionCell.h"
#import "RBEnglistChapterViewController.h"
#import "RBNetworkHandle+resouse_device.h"
#import "RBEnglishChapterModle.h"
#import "UIViewController+RBNodataView.h"


@interface RBEnglishSessionController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,weak) RBEnglishSessionListHeader * headerView;
@property (nonatomic,weak) UIView   * collectBgView;
@property (nonatomic,weak) UICollectionView   * collectionView;
@property (nonatomic,strong) RBEnglishClassSession * classSessionModle;
@end

@implementation RBEnglishSessionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"class_list", nil);
    self.headerView.hidden = NO;
    self.collectBgView.hidden = NO;
    self.collectionView.hidden = NO;
    self.view.backgroundColor = mRGBToColor(0xf7f7f7);

    [self loadCache];
    if(self.sessionInfo){
        [self loadNetData];
    }
}
- (void)loadCache{
    NSDictionary * dict = [PDNetworkCache cacheForKey:[NSString stringWithFormat:@"english_session_%@_%d",RB_Current_Mcid,self.sessionInfo.session_id]];
    if(![dict mIsDictionary]){
        dict = nil;
        [PDNetworkCache saveCache:dict forKey:[NSString stringWithFormat:@"english_session_%@_%d",RB_Current_Mcid,self.sessionInfo.session_id]];
    }
    [self pauseData:dict IsLocalData:YES];
}

- (void)pauseData:(NSDictionary *)res IsLocalData:(BOOL)islocal{
    RBEnglishClassSession * modle = [RBEnglishClassSession modelWithDictionary:[res objectForKey:@"data"]];
    self.classSessionModle = modle;
    [self reloadData];
    if(!islocal){
        [PDNetworkCache saveCache:res forKey:[NSString stringWithFormat:@"english_session_%@_%d",RB_Current_Mcid,self.sessionInfo.session_id]];
    }
    [self reloadData];
}


- (void)loadNetData{
    
    [MitLoadingView showWithStatus:@"loading"];
    @weakify(self)
    [RBNetworkHandle fetchAllEnglishSessionList:self.sessionInfo.session_id Page:1 block:^(id res) {
        
        @strongify(self)
        NSLog(@"%@",res);
        if(res && [[res objectForKey:@"result"] integerValue] == 0){
            [self pauseData:res IsLocalData:NO];
            [MitLoadingView dismiss];
        }else{
            [self pauseData:nil IsLocalData:NO];

            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}


- (void)reloadData{
    [self.headerView setIconURL:self.classSessionModle.img];
    [self.headerView setDescString:self.classSessionModle.desc];
    [self.headerView setTitleString:self.classSessionModle.name];
    
    [self.collectionView reloadData];
    
    NSUInteger count = [self.classSessionModle.list count];
    if(count == 0){
        [self showNoDataView];
    }else{
        [self hiddenNoDataView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collectionView create

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = SX(30);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, SX(20), 5, SX(20));
        flowLayout.minimumInteritemSpacing = 15;
        flowLayout.itemSize = CGSizeMake(SX(80), SX(122));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.alwaysBounceHorizontal = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectBgView  addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectBgView.mas_top).offset(24);
            make.left.equalTo(self.collectBgView.mas_left);
            make.right.equalTo(self.collectBgView.mas_right);
            make.bottom.equalTo(self.collectBgView.mas_bottom).offset(-20);
        }];
        [collectionView registerClass:[RBEnglishSessionCell class] forCellWithReuseIdentifier:NSStringFromClass([RBEnglishSessionCell class])];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIView *)collectBgView{
    if(!_collectBgView){
        UIView * bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 15;
        bgView.clipsToBounds = YES;
        [self.view addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(self.headerView.mas_bottom).offset(27);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.bottom.equalTo(self.view.mas_bottom).offset(15);
        }];
        
        _collectBgView = bgView;
    }
    return _collectBgView;
}

- (RBEnglishSessionListHeader *)headerView{
    if(!_headerView){
        RBEnglishSessionListHeader * view = [RBEnglishSessionListHeader new];
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(NAV_HEIGHT + 30));
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.equalTo(@(110));
        }];
        
        _headerView = view;
    }
    return _headerView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RBEnglishChapterModle * modle = [self.classSessionModle.list objectAtIndex:indexPath.row];

    if(modle.locked){
        [MitLoadingView showErrorWithStatus:NSLocalizedString(@"current_class_not_unlock", nil)];
        return;
    }
    
    RBEnglistChapterViewController * vc = [RBEnglistChapterViewController new];
    [vc setChapterModle:modle];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.classSessionModle.list count];
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBEnglishSessionCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBEnglishSessionCell class]) forIndexPath:indexPath];
    RBEnglishChapterModle * modle = [self.classSessionModle.list objectAtIndex:indexPath.row];
    [cell setChapterModle:modle];
    return cell;
}


@end
