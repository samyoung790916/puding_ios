//
//  PDVideoAnimailBtn.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(int , VideoBtnType) {

    VideoBtnVoice,//播放声音类型
    VideoBtnVideo,//录制视频类型
    VideoBtnVoice_fullsceen,//播放声音类型
    VideoBtnVideo_fullsceen,//录制视频类型
};


@interface PDVideoAnimailBtn : UIControl{
    UIImageView * imageView;
}

@property(nonatomic,strong) NSArray * selectImages;
@property(nonatomic,strong) UIImage * normailImage;

@property(nonatomic,assign) VideoBtnType type;
@end
