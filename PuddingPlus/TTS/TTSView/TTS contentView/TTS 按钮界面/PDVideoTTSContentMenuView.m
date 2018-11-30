//
//  PDVideoTTSContentMenuView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVideoTTSContentMenuView.h"
#import "PDExpressionView.h"
#import "RBVideoMessageView.h"
#import "PDVoiceChangeView.h"
#import "PDVideoTTSContentListView.h"
#import "PDVideoTTSContentView.h"
#import "PDTTSPlayView.h"
#import "PDTTSHabitCultureView.h"


@interface PDVideoTTSContentMenuView()
/** 视图数组 */
@property (nonatomic, strong) NSMutableArray * viewArr;

@end

@implementation PDVideoTTSContentMenuView{
    float width ;
    float top ;
    float height ;
    PDViewContentViewType contentType;
    UIView * currentView;
}



#pragma mark - action: 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        width = SX(120);
        top =   SX(9);
        height =  SX(106);
    }
    return self;
}


#pragma mark - action: 创建功能列表按钮
- (UIView *)loadMenuView:(NSString *) title NormalImageName:(NSString *) imageNamed SelectImageName:(NSString *) simageNamed {
    UIView * control = [[UIControl alloc] init];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake((width - SX(52))/2, SX(30), SX(52), SX(52))];
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:simageNamed] forState:UIControlStateHighlighted];
    [control addSubview:btn];
    
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.bottom + SX(9), width, SX(14))];
    lable.textColor = mRGBToColor(0x666666);
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:SX(13)];
    lable.text = title;
    [control addSubview:lable];
    
    return control;
}


#pragma mark - action: 根据传递的技能类型来显示视图
-(void)changeContentWithSkill:(PDViewContentViewType)type{
    [self changeViewWithIndex:type];
}

#pragma mark - 创建 -> 创建视图数组
-(NSMutableArray *)viewArr{
    if (!_viewArr) {
        NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
        _viewArr = arr;
    }
    return _viewArr;
}
#pragma mark - action: 切换视图
- (void)changeViewWithIndex:(NSInteger)index{
    contentType = index;
    PDVideoTTSPublicView * view = nil;
    if(currentView){
        [currentView removeFromSuperview];
    }
    
    //习惯培养
    if(index == 0){
        if (self.viewArr.count>0) {
            BOOL contain = NO;
            for (NSInteger i = 0; i<self.viewArr.count; i++) {
                UIView * vi = self.viewArr[i];
                if (vi.tag == 10) {
                    view = (PDTTSHabitCultureView * )vi;
                    contain = YES;
                    break;
                }
                if (i == self.viewArr.count -1&&contain == NO) {
                    view = [[PDTTSHabitCultureView alloc] initWithFrame:self.bounds];
                    view.tag = 10;
                    [self.viewArr addObject:view];
                }
            }
        }else{
            view = [[PDTTSHabitCultureView alloc] initWithFrame:self.bounds];
            view.tag = 10;
            [self.viewArr addObject:view];
        }
        
        //        view = [[PDTTSHabitCultureView alloc] initWithFrame:self.bounds];
        
        if([PDTTSDataHandle getInstanse].isVideoViewModle){
            [RBStat logEvent:PD_Video_Send_Habit message:nil];
        }else{
            [RBStat logEvent:PD_Send_Habit message:nil];
        }
        
    } else if(index == 1){
        //布丁表情
        //        view = [[PDExpressionView alloc] initWithFrame:self.bounds];
        
        if (self.viewArr.count > 0) {
            BOOL contain = NO;
            for (NSInteger i = 0; i<self.viewArr.count; i++) {
                UIView * vi = self.viewArr[i];
                if (vi.tag == 11) {
                    view = (PDExpressionView * )vi;
                    contain = YES;
                    break;
                }
                if (i == self.viewArr.count -1&&contain == NO) {
                    view = [[PDExpressionView alloc] initWithFrame:self.bounds];
                    view.tag = 11;
                    [self.viewArr addObject:view];
                }
            }
        }else{
            view = [[PDExpressionView alloc] initWithFrame:self.bounds];
            view.tag = 11;
            [self.viewArr addObject:view];
        }
        
        
        
    }else if(index == 2){
        //搞笑逗趣
        //        view = [[RBVideoMessageView alloc] initWithFrame:self.bounds];
        
        if (self.viewArr.count > 0) {
            BOOL contain = NO;
            for (NSInteger i = 0; i<self.viewArr.count; i++) {
                UIView * vi = self.viewArr[i];
                if (vi.tag == 12) {
                    view = (RBVideoMessageView * )vi;
                    contain = YES;
                    break;
                }
                if (i == self.viewArr.count -1&&contain == NO) {
                    view = [[RBVideoMessageView alloc] initWithFrame:self.bounds];
                    view.tag = 12;
                    [self.viewArr addObject:view];
                }
            }
        }else{
            view = [[RBVideoMessageView alloc] initWithFrame:self.bounds];
            view.tag = 12;
            [self.viewArr addObject:view];
        }
        
        if([PDTTSDataHandle getInstanse].isVideoViewModle){
            [RBStat logEvent:PD_Video_Fun message:nil];
        }else{
            [RBStat logEvent:PD_Send_Fun message:nil];
        }
    }else if(index == 3){
        //趣味变声
        
        
        if([PDTTSDataHandle getInstanse].isVideoViewModle){
            if (self.viewArr.count>0) {
                BOOL contain = NO;
                for (NSInteger i = 0; i<self.viewArr.count; i++) {
                    UIView * vi = self.viewArr[i];
                    if (vi.tag == 14) {
                        view = (PDTTSPlayView * )vi;
                        contain = YES;
                        break;
                    }
                    if (i == self.viewArr.count -1&&contain == NO) {
                        view = [[PDTTSPlayView alloc] initWithFrame:self.bounds];
                        view.tag = 14;
                        [self.viewArr addObject:view];
                    }
                }
            }else{
                view = [[PDTTSPlayView alloc] initWithFrame:self.bounds];
                view.tag = 14;
                [self.viewArr addObject:view];
            }
            
        }else{
            if (self.viewArr.count>0) {
                BOOL contain = NO;
                for (NSInteger i = 0; i<self.viewArr.count; i++) {
                    UIView * vi = self.viewArr[i];
                    if (vi.tag == 13) {
                        view = (PDVideoTTSContentListView * )vi;
                        PDVideoTTSContentListView *listView = (PDVideoTTSContentListView *)view;
                        [listView reloadData];
                        contain = YES;
                        break;
                    }
                    if (i == self.viewArr.count -1&&contain == NO) {
                        view = [[PDVideoTTSContentListView alloc] initWithFrame:self.bounds];
                        PDVideoTTSContentListView *listView = (PDVideoTTSContentListView *)view;
                        [listView reloadData];
                        view.tag = 13;
                        [self.viewArr addObject:view];
                    }
                }
            }else{
                view = [[PDVideoTTSContentListView alloc] initWithFrame:self.bounds];
                PDVideoTTSContentListView *listView = (PDVideoTTSContentListView *)view;
                [listView reloadData];
                view.tag = 13;
                [self.viewArr addObject:view];
            }
        }
        
    }else if (index == 4){
        
        if([PDTTSDataHandle getInstanse].isVideoViewModle){
            if (self.viewArr.count>0) {
                BOOL contain = NO;
                for (NSInteger i = 0; i<self.viewArr.count; i++) {
                    UIView * vi = self.viewArr[i];
                    if (vi.tag == 13) {
                        view = (PDVideoTTSContentListView * )vi;
                        PDVideoTTSContentListView *listView = (PDVideoTTSContentListView *)view;
                        [listView reloadData];
                        contain = YES;
                        break;
                    }
                    if (i == self.viewArr.count -1&&contain == NO) {
                        view = [[PDVideoTTSContentListView alloc] initWithFrame:self.bounds];
                        PDVideoTTSContentListView *listView = (PDVideoTTSContentListView *)view;
                        [listView reloadData];
                        view.tag = 13;
                        [self.viewArr addObject:view];
                    }
                }
            }else{
                view = [[PDVideoTTSContentListView alloc] initWithFrame:self.bounds];
                PDVideoTTSContentListView *listView = (PDVideoTTSContentListView *)view;
                [listView reloadData];
                view.tag = 13;
                [self.viewArr addObject:view];
            }
        }else{
            if (self.viewArr.count>0) {
                BOOL contain = NO;
                for (NSInteger i = 0; i<self.viewArr.count; i++) {
                    UIView * vi = self.viewArr[i];
                    if (vi.tag == 14) {
                        view = (PDTTSPlayView * )vi;
                        contain = YES;
                        break;
                    }
                    if (i == self.viewArr.count -1&&contain == NO) {
                        view = [[PDTTSPlayView alloc] initWithFrame:self.bounds];
                        view.tag = 14;
                        [self.viewArr addObject:view];
                    }
                }
            }else{
                view = [[PDTTSPlayView alloc] initWithFrame:self.bounds];
                view.tag = 14;
                [self.viewArr addObject:view];
            }
        }
        
    }
    
    //    view.top= self.bottom;
    [self addSubview:view];
    //    [UIView animateWithDuration:.3 animations:^{
    //        view.top= 0;
    //    }];
    currentView = view;
    __weak PDVideoTTSPublicView * weakView = view;
    @weakify(self);
    [view setCloseViewBlock:^{
        @strongify(self);
        //        [UIView animateWithDuration:.4 animations:^{
        weakView.top= self.bottom;
        //        } completion:^(BOOL finished) {
        [weakView removeFromSuperview];
        //        }];
        
    }];
    [[PDTTSDataHandle getInstanse] showContentViewType:index IsShow:YES];
}


#pragma mark - action: 按钮点击 -> 选择功能(习惯培养，布丁表情...)
- (void)buttonAction:(UIButton *)sender{
    NSUInteger index = sender.superview.tag - [@"btn" hash];
    [self changeViewWithIndex:index];
//    contentType = index;
//    PDVideoTTSPublicView * view = nil;
//    if(currentView){
//        [currentView removeFromSuperview];
//    }
//    
//    //习惯培养
//    if(index == 0){
//        view = [[PDTTSHabitCultureView alloc] initWithFrame:self.bounds];
//        if([PDTTSDataHandle getInstanse].isVideoViewModle){
//            [RBStat logEvent:PD_Video_Send_Habit message:nil];
//        }else{
//            [RBStat logEvent:PD_Send_Habit message:nil];
//        }
//        
//    } else if(index == 1){
//        //布丁表情
//        view = [[PDExpressionView alloc] initWithFrame:self.bounds];
//    }else if(index == 2){
//        //搞笑逗趣
//        view = [[RBVideoMessageView alloc] initWithFrame:self.bounds];
//        if([PDTTSDataHandle getInstanse].isVideoViewModle){
//            [RBStat logEvent:PD_Video_Fun message:nil];
//        }else{
//            [RBStat logEvent:PD_Send_Fun message:nil];
//        }
//    }else if(index == 3){
//        //趣味变声
//        view = [[PDVoiceChangeView alloc] initWithFrame:self.bounds];
//    }
//    
//    view.top= self.bottom;
//    [self addSubview:view];
//    [UIView animateWithDuration:.3 animations:^{
//        view.top= 0;
//    }];
//    currentView = view;
//    __weak PDVideoTTSPublicView * weakView = view;
//    @weakify(self);
//    [view setCloseViewBlock:^{
//        @strongify(self);
//        [UIView animateWithDuration:.4 animations:^{
//            weakView.top= self.bottom;
//        } completion:^(BOOL finished) {
//            [weakView removeFromSuperview];
//        }];
//        
//    }];
//    [[PDTTSDataHandle getInstanse] showContentViewType:index IsShow:YES];
 
    
}

/**
 *  @author 智奎宇, 16-02-27 14:02:47
 *
 *  移除子View
 */
- (void)removeChileView{
    [currentView removeFromSuperview];
    currentView= nil;

    [[PDTTSDataHandle getInstanse] showContentViewType:contentType IsShow:NO];
    contentType = NSIntegerMax;

}


- (void)dealloc{

    currentView = nil;
    LogError(@"PDVideoTTSContentMenuView");
}
@end
