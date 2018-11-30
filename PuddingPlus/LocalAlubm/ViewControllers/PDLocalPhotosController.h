//
//  PDLocalPhotosController.h
//  Pudding
//
//  Created by baxiang on 16/7/7.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBaseViewController.h"

@protocol PDLocalPhotosControllerDelegate <NSObject>
@required
-(void)finishLocalPhotoEditedMode;
@end

/**
 *  本地截屏相册主界面
 */
@interface PDLocalPhotosController : PDBaseViewController

-(void)selectAllData:(BOOL)isAll;
-(void)updateView:(BOOL)isEditedMode;
@property (weak,nonatomic) id<PDLocalPhotosControllerDelegate> delegate;
@end
