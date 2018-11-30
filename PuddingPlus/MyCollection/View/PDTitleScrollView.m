//
//  PDTitleScrollView.m
//  Pudding
//
//  Created by william on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTitleScrollView.h"


@interface PDTitleScrollView ()
/** 数据源数组 */
@property (nonatomic, strong) NSArray *itemsArr;
/** 按钮数组 */
@property (nonatomic, strong) NSMutableArray *btnArr;
/** 正常颜色 */
@property (nonatomic, strong) UIColor *normalColor;
/** 选中颜色 */
@property (nonatomic, strong) UIColor *selectedColor;
/** 低线 */
@property (nonatomic, weak) UIView * lineView;







@end

@implementation PDTitleScrollView


#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame
                       items:(NSArray*)items
                   normalCol:(UIColor *)normalCol
                 selectedCor:(UIColor*)selectedCol
                defaultIndex:(NSInteger )selectIndex{
    if (self = [super initWithFrame:frame]) {
        self.selectIndex = selectIndex;
        //设置数据源
        self.itemsArr = items;
        //设置颜色
        self.normalColor = normalCol;
        self.selectedColor = selectedCol;
        self.backgroundColor = mRGBColor(236, 236, 236);
        //初始化按钮
        [self initialBtns];
        [self createMiddleLine];
        //设置底线
        self.lineView.hidden = NO;
    }
    return self;
}

#pragma mark - 创建 -> 创建底线视图
-(UIView *)lineView{
    if (!_lineView) {
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 2, self.frame.size.width/self.itemsArr.count, 2)];
        vi.backgroundColor = self.selectedColor;
        [self addSubview:vi];
        _lineView = vi;
    }
    return _lineView;
}


#pragma mark - 创建 -> 按钮数组
-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        NSMutableArray * arr = [NSMutableArray array];
        _btnArr = arr;
    }
    return _btnArr;
}

#pragma mark - action: 初始化按钮数组
- (void)initialBtns{
    CGFloat width = SC_WIDTH/self.itemsArr.count;
    CGFloat height = self.frame.size.height - 2;
    for (NSInteger i = 0; i<self.itemsArr.count; i++) {
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, height)];
        lab.backgroundColor = [UIColor whiteColor];
        lab.text = self.itemsArr[i];
        lab.tag = i;
        lab.textColor = self.normalColor;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.userInteractionEnabled = YES;
        lab.font = [UIFont systemFontOfSize:SX(17)];
        [self addSubview:lab];
        [self.btnArr addObject:lab];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [tap addTarget:self action:@selector(tap:)];
        [lab addGestureRecognizer:tap];
        
        
        if (i== self.selectIndex) {
            [self tap:[lab.gestureRecognizers firstObject]];
        }
    }
}

- (void)tap:(UIGestureRecognizer *)tap{
    
    //改变按钮状态
    for (UILabel * lab in self.btnArr) {
        lab.textColor = self.normalColor;
        lab.userInteractionEnabled = YES;
    }
    
    UILabel * label = (UILabel*)tap.view;
    label.textColor = self.selectedColor;
    label.userInteractionEnabled = NO;
    //动画移动
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.center = CGPointMake(label.center.x, self.lineView.center.y);
    }];
    //回调
    if (self.clickBack) {
        NSUInteger num = label.tag;
        self.selectIndex = num;
        self.clickBack(num);
    }
    
    
    
}

#pragma mark - 创建 -> 创建中间的线
- (void)createMiddleLine{
    UIView *lineView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, 1, SX(25))];
    lineView.backgroundColor = mRGBColor(236, 236, 236);
    lineView.center = CGPointMake(SC_WIDTH*0.5, self.height * 0.5);
    [self addSubview:lineView];
}

-(void)setTitles:(NSArray *)arr{
    for (NSInteger i = 0; i<self.btnArr.count; i++) {
        UILabel * lab = self.btnArr[i];
        NSString * result = arr[i];
        if ([self currString:result containsString:@"/"]) {
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:arr[i]];
            NSRange contentRange = NSMakeRange(2, content.length - 2);
            [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(17)] range:contentRange];
            lab.attributedText = content;
        }else{
            lab.text = arr[i];
        }
    }
}

-(BOOL)currString:(NSString*) string containsString:(NSString*) subStr{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        return [string containsString:subStr];
    }else{
        NSRange range = [string rangeOfString:subStr];
        if (range.location !=NSNotFound) {
            return YES;
        }
        return NO;
    }
}



@end
