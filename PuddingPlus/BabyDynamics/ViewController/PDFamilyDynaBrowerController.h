//
//  PDFamilyBrowerController.h
//  Pudding
//
//  Created by baxiang on 16/6/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PDFamilyBrowserShowType) {
    PDFamilyBrowserShow_FamilyDyna = 0,// 家庭动态
    PDFamilyBrowserShow_MainPage //主页
};



@class PDFamilyDynaBrowerController;
@class PDFamilyMoment;
@protocol PDFamilyBrowserDelegate <NSObject>

/**
 保存当前图片资源

 @param moment <#moment description#>
 */
- (void)saveCurrPDFamilyMoment:(PDFamilyMoment*) moment;

/**
 删除当前图片资源

 @param moment <#moment description#>
 */
- (void)deleteCurrFamilyMoment:(PDFamilyMoment*) moment;
@end
@interface PDFamilyDynaBrowerController : UIViewController

/**
 当前点击的图片
 */
@property (nonatomic, strong) UIView *sourceImagesContainerView;

/**
 当前的图片 index
 */
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, weak) id<PDFamilyBrowserDelegate> delegate;

/**
 浏览的图片数组
 */
@property (nonatomic,strong) NSMutableArray<PDFamilyMoment*> *photosArray;

/**
 当前的主控
 */
@property (nonatomic,copy) NSString *currMainID; //主控ID;

/**
 页面来源
 */
@property (nonatomic,assign) PDFamilyBrowserShowType showType;
- (void)show;
@end
