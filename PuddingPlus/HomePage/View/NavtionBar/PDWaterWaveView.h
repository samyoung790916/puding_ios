//
//  PDWaterWaveView.h
//  Pudding
//
//  Created by baxiang on 16/11/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDWaterWaveView : UIView
@property (nonatomic, copy) void(^waterWaveBlock)(CGFloat currentY);
- (void)startWave;
- (void)stopWave;
@end
