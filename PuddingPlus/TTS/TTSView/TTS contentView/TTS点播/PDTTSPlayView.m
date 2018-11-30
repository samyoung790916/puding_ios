//
//  PDTTSPlayView.m
//  Pudding
//
//  Created by zyqiong on 16/5/17.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSPlayView.h"
#import "PDTTSPlayChildView.h"
#import "PDTTSPlayCell.h"
#import "PDCategories.h"
#import "MJRefresh.h"
#import "PDFeatureModle.h"

@interface PDTTSPlayView ()

@property (nonatomic,strong) UITableView *tableView;



/** 自动定位到当前播放歌曲 */
// 最高层的model
@property (nonatomic,strong) PDFeatureModle *finalModel;
@property (nonatomic, assign) NSInteger currPage;
@property (nonatomic, strong) PDCategories *currCategory;
@end

@implementation PDTTSPlayView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.currPage = 1;
        [self setUpTableView];
        self.currCategory = [PDCategories new];
        [self loadAudioResources:NO];
    }
    return self;
}

-(void)loadAudioResources:(BOOL)moreDate{
    @weakify(self);
    NSInteger currAge = 0;
    NSString *ageStr = RBDataHandle.currentDevice.index_config;
    if (ageStr&&[ageStr hasPrefix:@"app.homepage."]) {
        NSString *age = [ageStr substringWithRange:NSMakeRange(@"app.homepage.".length, 1)];
        currAge = [age integerValue];
    }
    [RBNetworkHandle fetchVideoResoucesList:currAge page:self.currPage block:^(id res) {
        @strongify(self);
        if (moreDate) {
            [self.tableView.mj_footer endRefreshing];
        }
        PDCategories *category  = [PDCategories modelWithJSON:res];
        if (category.result == 0) {
            self.currPage++;
            NSMutableArray *filterCate = [self categoryFilterDate:category.categories];
            [self.currCategory.categories addObjectsFromArray:filterCate];
        }
        [self.tableView reloadData];
        if (category.categories.count <20) {
            self.tableView.mj_footer.hidden = YES;
        }
    }];
}
// 数据筛选
-(NSMutableArray*)categoryFilterDate:(NSArray*)categories{
   NSMutableArray *filterCategory = [NSMutableArray new];
   [categories enumerateObjectsUsingBlock:^( PDCategory*obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if ([obj.act isEqualToString:@"cate"]||[obj.act isEqualToString:@"tag"]) {
           [filterCategory addObject:obj];
       }
   }];
    return filterCategory;
}


- (void)removeTTSRestViews {
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAutomaticLocateNameList"];
    if ([str isEqualToString:@"yes"]) {
        for (UIView *vv  in self.subviews) {
            if ([vv isKindOfClass:[PDTTSPlayChildView class]]) {
                [vv removeFromSuperview];
            }
            
        }
    }
}

#pragma - mark datasource / delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currCategory.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PDTTSPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"play_Cell_Mine"];
    if (cell == nil) {
        cell = [[PDTTSPlayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"play_Cell_Mine"];
    }
    PDCategory *model = self.currCategory.categories[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    PDCategory *categoty = self.currCategory.categories[indexPath.row];
    PDFeatureModle *model = [PDFeatureModle new];
    model.mid = categoty.category_id;
    model.act = categoty.act;
    model.img = categoty.img;
    model.title = categoty.title;
    model.desc = categoty.desc;
    model.thumb = categoty.thumb;

    [self clickFeatureCell:model didSelect:YES];
}

- (void)clickFeatureCell:(PDFeatureModle *)model didSelect:(BOOL)didSelect{
    if(![RBDataHandle.currentDevice.online boolValue]){
        [MitLoadingView showErrorWithStatus:R.pudding_offline];
        return;
    }
    if(model.act != nil && ([model.act isEqualToString:@"cate"] || [model.act isEqualToString:@"tag"])){
        self.finalModel = nil;
        // 添加子view
        PDTTSPlayChildView *childView = [[PDTTSPlayChildView alloc] initWithFrame:self.bounds];
        childView.model = model;
        
        [self addSubview:childView];
        CGRect childFram =  childView.frame;
        childFram.origin.x = [UIScreen mainScreen].bounds.size.width;
        childView.frame = childFram;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect aaaaa = childView.frame;
            aaaaa.origin.x = 0;
            childView.frame = aaaaa;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"not_support_type", nil)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SX(50);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}

#pragma - mark set
- (void)setUpTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(SX(9), 0, 0, 0);
    [_tableView setSeparatorColor:mRGBToColor(0xe6e6e6)];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    _tableView.tableHeaderView = nil;
    if([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    [self addSubview:_tableView];
    @weakify(self);
   
    _tableView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
            @strongify(self)
            [self loadAudioResources:YES];
    }];
}

#pragma mark -
///更新内部数据
- (void)updateData{

}


- (void)dealloc {
}


@end
