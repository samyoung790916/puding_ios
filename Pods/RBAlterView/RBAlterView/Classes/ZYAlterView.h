//
//  ZYAlterView.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/6/30.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(int, ZYAlterType){
    ZYAlterNone = 0,
    ZYAlterLoading = 1,
    ZYAlterFail = 2,
    ZYAlterScuess = 3,
    ZYAlterExprossion = 4,
    //使用图片,不适用动画
};
@interface ZYAlterView : UIView





@property (nonatomic,strong) UIImageView    * imageView;
@property (nonatomic,strong) UILabel        * titleLable;
@property (nonatomic,strong) UILabel        * describeLable;
@property (nonatomic,strong) UIScrollView   * describeBg;
@property (nonatomic,strong) NSArray        * buttonItems;
@property (nonatomic,strong) UILabel        * buttonLable;


@property (nonatomic,strong) NSString       * titleString;
@property (nonatomic,strong) NSArray        * btnitems;
@property (nonatomic,strong) NSString       * describeString;
@property (nonatomic,strong) NSString       * imageName;
@property (nonatomic,strong) NSArray        * AnimailImagesNamed;
@property (nonatomic,strong) NSString       * bottonString;

@property (nonatomic, strong) NSAttributedString *describeAttributeString;


@property (nonatomic,assign ,setter=loadAnimil:) ZYAlterType    loadAnimilType;
- (void)reset;
- (float)desMaxHeight;
- (void)clearCacheData;
- (void)deallocBlockData;
- (void)loadAnimil:(ZYAlterType)key;
@property (nonatomic,copy) void(^ClickActionBlock)(int index);

@end
