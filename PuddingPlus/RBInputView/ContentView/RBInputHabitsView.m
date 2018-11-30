//
//  RBInputHabitsView.m
//  RBInputView
//
//  Created by kieran on 2017/2/8.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBInputHabitsView.h"
#import "PDHabitCultureModle.h"
#import "PDTTSHabitCultureCell.h"
#import "RBInputCotentViewModle.h"
#import "NSObject+RBExtension.h"

@implementation RBInputHabitsView
@synthesize SelectTextBlock = _SelectTextBlock;

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = mRGBToColor(0xf7f7f7);
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height ) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor clearColor] ;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundView = [[UIView alloc] init];
        _tableView.contentInset = UIEdgeInsetsMake(SX(9), 0, 0, 0);
        [self addSubview:_tableView];
        if([_tableView respondsToSelector:@selector(setLayoutMargins:)])
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        [[self currViewController] setNoNetTipString:NSLocalizedString( @"let_the_pudding_talk_to_you_about_the_baby", nil)];
        [[self currViewController] setTipString:NSLocalizedString( @"let_the_pudding_talk_to_you_about_the_baby", nil)];
        self.currViewController.nd_bg_disableCover = YES;
        
        viewModle = [RBInputHabitsViewModle new];
        
    }
    return self;
}



- (void)reloadData{
    [_tableView reloadData];
    if(viewModle.dataSource.count > 0){
        [self.currViewController hiddenNoDataView];
    }else{
        [self.currViewController showNoDataView:self];
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
    PDHabitCultureModle * modle = [viewModle.dataSource objectAtIndex:indexPath.row];
    return [PDTTSHabitCultureCell cellHeight:modle.content];
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
    PDHabitCultureModle * modle = [viewModle.dataSource objectAtIndex:indexPath.row];
    if(modle && self.SelectTextBlock){
        __weak typeof(self) weakSelf = self;
        self.SelectTextBlock(modle.content,weakSelf);
    }
}


#pragma mark  UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return viewModle.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    PDTTSHabitCultureCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[PDTTSHabitCultureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        @weakify(self)
        [cell setMarkActionBlock:^(PDHabitCultureModle * m, BOOL isMark) {
            @strongify(self)
            if(isMark){
                [viewModle saveHabitsModle:m Block:^{
                    [self reloadData];
                }];
            }else{
                [viewModle removeHabitsModle:m Block:^{
                    [self reloadData];
                }];
            }
        }];
    }
    PDHabitCultureModle * modle = [viewModle.dataSource objectAtIndex:indexPath.row];
    [cell setDataSource:modle];
    
    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

#pragma mark -  RBInputInterface

///更新内部数据
- (void)updateData{
    @weakify(self)
    [viewModle loadhabits:^{
        @strongify(self)
        [self reloadData];
    }];
}


@end
