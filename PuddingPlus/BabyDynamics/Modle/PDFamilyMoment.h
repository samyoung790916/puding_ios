//
//  PDFamilyMoment.h
//  Pudding
//
//  Created by baxiang on 16/6/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    PDFamilyMomentPhoto = 0, // 图片
    PDFamilyMomentVideo = 1 , // 视频
    PDFamilyMomentAudio = 3, // 音频
    PDFamilyMomentMess = 4 ,// 音频
    PDFamilyMomentSharePhoto = 10, // 音频分享
    PDFamilyMomentShareVideo = 11 // 视频分享
} PDFamilyMomentType;

@interface PDFamilyMoment : NSObject

@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) NSUInteger  ID;
@property (nonatomic,strong) NSString *thumb;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSNumber *length;
@property (nonatomic,assign) PDFamilyMomentType type;
@property (nonatomic,assign) CGFloat textHeight;

- (BOOL)isVideo;
- (BOOL)isPhoto;
- (BOOL)isShare;
- (BOOL)isAudio;
@end
