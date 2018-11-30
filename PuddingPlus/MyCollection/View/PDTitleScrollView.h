//
//  PDTitleScrollView.h
//  Pudding
//
//  Created by william on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^PDTitleScrollClickCallBack)(NSInteger num);
@interface PDTitleScrollView : UIView

/**
 *  初始化
 *
 *  @param frame        frame
 *  @param items        数据源
 *  @param normalCol    正常的颜色
 *  @param selectedCol  选中的颜色
 *  @param selectIndex  默认选中
 *
 */
-(instancetype)initWithFrame:(CGRect)frame
                       items:(NSArray*)items
                   normalCol:(UIColor *)normalCol
                 selectedCor:(UIColor*)selectedCol
                defaultIndex:(NSInteger )selectIndex;


/** 点击回调 */
@property (nonatomic, copy) PDTitleScrollClickCallBack clickBack;

@property(nonatomic,assign) NSInteger selectIndex;

-(void)setTitles:(NSArray*)arr;

@end
