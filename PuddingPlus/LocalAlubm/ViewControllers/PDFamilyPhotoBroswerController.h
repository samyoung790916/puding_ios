//
//  PDFamilyPhotoBroswerControllerViewController.h
//  Pudding
//
//  Created by baxiang on 16/7/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDAssetModel.h"
#import "PDFamilyPhoto.h"
typedef NS_ENUM(NSInteger, FamilyPhotoType) {
    FamilyPhotoRemote ,
    FamilyPhotoLocal
};
@protocol PDFamilyPhotoBroswerControllerDelegate <NSObject>

@optional
-(void)deleteLoacalPhoto:(PDAssetModel*)model;
-(void)deleteCurrFamilyMoment:(id)model;
@end
@interface PDFamilyPhotoBroswerController : UIViewController
@property (nonatomic, strong) NSMutableArray *photoArr;                ///< All photos / 所有图片的数组
@property (nonatomic, assign) NSInteger currentIndex;         ///< Index of the photo user click / 用户点击的图片的索引
@property (nonatomic,assign) FamilyPhotoType type;
@property (nonatomic,weak) id<PDFamilyPhotoBroswerControllerDelegate> delegate;
@end
