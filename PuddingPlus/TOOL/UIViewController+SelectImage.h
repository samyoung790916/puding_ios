//
//  UIViewController+SelectImage.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/3/19.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECropViewController.h"
@interface UIViewController (SelectImage)<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
- (void)showCamera;
- (void)openPhotoAlbum;
/**
 *  打开s视频
 */
- (void)openPhotoVideoAlbum;
@property (nonatomic,strong) void(^DoneAction)(UIImage * image);

@end
