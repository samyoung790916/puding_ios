//
//  PDPuddingResouceSearchViewController.m
//  PuddingPlus
//
//  Created by kieran on 2017/11/24.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDPuddingResouceSearchViewController.h"
#import "UIImage+TintColor.h"
#import "PDPuddingResouceSearchViewModle.h"
#import "RBSearchAlbumTableViewCell.h"
#import "MJRefresh.h"
#import "UINavigationController+RBFetureHelper.h"
typedef enum :NSInteger{
    PDTableMore = 1000,
    PDTableContent = 1002,
} PDTableType;

typedef enum :NSInteger{
    PDTableMoreAlbum = 0,
    PDTableMoreSingle = 1,
} PDTableMoreType;

@interface PDPuddingResouceSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    PDPuddingResouceSearchViewModle * viewModle;
    PDTableMoreType                  moreType;
}
@property(nonatomic,weak) UISearchBar * searchBar;
@property(nonatomic,weak) UITableView * searchTableView;
@property(nonatomic,weak) UITableView * searchMoreTableView;
@property(nonatomic,weak) UIButton    * backButton;
@property(nonatomic,weak) UIImageView * bgImageView;
@property(nonatomic,weak) UILabel     * bgTitleLable;;


@end

@implementation PDPuddingResouceSearchViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [viewModle invaild];
}

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString( @"pudding_recommend__", nil);
 
    viewModle = [[PDPuddingResouceSearchViewModle alloc] init];
    
    moreType = -1;

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bgImageView.hidden = NO;
    self.bgTitleLable.hidden = NO;
    
    self.searchBar.hidden = NO;
    self.searchTableView.hidden = NO;

    self.searchMoreTableView.alpha = 0;

    [self.searchBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];

    self.backButton.hidden = YES;

    self.view.clipsToBounds = YES;
    
    
    [self reloadData];
}


#pragma mark - init view

- (UIImageView *)bgImageView{
    if(!_bgImageView){
        UIImageView * image = (UIImageView *)^(){
            UIImageView * view = [[UIImageView alloc] init];
            view.contentMode = UIViewContentModeScaleAspectFit;
            if (RBDataHandle.currentDevice.isPuddingPlus) {
                view.image = [UIImage imageNamed:@"ic_kong_mass"];
            }else if (RBDataHandle.currentDevice.isStorybox){
                view.image = [UIImage imageNamed:@"img_kong_mass_x"];
            }else{
                view.image = [UIImage imageNamed:@"ic_kong_mass_s"];
            }
            return view;
        }();
        [self.view addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(SX(300)));
            make.height.equalTo(@SX(200));
            make.top.equalTo(self.searchBar.mas_bottom).offset(50);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        
        _bgImageView = image;
    }
    return _bgImageView;
}

-(UILabel *)bgTitleLable{
    if(!_bgTitleLable){
        UILabel * lable = (UILabel *)^(){
            UILabel * view = [[UILabel alloc] init];
            view.numberOfLines = 0;
            view.textAlignment = NSTextAlignmentCenter;
            view.lineBreakMode = NSLineBreakByWordWrapping;
            view.textColor = mRGBToColor(0x787878);
            view.font = [UIFont systemFontOfSize:15];
            return view;
        }();
        [self.view addSubview:lable];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.bgImageView.mas_width).offset(-50);
            make.top.equalTo(self.bgImageView.mas_bottom);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        _bgTitleLable = lable;
    }
    return _bgTitleLable;
}


- (UIButton *)backButton{
    if(!_backButton){
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 44)];
        [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
        [backButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backButton];
        
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.width.equalTo(@44);
            make.centerY.equalTo(self.searchBar.mas_centerY);
            make.height.equalTo(@50);
        }];
        
        _backButton = backButton;
    }
    return _backButton;
}

-(UITableView *)searchMoreTableView{
    if(!_searchMoreTableView){
        UITableView * tableView = (UITableView *)^(){
            UITableView * view = [[UITableView alloc] init];
            view.delegate = self;
            view.dataSource = self;
            view.separatorColor = mRGBToColor(0xeeeeee);
            view.backgroundColor = mRGBToColor(0xeeeeee);

            return view;
        }();
       
        tableView.tag = PDTableMore;
        [self.view addSubview:tableView];

        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBar.mas_bottom);
            make.bottom.equalTo(self.view.mas_bottom);
            make.left.equalTo(@(SC_WIDTH));
            make.width.equalTo(self.view.mas_width);
        }];
        _searchMoreTableView = tableView;
        
        @weakify(self);
        __weak typeof(viewModle) weakViewmodle = viewModle;

        
        MJRefreshAutoNormalFooter * fooder = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
            @strongify(self);

            __block PDSearchType searchtype = self->moreType == PDTableMoreAlbum ?  PDSearchAlbum : PDSearchSingle;

            [weakViewmodle fetureDataWithType:searchtype KeyWords:self.searchBar.text IsMore:YES ResultBlock:^(BOOL flag) {
                @strongify(self);

                __strong typeof(weakViewmodle) viewModle = weakViewmodle;

                [self.searchMoreTableView.mj_footer endRefreshing];
                [self reloadData];

                [viewModle hasMore:searchtype] ? [self.searchMoreTableView.mj_footer resetNoMoreData] : [self.searchMoreTableView.mj_footer endRefreshingWithNoMoreData];
                NSLog(@"-");
            }];

        }];
        
        
        tableView.mj_footer =  fooder;
    }
    return _searchMoreTableView;
    
}


-(UITableView *)searchTableView{
    if(!_searchTableView){
        UITableView * tableView = (UITableView *)^(){
            UITableView * view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            view.delegate = self;
            view.separatorColor = mRGBToColor(0xeeeeee);
            view.backgroundColor = mRGBToColor(0xeeeeee);
            view.dataSource = self;
            return view;
        }();
        tableView.tag = PDTableContent;
        [self.view addSubview:tableView];

        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBar.mas_bottom);
            make.bottom.equalTo(self.view.mas_bottom);
            make.left.equalTo(@(0));
            make.width.equalTo(self.view.mas_width);
        }];
        _searchTableView = tableView;
    }
    return _searchTableView;
}

- (UISearchBar *)searchBar{
    if(!_searchBar){
        
        UIView * navBg = (UIView *)^(){
            UIView * view = [[UIView alloc] init];
            view.backgroundColor = mRGBToColor(0xffffff);
            return view;
        }();
       
        
        [self.view addSubview:navBg];
        @weakify(self)
        UISearchBar * searchView = (UISearchBar *)^(){
            @strongify(self)
            UISearchBar * view = [[UISearchBar alloc] init];
            view.delegate = self;
            //设置背景图是为了去掉上下黑线
            view.backgroundImage = [[UIImage alloc] init];
            view.placeholder = NSLocalizedString( @"search_music_story_and_school_resource", nil);

            UIView *searchTextField = nil;
            // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
            view.barTintColor = [UIColor clearColor];
            searchTextField = [[[view.subviews firstObject] subviews] lastObject];
            searchTextField.backgroundColor = mRGBToColor(0xeeeeee);
            if ([searchTextField isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)searchTextField;
                textField.textColor = mRGBToColor(0x4a4a4a);
            }
            return view;
        }();
        
        UIButton * searchCancle = (UIButton *)^(){
            @strongify(self)
            UIButton * view = [[UIButton  alloc] init];
            [view setTitleColor:mRGBToColor(0x8ec31f) forState:UIControlStateNormal];
            [view setTitle:NSLocalizedString( @"g_cancel", nil) forState:0];
            view.titleLabel.font = [UIFont systemFontOfSize:SX(16)];
            view.titleLabel.textAlignment = NSTextAlignmentCenter;
            [view addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                @strongify(self)
                [self.navigationController popViewControllerAnimated:NO];

            }];
            return view;
        }();
        
        
        
        [navBg addSubview:searchView];
        [navBg addSubview:searchCancle];
        
        UIView * line = (UIView *)^(){
            UIView* view = [[UIView alloc] init];
            view.backgroundColor = mRGBToColor(0xa3a3a3);
            return view;
        }();
        [navBg addSubview:line];

        float s = 20 + STATE_HEIGHT;

        [navBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@(0));
            make.top.equalTo(@(0));
            make.height.equalTo(@(50 + STATE_HEIGHT));
        }];
        [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.right.equalTo(self.view.mas_right).offset(-50);
            make.bottom.equalTo(navBg.mas_bottom).offset(-6);
            make.height.equalTo(@50);
        }];
        
        [searchCancle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchView.mas_right);
            make.right.equalTo(navBg.mas_right).offset(-5);
            make.height.equalTo(searchView.mas_height);
            make.centerY.equalTo(searchView.mas_centerY);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@(0));
            make.top.equalTo(navBg.mas_bottom).offset(-0.5);
            make.height.equalTo(@0.5);
        }];
        _searchBar = searchView;
    }
    return _searchBar;
}

#pragma mark - button action

- (void)cancelAction:(id)sender{
    [self.searchMoreTableView.mj_footer resetNoMoreData];
    moreType = -1;
    _searchTableView.hidden = NO;
    
    @weakify(self)
    [viewModle fetureDataWithType:PDSearchAll KeyWords:viewModle.allSearchString IsMore:NO ResultBlock:^(BOOL flag) {
        @strongify(self)
        [self reloadData];
        NSLog(@"-");
    }];
    
    [self.searchBar setText:viewModle.allSearchString];
    self.searchTableView.alpha = 1;
    [UIView animateWithDuration:.25 animations:^{
        self.backButton.alpha = 0;
        
        [self.searchTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
        }];
        [self.searchMoreTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(SC_WIDTH));
        }];
        [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
        }];
        
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.searchMoreTableView.alpha = 0;
        [self reloadData];
        [self.view layoutIfNeeded];

    }];
}

- (void)moreAction:(UIButton *)sender{
    if(sender.tag - 10000 == PDTableMoreSingle){
        moreType = PDTableMoreSingle;
    }else if((sender.tag - 10000) == PDTableMoreAlbum){
        moreType = PDTableMoreAlbum;
    }
    PDSearchType searchType;
    if(moreType == PDTableMoreSingle){
        searchType = PDSearchSingle;
        [RBStat logEvent:PD_SEARCH_ALL_SINGLE_CLICK_MORE message:nil];
    }else if(moreType == PDTableMoreAlbum){
        searchType = PDSearchAlbum;
        [RBStat logEvent:PD_SEARCH_ALL_ALBUM_CLICK_MORE message:nil];
    }else {
        searchType = PDSearchAll;
    }
    [viewModle hasMore:searchType] ? [self.searchMoreTableView.mj_footer resetNoMoreData] : [self.searchMoreTableView.mj_footer endRefreshingWithNoMoreData];

    
    self.backButton.hidden = NO;
    self.backButton.alpha = 0;
    self.searchMoreTableView.alpha = 1;
    
    [self reloadData];
    
    [UIView animateWithDuration:.25 animations:^{
        self.backButton.alpha = 1;

        [self.searchTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(-SC_WIDTH/3));
        }];
        [self.searchMoreTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
        }];
        [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(40));
        }];
        
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.searchTableView.alpha = 0;
    }];
    
    
}

#pragma mark - get date


- (NSAttributedString *)getBgTitleText:(NSString *)title{
    if([title mStrLength] == 0)
        return nil;
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [paragraphStyle setLineSpacing:SX(5)];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,title.length)];
    [att addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x787878) range:NSMakeRange(0,title.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(15)] range:NSMakeRange(0,title.length)];

    return att;
}

- (NSArray *)getMoreData{
    switch (moreType) {
        case PDTableMoreSingle:
            return viewModle.singleArray;
        case PDTableMoreAlbum:
            return viewModle.albumArray;
        default:
            break;
    }
    return NULL;
}

- (PDFeatureModle *)categroryConvertFetureModle:(PDCategory *)categoty{
    PDFeatureModle *model = [PDFeatureModle new];
    model.mid = categoty.category_id;
    model.act = categoty.act;
    model.img = categoty.img;
    model.title = categoty.title;
    model.desc = categoty.desc;
    model.thumb = categoty.thumb;

    return model;
}
#pragma mark - helper

- (void)updatebgView{
    if([viewModle.singleArray mCount] == 0 && [viewModle.albumArray mCount] == 0){
        if([self.searchBar.text length] == 0){
            if (RBDataHandle.currentDevice.isPuddingPlus) {
                self.bgImageView.image = [UIImage imageNamed:@"ic_kong_mass"];
            }else if (RBDataHandle.currentDevice.isStorybox){
                self.bgImageView.image = [UIImage imageNamed:@"img_kong_mass_x"];
            }else{
                self.bgImageView.image = [UIImage imageNamed:@"ic_kong_mass_s"];
            }
            self.bgTitleLable.attributedText =  [self getBgTitleText:NSLocalizedString( @"g_large_audio_resource_you_can_find_what_you_want", nil)];
        }else{
            if (RBDataHandle.currentDevice.isPuddingPlus) {
                self.bgImageView.image = [UIImage imageNamed:@"ic_kong_haveno"];
            }else if (RBDataHandle.currentDevice.isStorybox){
                self.bgImageView.image = [UIImage imageNamed:@"img_kong_no_x"];
            }else{
                self.bgImageView.image = [UIImage imageNamed:@"ic_kong_haveno_s"];
            }
            self.bgTitleLable.attributedText = [self getBgTitleText:NSLocalizedString( @"pudding_not_understand_try_again", nil)];
        }
        return;
    }
    if(moreType > 0){
        if([self getMoreData].count == 0){
            NSString * keyWords = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

            if([keyWords length] == 0){
                if (RBDataHandle.currentDevice.isPuddingPlus) {
                    self.bgImageView.image = [UIImage imageNamed:@"ic_kong_mass"];
                }else if (RBDataHandle.currentDevice.isStorybox){
                    self.bgImageView.image = [UIImage imageNamed:@"img_kong_mass_x"];
                }else{
                    self.bgImageView.image = [UIImage imageNamed:@"ic_kong_mass_s"];
                }
                self.bgTitleLable.attributedText = [self getBgTitleText:NSLocalizedString( @"g_large_audio_resource_you_can_find_what_you_want", nil)];
            }else{
                if (RBDataHandle.currentDevice.isPuddingPlus) {
                    self.bgImageView.image = [UIImage imageNamed:@"ic_kong_haveno"];
                }else if (RBDataHandle.currentDevice.isStorybox){
                    self.bgImageView.image = [UIImage imageNamed:@"img_kong_no_x"];
                }else{
                    self.bgImageView.image = [UIImage imageNamed:@"ic_kong_haveno_s"];
                }
                self.bgTitleLable.attributedText = [self getBgTitleText:NSLocalizedString( @"pudding_not_understand_try_again", nil)];
            }
            return;
        }
    }
}

- (void)reloadData{
    [self.searchTableView reloadData];
    [self.searchMoreTableView reloadData];
    
    if([viewModle.singleArray mCount] == 0 && [viewModle.albumArray mCount] == 0){
        self.searchTableView.hidden = YES;
    }else{
        self.searchTableView.hidden = NO;
    }
    self.searchMoreTableView.hidden = [self getMoreData].count == 0;
    [self updatebgView];
}

- (BOOL)checkShowMoreButton:(NSInteger) session{
    if(session == PDTableMoreSingle){
        if([viewModle.singleArray count] >= 5)
            return YES;
        return NO;
    }else if(session == PDTableMoreAlbum){
        if([viewModle.albumArray count] >= 5)
            return YES;
        return NO;
    }
    return NO;
}

- (BOOL)checkShowHeaderButton:(NSInteger) session{
    if(session == PDTableMoreSingle){
        return [viewModle.singleArray count] > 0;

    }else if(session == PDTableMoreAlbum){
        return [viewModle.albumArray count] > 0;
    }
    return NO;
}


- (UIView *)createTableHeader:(NSInteger)section{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 36)];
    v.backgroundColor = mRGBToColor(0xf5f7f9);
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 3, 30, 30)];
    imageView.contentMode = UIViewContentModeCenter;
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 8, 8, 100, 20)];
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor = mRGBToColor(0x787878);
    if(section == PDTableMoreSingle){
        lable.text =  NSLocalizedString( @"related_song", nil);
        imageView.image = [UIImage imageNamed:@"ic_search_single"];
    }else if(section == PDTableMoreAlbum){
        lable.text = NSLocalizedString( @"related_album", nil);
        imageView.image = [UIImage imageNamed:@"ic_search_album"];
    }
    [v addSubview:imageView];
    [v addSubview:lable];
    return v;
    
}

- (UIView *)createFooderEmtry{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UIView *)createTableFooter:(NSInteger)section{
    UIButton * v = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 51)];
    v.backgroundColor = [UIColor clearColor];
    [v addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    v.tag = section + 10000;
    v.backgroundColor = mRGBToColor(0xeeeeee);

    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 41)];
    contentView.userInteractionEnabled = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    [v addSubview:contentView];
    
  
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectZero];
    lable.textColor = mRGBToColor(0x8ec31f);
    
    lable.font = [UIFont systemFontOfSize:15];
    if(section == PDTableMoreSingle)
        lable.text =  NSLocalizedString( @"more_music_", nil);
    else if(section == PDTableMoreAlbum)
        lable.text = NSLocalizedString( @"more_album_", nil);
    [v addSubview:lable];
    CGSize size = [lable sizeThatFits:CGSizeMake(100, 20)];
    lable.frame = CGRectMake((self.view.width - size.width)/2, (41 - size.height)/2, size.width, size.height);
    
    UIImageView  *titleIcon = [UIImageView new];
    titleIcon.contentMode = UIViewContentModeCenter;
    titleIcon.image = [UIImage imageNamed:@"ic_ic_search_more"];
    titleIcon.frame = CGRectMake(lable.right + 10, (41 - 9)/2, 9, 9);
    [contentView addSubview:titleIcon];
    return v;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.searchMoreTableView.mj_footer resetNoMoreData];
    NSString * keyWords = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    PDSearchType searchType;
    if(moreType == PDTableMoreSingle){
        searchType = PDSearchSingle;
        if([keyWords mStrLength] > 0){
            [RBStat logEvent:PD_SEARCH_SINGLE_SEARCH_TIMES message:nil];
        }
    }else if(moreType == PDTableMoreAlbum){
        searchType = PDSearchAlbum;
        if([keyWords mStrLength] > 0){
            [RBStat logEvent:PD_SEARCH_SINGLE_ALBUM_TIMES message:nil];
        }
    }else {
        searchType = PDSearchAll;
        if([keyWords mStrLength] > 0){
            [RBStat logEvent:PD_SEARCH_ALL_SEARCH_TIMES message:nil];
        }
    }
    @weakify(self)
    [viewModle fetureDataWithType:searchType KeyWords:keyWords IsMore:NO ResultBlock:^(BOOL flag) {
        @strongify(self)
        [self reloadData];
        NSLog(@"-");
    }];
    NSLog(@"");
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"");
    [searchBar resignFirstResponder];

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView.tag == PDTableContent && [self checkShowHeaderButton:section]){
        return 36;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(tableView.tag == PDTableContent ){
        if (![self checkShowHeaderButton:section])
            return 0.01;
        return [self checkShowMoreButton:section] ? 51 : 10;

    }
   
    return 10;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(tableView.tag == PDTableContent && [self checkShowHeaderButton:section]){
        return [self createTableHeader:section];
    
    }
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(tableView.tag == PDTableContent ){
        if([self checkShowMoreButton:section]){
            return [self createTableFooter:section];
        }
    }
  
    
    return [self createFooderEmtry];

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView.tag == PDTableMore ){
        if(moreType == PDTableMoreSingle){
            PDFeatureModle * amodle = [viewModle.singleArray objectAtIndex:indexPath.row];
            amodle.act = @"search";
            NSInteger resIndex = indexPath.row/20;
            amodle.resourcesKey = [viewModle.resourcesKeyArray objectAtIndexOrNil:resIndex];
            [self.navigationController pushFetureDetail:amodle SourceModle:nil];
            [RBStat logEvent:PD_SEARCH_MORE_SINGLE_CLICK message:nil];

        }else if(moreType == PDTableMoreAlbum){
            [self.navigationController pushFetureList:[self categroryConvertFetureModle:[viewModle.albumArray objectAtIndex:indexPath.row]]];
            [RBStat logEvent:PD_SEARCH_MORE_ALBUM_CLICK message:nil];
        }
    }else if(tableView.tag == PDTableContent){
        if(indexPath.section == PDTableMoreSingle){
            [RBStat logEvent:PD_SEARCH_ALL_SINGLE_CLICK message:nil];
            PDFeatureModle * amodle = [viewModle.singleArray objectAtIndex:indexPath.row];
            amodle.act = @"search";
            NSInteger resIndex = indexPath.row/20;
            amodle.resourcesKey = [viewModle.resourcesKeyArray objectAtIndexOrNil:resIndex];
            [self.navigationController pushFetureDetail:amodle SourceModle:nil];
        }else if(indexPath.section == PDTableMoreAlbum ){
            [self.navigationController pushFetureList:[self categroryConvertFetureModle:[viewModle.albumArray objectAtIndex:indexPath.row]]];
            [RBStat logEvent:PD_SEARCH_ALL_ALBUM_CLICK message:nil];

        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RBSearchAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RBSearchAlbumTableViewCell class])];
    if(cell == nil){
        cell = [[RBSearchAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([RBSearchAlbumTableViewCell class])];
    }
    
    if(tableView.tag == PDTableMore ){
        if(moreType == PDTableMoreSingle){
            PDFeatureModle * amodle = [viewModle.singleArray objectAtIndex:indexPath.row];
            [cell setFeatureModle:amodle];
        }else if(moreType == PDTableMoreAlbum){
            [cell setCategoty:[viewModle.albumArray objectAtIndex:indexPath.row]];
        }
    }else if(tableView.tag == PDTableContent){
        if(indexPath.section == PDTableMoreSingle){
            PDFeatureModle * amodle = [viewModle.singleArray objectAtIndex:indexPath.row];
            [cell setFeatureModle:amodle];
        }else if(indexPath.section == PDTableMoreAlbum ){
            [cell setCategoty:[viewModle.albumArray objectAtIndex:indexPath.row]];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView.tag == PDTableContent ){
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    
    if(tableView.tag == PDTableContent ){
        if(section == PDTableMoreSingle)
            count = MIN([viewModle.singleArray mCount], 5);
        else if(section == PDTableMoreAlbum)
            count = MIN([viewModle.albumArray mCount], 5);

    }else if(tableView.tag == PDTableMore){
        count = [self getMoreData].count;
        
    }
    
    return count;
}



@end
