//
//  RBInvitationAlter.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/5/8.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "RBAlterView.h"
#import "RBTextField.h"

@interface RBInvitationAlter : RBBaseAlterView
@property (nonatomic,strong) RBTextField * textField;
@property (nonatomic,strong) void (^doneAction)(NSString *);
@property (nonatomic,strong) NSString * placeHodler;
@property (nonatomic,strong) NSString * text;
@property (nonatomic,strong) NSString *doneBtnText;
@property (nonatomic,strong) NSString *cancleBtnText;
@end
