//
//  PDRecordingLable.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDRecordingLable : UIView{
    UIImageView * imageView;
    UILabel     * timeLable;
    
    NSTimer     * timer;
}

@property(nonatomic,assign) BOOL  isRecoreding;



@end
