//
//  RBVideoViewController.h
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/11/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDVideoView.h"

@interface RBVideoViewController : UIViewController

@property(nonatomic,strong) NSString * callId;

@property(nonatomic,assign) BOOL  defaultRemoteModle;
@property(nonatomic,assign) BOOL  isFromMctl;

@end
