//
//  PDTTSTagsView.h
//  Pudding
//
//  Created by baxiang on 2016/12/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDTTSListModel.h"

/**
 tts 扮演布丁推荐底部推荐view
 */
@interface PDTTSTagsView : UIView
@property (nonatomic,copy) NSArray<PDTTSListContent*> *tagsArray;   //数据源
@property (nonatomic) CGFloat lineSpacing;       //行间距, 默认为10
@property (nonatomic) CGFloat interitemSpacing; //元素之间的间距，默认为5


@property (nonatomic) UIEdgeInsets tagInsets; // default is (5,5,5,5)
@property (nonatomic) CGFloat tagBorderWidth;           //标签边框宽度, default is 0
@property (nonatomic) CGFloat tagcornerRadius;  // default is 0
@property (strong, nonatomic) UIColor *tagBorderColor;
@property (strong, nonatomic) UIColor *tagSelectedBorderColor;
@property (strong, nonatomic) UIColor *tagBackgroundColor;
@property (strong, nonatomic) UIColor *tagSelectedBackgroundColor;
@property (strong, nonatomic) UIFont *tagFont;
@property (strong, nonatomic) UIFont *tagSelectedFont;
@property (strong, nonatomic) UIColor *tagTextColor;
@property (strong, nonatomic) UIColor *tagSelectedTextColor;
@property (nonatomic) CGFloat tagHeight;        //标签高度，默认30
@property (nonatomic) CGFloat mininumTagWidth;  //tag 最小宽度值, 默认是0，即不作最小宽度限制
@property (nonatomic) CGFloat maximumTagWidth;  //tag 最大宽度值, 默认是CGFLOAT_MAX， 即不作最大宽度限制


@property(nonatomic,strong) void(^SelectTextBlock)(NSString * text);
@property(nonatomic,strong) void(^SendPlayCmdBlock)(id data);
@end
