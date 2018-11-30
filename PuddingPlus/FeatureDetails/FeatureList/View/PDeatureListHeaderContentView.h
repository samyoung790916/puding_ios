//
//  PDeatureListHeaderContentView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDeatureListHeaderContentView : UIView
{

    /**
     *  @author 智奎宇, 16-02-05 16:02:38
     *
     *  标题lable
     */
    UILabel * titleLable;
    
    /**
     *  @author 智奎宇, 16-02-05 16:02:25
     *
     *  内容lable
     */
    UILabel * desLable;
    
    /**
     *  @author 智奎宇, 16-02-05 16:02:08
     *
     *  是否展示内容按钮
     */
    UIButton * showButton;
    
    
    UIImageView * shareImage;
    
    float     bottom;
}

/**
 *  @author 智奎宇, 16-02-05 16:02:02
 *
 *  展示标题和内容
 *
 *  @param titleString   标题
 *  @param contentString 内容
 *  @param Bottom        最底部
 */
- (void)showContentWithTitle:(NSString *)titleString ContentString:(NSString *)contentString Bottom:(float)bottom;

/**
 *  @author 智奎宇, 16-02-05 16:02:51
 *
 *  是否展示内容
 */
@property (nonatomic,assign)  BOOL      showContent;
@property (nonatomic,weak)    UIButton    *collectBtn;
@property (nonatomic,copy) void(^collectDataBlock)(UIButton *btn);
- (void)middleToTitle:(float)flag;
@end
