//
//  PDFamilyDynaCell.h
//  Pudding
//
//  Created by baxiang on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFamilyMoment.h"

@class PDFamilyDynaMainCell;
typedef void (^DeleteFamilyMoment)(BOOL isDelete,PDFamilyMoment *moment);
typedef void (^ShowVideoView)(void);
typedef void (^PlayVideoView)(void);
typedef void (^ShowPhotoView)(void);
typedef void (^LongPressHandle)(void);
typedef void (^PlayAudioHandle)(UIImageView *voiceChangeView,PDFamilyMoment *moment);
@interface PDFamilyDynaMainCell : UITableViewCell
@property (nonatomic,strong) UIImageView* photoImageView;
@property (nonatomic,strong) PDFamilyMoment *familyMoment;
@property (nonatomic,copy)  DeleteFamilyMoment  deleteCurrFamilyMoment;
@property (nonatomic,copy)  ShowVideoView  showVideoView;
@property (nonatomic,copy)  ShowPhotoView  showPhotoView;
@property (nonatomic,copy)  PlayVideoView  playVideoView;
@property (nonatomic,copy)  LongPressHandle  longPressHandle;
@property (nonatomic,copy)  PlayAudioHandle  playAudioHandle;
@property (nonatomic,assign) BOOL isEditMode; // 编辑模式
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,assign) BOOL isDelete;
@property (nonatomic,assign) BOOL isFirstCell;
@property (nonatomic,assign) BOOL isLoadAnimation;

@end
