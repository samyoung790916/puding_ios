//
//  PDFamilyVideoPlayerController.h
//  Pudding
//
//  Created by baxiang on 16/7/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFamilyMoment.h"
#import "PDAssetModel.h"
typedef NS_ENUM(NSInteger, FamilyVideoType) {
    FamilyVideoMoment = 0,
    FamilyVideoLocalPhotos,
    FamilyVideoMessageCenter,
    FamilyVideoMainPageView,
};

@protocol PDFamilyVideoPlayerControllerDelegate <NSObject>
@optional
- (void)saveCurrPDFamilyMoment:(PDFamilyMoment*) moment;
- (void)deleteCurrFamilyMoment:(id) model;
- (void)deleteLocalVideo:(PDAssetModel*)asset;
@end
/**
 *  家庭动态视频播放界面
 */
@interface PDFamilyVideoPlayerController : UIViewController

@property (nonatomic,strong) UIImage *placeholderImage;
@property (nonatomic,assign) id<PDFamilyVideoPlayerControllerDelegate> delegate;
@property (nonatomic,strong) id videoModel;
@property (nonatomic,assign) FamilyVideoType type;
@end
