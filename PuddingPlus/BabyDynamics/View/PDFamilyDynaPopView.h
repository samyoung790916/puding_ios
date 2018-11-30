//
//  PDFamilyDynaPopView.h
//  Pudding
//
//  Created by baxiang on 16/7/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFamilyMoment.h"

typedef NS_ENUM(NSInteger, PDFamilyDynaPopViewType) {
    PDFamilyDynaPopViewSave = 1001,
    PDFamilyDynaPopViewShare = 1003,
    PDFamilyDynaPopViewDelete = 1002
};
@class PDFamilyDynaPopView;

typedef void (^PDFamilyDynaPopViewSelect)(PDFamilyDynaPopView *view,NSInteger index);
@interface PDFamilyDynaPopView : UIView
@property (nonatomic,copy) PDFamilyDynaPopViewSelect currSelect;
- (instancetype)initWithFrame:(CGRect)frame withFamilyMoment:(PDFamilyMoment*)moment;
@end

