//
//  ZYChosseManagerAlter.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/9/4.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//


#import "ZYChosseManagerAlter.h"
#import "NSBundle+RBAlter.h"
#import "RBAPublic.h"

@implementation ZYChosseManagerAlter

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.title = @"관리자를 선택하십시오";
        
        self.bottomItems = @[@"취소" ,@"완료"];
        [self addScrollView];
    }
    return self;
}

// 增加滚动区域和page
- (void)addScrollView{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.backgroundColor = [UIColor clearColor];
    [self addSubview:scroll];
    
    UIPageControl *pageCtr = [[UIPageControl alloc] init];
    scroll.backgroundColor =[UIColor whiteColor];
    scroll.frame = CGRectMake(20, 45, CGRectGetWidth(self.frame) - 40, 140);
    pageCtr.currentPageIndicatorTintColor = [UIColor colorWithRed:97/255.0 green:212/255.0 blue:255/255.0 alpha:1];
    pageCtr.pageIndicatorTintColor = [UIColor colorWithRed:139/255.0 green:157/255.0 blue:178/255.0 alpha:1];
    
    pageCtr.frame = CGRectMake(0 ,159, CGRectGetWidth(self.frame), 20);
    [self addSubview:pageCtr];
    _pageCtrl.backgroundColor = [UIColor clearColor] ;
    
    _pageCtrl.currentPage = 0;
    _pageCtrl = pageCtr;
    
    _myScroll = scroll;
    _myScroll.scrollEnabled = YES;
    _myScroll.userInteractionEnabled = YES;
    _myScroll.autoresizesSubviews = NO;
    _myScroll.pagingEnabled = YES;
    _myScroll.showsHorizontalScrollIndicator = NO;
    _myScroll.showsVerticalScrollIndicator = NO;
    _myScroll.delegate = self;
    _myScroll.backgroundColor = [UIColor clearColor];
    
}

//{@"imgUrl":@"http://www.baidu.com",@"title":@"biaoti"}
- (void)addItems:(NSArray *)items DefaultImage:(UIImage *)image{
    
    // 等待开启
    NSInteger count = items.count;
    
    CGFloat mwidth = _myScroll.frame.size.width/2;
    CGFloat mheight = 115;
    if (count%2!=0) {
        _myScroll.contentSize = CGSizeMake(mwidth*(count+1), _myScroll.frame.size.height);
        _pageCtrl.numberOfPages = (count+1)/2;
    }else{
        _myScroll.contentSize = CGSizeMake(mwidth*count, _myScroll.frame.size.height);
        _pageCtrl.numberOfPages = count/2;
    }
    
    for (int i =0; i < count; i++) {
        
        NSDictionary * dict = [items objectAtIndex:i];
        CGRect frame ;
        
        if (count%2!=0&&i ==count-1) {
            frame = CGRectMake((i+0.5)*mwidth, 0, mwidth, mheight);
        }else{
            frame = CGRectMake(i*mwidth, 0, mwidth, mheight);
        }
        //  设置尺寸
        ZDmanagerChoice *chice1 = [[ZDmanagerChoice alloc] initWithFrame:frame];
        chice1.backgroundColor = [UIColor clearColor];
        [chice1 addTarget:self action:@selector(setManager:) forControlEvents:UIControlEventTouchUpInside];
        [chice1 setImageURL:[dict objectForKey:@"imgUrl"] DefaultImage:image Title:[dict objectForKey:@"title"]];
        chice1.index  = i;
        if(i == 0){
            [chice1 getChosen];
            self.selectIndex = 0;
        }
        [_myScroll addSubview:chice1];
        
    }
    
}

- (void)setManager:(ZDmanagerChoice *)manager{
    manager.selected = !manager.selected;
    if (manager.selected) {
        [manager getChosen];
        self.selectIndex = manager.index;
        
        NSArray *managers = [_myScroll  subviews];
        //使其他子视图处于不可选状态
        for ( UIView *v  in managers) {
            if ([v isKindOfClass:[manager class]]) {
                ZDmanagerChoice *choice =(ZDmanagerChoice*)v;
                if (choice != manager) {
                    [choice disChosen];
                    manager.selected =NO;
                }
            }
        }
    }else{
        [manager disChosen];
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int width = scrollView.frame.size.width;
    int left = scrollView.contentOffset.x;
    int pageNum = (left + width * 0.5) / width;
    
    _pageCtrl.currentPage = pageNum;
    
}


@end
