//
//  RBInputHistoryView.m
//  RBInputView
//
//  Created by kieran on 2017/2/7.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBInputHistoryView.h"
#import "RBInputCotentViewModle.h"
#import "PDTTSSearchHistoryCell.h"
#import "PDTTSHistoryModle.h"
#import "NSObject+RBExtension.h"

@implementation RBInputHistoryView{
    NSInteger        selectRowIndex;
    UITableView     * _tableView;
    RBInputHistoryViewModle * viewModle;

}
@synthesize SelectTextBlock = _SelectTextBlock;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        selectRowIndex = -1;
        self.backgroundColor = mRGBToColor(0xf7f7f7);
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height ) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor clearColor] ;
        _tableView.backgroundView = nil;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundView = [[UIView alloc] init];
        [self addSubview:_tableView];
        
        
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        if([_tableView respondsToSelector:@selector(setLayoutMargins:)])
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        
        self.currViewController.nd_bg_disableCover = YES;
        
        viewModle = [[RBInputHistoryViewModle alloc] init];
    }
    return self;
}


#pragma mark - handle method

- (void)deleteHistory:(PDTTSHistoryModle *)modle{
    [viewModle remove:modle Block:^(BOOL flag) {
        if(flag){
            [self reloadData];
        }
    }];

}

- (void)reloadData{
    if(viewModle.dataArrays.count == 0){
        [self.viewController showNoDataView:self];
    }else{
        [self.viewController hiddenNoDataView];
    }
    [_tableView reloadData];
    
    if(selectRowIndex >= 0 && selectRowIndex < viewModle.dataArrays.count){
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectRowIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }

}




#pragma mark - TableView
#pragma mark  UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PDTTSHistoryModle * modle = [viewModle.dataArrays objectAtIndex:indexPath.row];
    return [PDTTSSearchHistoryCell cellHeight:modle.tts_content];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PDTTSHistoryModle * modle = [viewModle.dataArrays objectAtIndex:indexPath.row];
    if(modle ){
        if(self.SelectTextBlock){
            __weak typeof(self) weakSelf = self;
            self.SelectTextBlock(modle.tts_content,weakSelf);
        }
    }
}

#pragma mark  UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [viewModle.dataArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    PDTTSSearchHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[PDTTSSearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        @weakify(self)
        [cell setDeleteActionBlock:^(PDTTSHistoryModle * deleteModle) {
            @strongify(self);
            [self deleteHistory:deleteModle];
        }];
    }
    PDTTSHistoryModle * modle = [viewModle.dataArrays objectAtIndex:indexPath.row];
    [cell setDataSource:modle];
    
    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

#pragma mark - RBInputInterface
///更新内部数据
- (void)updateData{
    @weakify(self)
    [viewModle update:^(BOOL flag) {
        @strongify(self)
        [self reloadData];
    }];

}


@end
