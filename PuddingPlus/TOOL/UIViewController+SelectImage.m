//
//  UIViewController+SelectImage.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/3/19.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "UIViewController+SelectImage.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
//#import "UIDevice+RBHardwareMsg.h"
#import "UIViewController+PDUserAccessAuthority.h"
#import "PDImagePickerController.h"
#import "PDLocalPhotosController.h"
@implementation UIViewController (SelectImage)
@dynamic DoneAction;

- (void)setDoneAction:(void (^)(UIImage *))DoneAction{
    objc_setAssociatedObject(self, @"doneBlock", DoneAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void(^)(UIImage *))DoneAction{
    return objc_getAssociatedObject(self, @"doneBlock");
}

#pragma mark ------------------- 打开相机 ------------------------
/**
 *  打开相机
 */
- (void)showCamera
{
   @weakify(self);
    [self isRejectCamera:^(BOOL isReject) {
        @strongify(self);
        if(!isReject){
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            controller.allowsEditing = YES;
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:controller animated:YES completion:NULL];
        }
        
    }];
}

#pragma mark ------------------- 打开相册 ------------------------
/**
 *  打开相册
 */
- (void)openPhotoAlbum
{
    [self isRejectPhotoAlbum:^(BOOL isReject) {
        if(!isReject){
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            controller.allowsEditing = YES;
            [self presentViewController:controller animated:YES completion:NULL];
        }
    }];


    
}
/**
 *  打开s视频
 */
- (void)openPhotoVideoAlbum{
    
    PDLocalPhotosController *familVC = [PDLocalPhotosController new];
    [self.navigationController pushViewController:familVC animated:YES];
}

#pragma mark ------------------- 开始修改 ------------------------
- (void)openEditor:(UIImage *)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = sender;
    
    UIImage *image = sender;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    
    
    [self.navigationController pushViewController:controller animated:YES];
}




- (void)updateUserHeader:(NSString *)userHeader HeadSmailImage:(NSString *)headSmail{
//    if([_deviceID mStrLength] > 0){
//        [RBNetworkHandle updateDeviceHeaderWithHeaderPath:userHeader DeviceID:_deviceID WithBlock:^(id res) {
//            if(res && [[res objectAtIndexOrNil:@"result"] intValue] == 0){
//                if(self.UpdateimageDoneBlock){
//                    self.UpdateimageDoneBlock(headSmail);
//                    
//                }
//                [self.view showAlterEndViewWithTitle:@"修改设备头像成功" ];
//                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//                
//                return ;
//            }
//            [self.view showAlterEndViewWithTitle:@"修改设备头像失败"];
//            
//        }];
//    }else{
//        [RBNetworkHandle updateUserHeaderWithHeaderPath:userHeader WithBlock:^(id res) {
//            if(res && [[res objectAtIndexOrNil:@"result"] intValue] == 0){
//                MsgCenter.loginData.img = headSmail;
//                if(self.UpdateimageDoneBlock){
//                    self.UpdateimageDoneBlock(headSmail);
//                    
//                }
//                [self.view showAlterEndViewWithTitle:@"修改用户成功"];
//                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//                
//                return ;
//            }
//            [self.view showAlterEndViewWithTitle:@"修改用户失败"];
//        }];
//    }
//    
    
    
}

#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image;
    //是否要裁剪
    if ([picker allowsEditing]){
        
        //编辑之后的图像
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        
    } else {
        
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if(self.DoneAction)
    {
        self.DoneAction(image);
    }
    
    
    
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        
//    }else {
//        [self openEditor:image];
//        
//        [picker dismissViewControllerAnimated:YES completion:^{
//        }];
//    }
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromTop; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] popViewControllerAnimated:NO];
    
    if(self.DoneAction){
        self.DoneAction(croppedImage);
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromTop; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] popViewControllerAnimated:NO];
    
}
@end
