//
//  RBInputExpressionView.m
//  RBInputView
//
//  Created by kieran on 2017/2/9.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBInputExpressionView.h"
#import "PDExpressionCell.h"
#import "PDEmojiModle.h"

@implementation RBInputExpressionView
@synthesize SendExpressionBlock = _SendExpressionBlock;


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = mRGBToColor(0xf7f7f7);
        
        _expressArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"]];
                
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor] ;
        _tableView.backgroundView = nil;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundView = [[UIView alloc] init];
        _tableView.contentInset = UIEdgeInsetsMake(SX(9), 0, 0, 0);
        [self addSubview:_tableView];
    }
    return self;
}

- (void)selectExprossionModleAt:(int) index InView:(UIView *)view{
    
    
    if(index >= 0&&![self isFrequentSendData] ){
        if(self.SendExpressionBlock){
            __weak typeof(self) weakSelf = self;
            self.SendExpressionBlock(index,weakSelf);
        }
    }
}
NSDate * _currDate;
/**
 *  判断是不是恶意频繁点击 baxiang
 *
 *  @return YES 属于
 */
-(BOOL)isFrequentSendData{
    NSDate *intervalDate = [NSDate date];
    
    
    NSTimeInterval interval = [intervalDate timeIntervalSinceDate:_currDate];
    if (interval<0.4) {
        _currDate = intervalDate;
        return YES;
    }
    return NO;
}
#pragma mark - TableView
#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SX(90);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark  UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ceilf((float)_expressArray.count/4.0f);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier" ;
    
    PDExpressionCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        
        cell = [[PDExpressionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier WithBounds:CGSizeMake(tableView.width, SX(93.f))];
    }
    cell.indexPath = indexPath;
    
    [cell setExpressArray:[_expressArray subarrayWithRange:NSMakeRange(indexPath.row * 4, MIN(4, _expressArray.count - indexPath.row * 4))]] ;
    
    @weakify(self);
    [cell setExpressionBlock:^(UIButton * item  ,NSObject * obj,int index) {
        @strongify(self);
        [self selectExprossionModleAt:index InView:item];
    }];
    
    return cell;
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


#pragma mark - RBInputInterface
///更新内部数据
- (void)updateData{

}

@end
