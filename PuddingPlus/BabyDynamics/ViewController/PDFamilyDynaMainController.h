//
//  PDFamilyDynamicsMainController.h
//  Pudding
//
//  Created by baxiang on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
/**
 *  家庭动态主界面
 */
@interface PDFamilyDynaMainController : PDBaseViewController
@property (nonatomic,copy) NSString *currMainID;
-(void)refreshFamilyPhotoData;
@end
