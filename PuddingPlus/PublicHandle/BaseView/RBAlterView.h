//
//  RBAlterView.h
//  PuddingPlus
//
//  Created by baxiang on 2017/6/19.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
   新功能消息引导提示
 */
@interface RBAlterView : UIView

+(void)showTTSMainAlterView:(UIView*)parentView isClicked:(BOOL) isClicked;
+(void)showOptimizationAlterView:(UIView*)parentView isClicked:(BOOL) isClicked;
+(void)showMorningCallAlterView:(UIView*)parentView isClicked:(BOOL) isClicked;
+(void)showGoodNightStoryAlterView:(UIView*)parentView isClicked:(BOOL) isClicked;

-(instancetype)initWithParentView:(UIView*)parentView message:(NSString*)message;
-(void)show;
@end
