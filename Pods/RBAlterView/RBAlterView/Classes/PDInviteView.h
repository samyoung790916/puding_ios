//
//  PDInviteView.h
//  Pudding
//
//  Created by zyqiong on 16/8/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBAlterView.h"
#import "RBTextField.h"
@interface PDInviteView : RBBaseAlterView
@property (nonatomic,strong) RBTextField * textField;
@property (nonatomic,strong) void (^doneAction)(NSString *content,NSString *pcode);
@property (nonatomic,strong) void (^SelectPcode)();
@property (nonatomic,strong) NSString * placeHodler;
@property (nonatomic,strong) NSString * text;
@property (nonatomic,strong) NSString *doneBtnText;
@property (nonatomic,strong) NSString *cancleBtnText;

@property(nonatomic,strong) NSString * pcode;
@property(nonatomic,strong) NSString * countries;
@end
