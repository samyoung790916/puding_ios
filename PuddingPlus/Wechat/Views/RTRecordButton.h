//
//  RTRecordButton.h
//  StoryToy
//
//  Created by baxiang on 2017/11/3.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTRecordButton : UIControl

@property (nonatomic, strong) NSString *normalTitle;
@property (nonatomic, strong) NSString *cancelTitle;

- (void)setBeginInputAction:(void (^)(void))beginInput
            MoveInputAction:(void (^)(BOOL))touchMove
             EndinputAction:(void (^)(void))endInput
          inputCancelAction:(void (^)(void))cancelInput
                  countDown:(void (^)(int))countDownTime;

@end
