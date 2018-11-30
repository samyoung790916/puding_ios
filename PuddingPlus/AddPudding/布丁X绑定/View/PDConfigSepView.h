//
//  PDConfigSepView.h
//  PuddingPlus
//
//  Created by kieran on 2018/6/19.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDConfigSepView : UIView
@property(nonatomic,readonly) float progress; //0 -1 

- (void)setProgress:(float)progress Animail:(Boolean) animail;
@end
