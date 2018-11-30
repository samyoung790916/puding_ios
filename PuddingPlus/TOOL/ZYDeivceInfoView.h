//
//  ZYDeivceInfoView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYDeivceInfoView : UIWindow
@property (nonatomic, readwrite) NSTimeInterval desiredChartUpdateInterval;

//default is no
@property (nonatomic, readwrite) BOOL showsAverage;

+ (ZYDeivceInfoView *)sharedInstance;
@end
