//
//  PDExpressionView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDExpressionView.h"
#import "PDExpressionCell.h"
#import "PDTTSDataHandle.h"
#import "PDEmojiModle.h"

@interface PDExpressionView ()
@property (nonatomic,strong) NSDate *currDate;
@end

@implementation PDExpressionView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
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
      
//        menuView = [[PDTTSChildMenuView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, self.width, SX(50))];
//        @weakify(self);
//        [menuView setNormailStyle:TSMenuNormalCancle];
//        [menuView setSelectStyle:TTSMenuSelectSend];
//        [menuView setMenuActionBlock:^(TTSMenuActionStyle menuType) {
//            @strongify(self);
//            [self menuClickAction:menuType];
//        }];
//        [self addSubview:menuView];
        _currDate = [NSDate date];
    }
    return self;
}

#pragma mark - BtnAction

- (void)closeExpressAction:(id)sender{
    if(self.CloseViewBlock){
        self.CloseViewBlock();
    }

}


#pragma mark - PDTTSChildMenuView Button action

- (void)menuClickAction:(TTSMenuActionStyle)type{
    switch (type) {
        case TTSMenuActionStyleBack: {
            LogWarm(@"TTSMenuActionStyleBack");
            if(self.CloseViewBlock){
                self.CloseViewBlock();
            }
            break;
        }
        default:{
            break;
        }
         
    }
}




- (void)selectExprossionModleAt:(int) index InView:(UIView *)view{
    
    
    if(index >= 0&&![self isFrequentSendData] ){
        [[PDTTSDataHandle getInstanse] sendTTSEmojiData:index WithView:view];
    }
}
/**
 *  判断是不是恶意频繁点击 baxiang
 *
 *  @return YES 属于
 */
-(BOOL)isFrequentSendData{
    NSDate *intervalDate = [NSDate date];
    NSTimeInterval interval = [intervalDate timeIntervalSinceDate:_currDate];
    _currDate = intervalDate;
    if (interval<0.4) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"oversend", nil)];
        return YES;
    }
    return NO;
}
#pragma mark - TableView
#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SX(70);
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


@end
nsInTableView:(UITableView *)tableView{
    
    return 1;
}


@end
