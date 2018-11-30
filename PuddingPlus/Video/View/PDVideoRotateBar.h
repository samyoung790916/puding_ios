//
//  PDVideoRotateBar.h
//  TestSliderBar
//
//  Created by Zhi Kuiyu on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VideoRotateChange)(float angle,NSString * actionDetail,BOOL isEnd);
@interface PDVideoRotateBar : UIView{
    UIImageView * thumbImageView;
}
/**
 *  滑动回调
 */
@property (nonatomic,copy) VideoRotateChange videoRotate;
/** 滑块的中心 x 点 */
@property (nonatomic, assign) CGFloat thumbCenterX;
@end
