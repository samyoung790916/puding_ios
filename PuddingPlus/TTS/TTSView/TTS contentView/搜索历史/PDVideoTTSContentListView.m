//
//  PDVideoTTSContentListView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVideoTTSContentListView.h"
#import "PDTTSHistoryModle.h"
#import "PDTTSSearchHistoryCell.h"
#import "PDTTSChildMenuView.h"
#import "PDTTSDataHandle.h"

@implementation PDVideoTTSContentListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        selectRowIndex = -1;

        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height ) style:UITableViewStyleGrouped];
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
        
 
        
        nodataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:nodataView];
        
        nodataView.center = _tableView.center;
        
        
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((nodataView.width - 92)/2.f, 0, 92, 61)];
        imageView.image = [UIImage imageNamed:@"img_history_empty"];
        [nodataView addSubview:imageView];
        
        UILabel * noDataLable = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.height + 10, nodataView.width, 20)];
        noDataLable.text = NSLocalizedString( @"historical_data_is_empty", nil);
        noDataLable.font = [UIFont systemFontOfSize:14];
        noDataLable.textColor = [UIColor lightGrayColor];
        noDataLable.textAlignment = NSTextAlignmentCenter;
        [nodataView addSubview:noDataLable];
        
        

    }
    return self;
}

/**
 *  @author 智奎宇, 16-02-27 14:02:47
 *
 *  刷新页面
 */
- (void)reloadData{
    
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @strongify(self);
        
        RBDBParamHelper * helper = [[RBDBParamHelper alloc] initModleClass:[PDTTSHistoryModle class]] ;
        helper.count(10);
        helper.sort(@"search_time",DESC);
        
        [PDTTSHistoryModle selectParam:helper :^(NSArray * result) {
            self.dataArray = [[NSMutableArray alloc]initWithArray:result];
            
            while (self.dataArray.count > 500) {
                PDTTSHistoryModle * modlev = [self.dataArray lastObject];
                [modlev remove];
                [self.dataArray removeLastObject];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadTableView];
            });
        }];
        
        
    });
    [menuView setIsSelected:NO Animail:NO];

    
}




- (void)reloadTableView{
    
    nodataView.hidden = self.dataArray.count > 0;

    [_tableView reloadData];
    if(selectRowIndex >= 0 && selectRowIndex < self.dataArray.count){
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectRowIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}



- (void)deleteHistoryWithModle:(PDTTSHistoryModle *)modle{
    
    [modle remove];
    
    NSInteger index = [_dataArray indexOfObject:modle];
    if(index < _dataArray.count){
        [_dataArray removeObjectAtIndex:index];
    }
    
    [self reloadTableView];
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
    PDTTSHistoryModle * modle = [self.dataArray objectAtIndex:indexPath.row];
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
    PDTTSHistoryModle * modle = [_dataArray mObjectAtIndex:indexPath.row];
    if(modle ){
        [[PDTTSDataHandle getInstanse] shouldSendTTS:modle.tts_content];
    }
}

#pragma mark  UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    PDTTSSearchHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[PDTTSSearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        @weakify(self);
        [cell setDeleteActionBlock:^(PDTTSHistoryModle * deleteModle) {
            @strongify(self);
            [self deleteHistoryWithModle:deleteModle];
        }];
    }
    PDTTSHistoryModle * modle = [self.dataArray objectAtIndex:indexPath.row];
    [cell setDataSource:modle];

    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

@end
