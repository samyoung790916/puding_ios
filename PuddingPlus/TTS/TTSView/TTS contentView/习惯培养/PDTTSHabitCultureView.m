//
//  PDTTSHabitCultureView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSHabitCultureView.h"
#import "PDTTSHabitCultureCell.h"
#import "PDHabitCultureModle.h"
#import "NSObject+YYAdd.h"


@implementation PDTTSHabitCultureView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        _dataSource = [NSMutableArray new];
        
        
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
       
        [self reloadData];
        
        
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



- (void)reloadData{
    @weakify(self);
    RBDBParamHelper * helper = [[RBDBParamHelper alloc] initModleClass:[PDHabitCultureModle class]];
    helper.sort(@"id",DESC);
    [PDHabitCultureModle selectParam:helper :^(NSArray * array) {
        @strongify(self);
        self.markDataArray = [[NSMutableArray alloc]init];
        for(int i = 0 ; i < array.count; i++){
            PDHabitCultureModle * modle = [array objectAtIndex:i];
            modle.isMark = YES;
            [self.markDataArray mAddObject:modle];
        }
        [self reloadTableView];
        if (array.count>0) {
            LogError(@"隐藏");
            nodataView.hidden = YES;
        }
        [RBNetworkHandle getUserCustomDataWith:^(id res) {
            if(res && [[res objectForKey:@"result"] intValue] == 0){
                NSArray * array = [[res mObjectForKey:@"data"] mObjectForKey:@"list"];
                if(array.count > 0){
                    NSMutableArray * netData = [NSMutableArray new];
                    for(NSDictionary * dic in array){
                        [netData addObject:[PDHabitCultureModle modelWithDictionary:dic]];
                    }
                    self.netDataArray = [netData copy];
                    [self reloadTableView];
                    
                }
            }
        }];
    }];
}




- (void)reloadTableView{


    NSMutableArray * data = [[NSMutableArray alloc] init];
    
    [data addObjectsFromArray:self.markDataArray];
    
    nodataView.hidden = self.netDataArray.count > 0;

  
    for(int i= 0 ; i < [self.netDataArray count] ; i++){
        PDHabitCultureModle * modle = [self.netDataArray objectAtIndex:i];
        BOOL isMark = NO;
        for(int j= 0 ; j < [self.markDataArray count] ; j++){
            PDHabitCultureModle * mmodle = [self.markDataArray objectAtIndex:j];
            if([modle.hid intValue] ==[ mmodle.hid intValue]){
                isMark = YES;
                break;
            }
        }
        if(!isMark){
            [data addObject:modle];
        }
    }
    
    self.dataSource = data;

    [_tableView reloadData];
}

- (void)changeHistory{
    RBDBParamHelper * helper = [[RBDBParamHelper alloc] initModleClass:[PDHabitCultureModle class]];
    helper.sort(@"id",DESC);
    [PDHabitCultureModle selectParam:helper :^(NSArray * array) {
        self.markDataArray = [[NSMutableArray alloc]init];
        for(int i = 0 ; i < array.count; i++){
            PDHabitCultureModle * modle = [array objectAtIndex:i];
            modle.isMark = YES;
            [self.markDataArray mAddObject:modle];
        }
        [self reloadTableView];
    }];
    
   
}

- (void)saveHabitData:(PDHabitCultureModle *)modle{
    if(!modle.isMark){
        [modle save];
    }
    [self changeHistory];
}


- (void)deleteHabitData:(PDHabitCultureModle *)modle{
    if(modle.isMark){
        [modle remove];
    }
    [self changeHistory];
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
    PDHabitCultureModle * modle = [_dataSource objectAtIndex:indexPath.row];
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
    PDHabitCultureModle * modle = [_dataSource mObjectAtIndex:indexPath.row];
    if(modle ){
        [[PDTTSDataHandle getInstanse] shouldSendTTS:modle.content];
    }
}


#pragma mark  UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    PDTTSHabitCultureCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[PDTTSHabitCultureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        @weakify(self);
        [cell setMarkActionBlock:^(PDHabitCultureModle * m, BOOL isMark) {
            @strongify(self);
            if(isMark){
                [self saveHabitData:m];
            }else{
                [self deleteHabitData:m];
            }
        }];
    }
    PDHabitCultureModle * modle = [_dataSource objectAtIndex:indexPath.row];
    [cell setDataSource:modle];

    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (void)dealloc{
    LogError(@"PDTTSHabitCultureView");
}
@end
