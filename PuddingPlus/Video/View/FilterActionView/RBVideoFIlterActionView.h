//
//  RBVideoFIlterActionView.h
//  RBVideoFIlterActionView
//
//  Created by Zhi Kuiyu on 2016/12/22.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RBVideoFilterType) {
    RBVideoFilterYanjing1 = 0,
    RBVideoFilterGuilina,
    RBVideoFilterTuizi ,
    RBVideoFilterHuzi ,
    RBVideoFilterYanjing11,
    RBVideoFilterGuilina1 ,
    RBVideoFilterTuizi1 ,
    RBVideoFilterHuzi1 ,
    RBVideoFilterXiaba ,
    RBVideoFilterShoulina ,
    RBVideoFilterLianxing,
    RBVideoFilterMeiyan ,

};


@interface RBVideoFIlterActionView : UIView

@property (nonatomic,copy) void(^SelectFilterBlock)(RBVideoFilterType,BOOL );

+ (RBVideoFIlterActionView *)showWidth:(float)maxWidth MaxHeight:(float)maxHeight Yvalue:(float)yValue;

@end
