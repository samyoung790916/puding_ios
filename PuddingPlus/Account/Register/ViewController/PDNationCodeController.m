//
//  PDNationCodeController.m
//  Pudding
//
//  Created by baxiang on 2017/1/6.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDNationCodeController.h"
#import "NSArray+YYAdd.h"

@interface PDNationCodeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong) NSArray *nationArray;
@property(nonatomic,strong) NSArray *indexArray;
@property(nonatomic,strong) NSMutableArray *searchArray;
@property(nonatomic,weak) UITableView *nationTableView;
@property(nonatomic,weak) UITableView *searchTableView;
@property (nonatomic, weak) UISearchBar *nationSearchBar;
@end

@implementation PDNationCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString( @"area", nil);
    self.nationArray  = [NSArray modelArrayWithClass:[PDNationCode class] json:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"areacode" withExtension:@"json"]]];
    self.indexArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"M",@"L",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z"];
    

    UISearchBar *nationSearchBar =  [[UISearchBar alloc] init];
    [self.view addSubview:nationSearchBar];
     [nationSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(@(NAV_HEIGHT));
        make.height.mas_equalTo(50);
    }];
    nationSearchBar.delegate = self;
    nationSearchBar.placeholder = NSLocalizedString( @"please_enter_the_name_of_the_area_or_the_international_telephone_area_code", nil);
    nationSearchBar.searchBarStyle = UISearchBarStyleDefault;
    self.nationSearchBar = nationSearchBar;
    
    UITableView *nationTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:nationTableView];
    self.nationTableView = nationTableView;
    [nationTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nationSearchBar.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    nationTableView.delegate = self;
    nationTableView.dataSource = self;
    [nationTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
   
    UITableView *searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:searchTableView];
    self.searchTableView = searchTableView;
    [searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nationSearchBar.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    [searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    searchTableView.tableFooterView = [UIView new];
    [self.searchTableView setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.nationTableView.contentInset = UIEdgeInsetsMake(self.searchTableView.contentInset.top, 0, keyboardBounds.size.height, 0);

    self.searchTableView.contentInset = UIEdgeInsetsMake(self.searchTableView.contentInset.top, 0, keyboardBounds.size.height, 0);
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    self.nationTableView.contentInset = UIEdgeInsetsMake(self.searchTableView.contentInset.top, 0, 0, 0);
    self.searchTableView.contentInset = UIEdgeInsetsMake(self.searchTableView.contentInset.top, 0, 0, 0);
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray new];
    }
    
    return _searchArray;
}
- (void)addSearchBar {
    UIView *searchContainView =[UIView new];
    [self.view addSubview:searchContainView];
    [searchContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);;
        make.height.offset(40);
        make.top.mas_equalTo(64);
    }];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = NSLocalizedString( @"please_enter_city_name", nil);
    [searchContainView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
    }];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}
// searchBar文本改变时即调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length > 0) {
        [self.searchTableView setHidden:NO];
        [self searchNationCodeHandle:searchText];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length > 0) {
        [self.searchTableView setHidden:NO];
        [self searchNationCodeHandle:searchBar.text];
    }
}
-(void)searchNationCodeHandle:(NSString*)searchText{
    NSArray *result = [PDNationcontent searchWithSQL:[NSString stringWithFormat:@"SELECT * FROM PDNationCode WHERE name LIKE '%%%@%%' or code LIKE '%@%%'",searchText,searchText]];
    [_searchArray removeAllObjects];
    [self.searchArray addObjectsFromArray:result];
    [self.searchTableView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.nationSearchBar resignFirstResponder];
    self.nationSearchBar.showsCancelButton = NO;
    self.nationSearchBar.text = nil;
    [self.searchTableView setHidden:YES];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.nationTableView) {
        return self.nationArray.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.nationTableView) {
        PDNationCode *codeData = [self.nationArray objectOrNilAtIndex:section];
        return codeData.content.count;
    }
  return self.searchArray.count;
}
// 每个分区的页眉
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.nationTableView) {
        PDNationCode *codeData = [self.nationArray objectOrNilAtIndex:section];
        return codeData.index;;
    }
    return nil;
}
// 索引目录
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.nationTableView) {
        return self.indexArray;
    }
    return nil;
  
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return index;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.nationTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        PDNationCode *codeData = [self.nationArray objectOrNilAtIndex:indexPath.section];
        PDNationcontent *contentData = [codeData.content objectOrNilAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",contentData.name,contentData.show];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    PDNationcontent *contentData = [self.searchArray objectOrNilAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",contentData.name,contentData.show];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PDNationcontent *contentData;
    if (tableView == self.nationTableView) {
        PDNationCode *codeData = [self.nationArray objectOrNilAtIndex:indexPath.section];
        contentData = [codeData.content objectOrNilAtIndex:indexPath.row];
    }
    if (tableView== self.searchTableView) {
     contentData = [self.searchArray objectOrNilAtIndex:indexPath.row];
    }
    if (self.selectNationBlock) {
        self.selectNationBlock(contentData);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
