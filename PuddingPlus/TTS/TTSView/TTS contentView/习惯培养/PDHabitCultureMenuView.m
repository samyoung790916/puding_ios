//
//  PDHabitCultureMenuView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDHabitCultureMenuView.h"

@implementation PDHabitCultureMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
   
        
        editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setTitle:NSLocalizedString( @"edit_", nil) forState:UIControlStateNormal];
        [editBtn setTitleColor:mRGBToColor(0xa2acb3) forState:UIControlStateNormal];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:SX(17)];
        [self addSubview:editBtn];

        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setTitle:NSLocalizedString( @"delete_", nil) forState:UIControlStateNormal];
        [deleteBtn setTitleColor:mRGBToColor(0xff644c) forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:SX(17)];
        [self addSubview:deleteBtn];
        
        float butWidth = (self.width - SX(140))/3;
        editBtn.frame = CGRectMake(butWidth, 0, butWidth, self.height);
        deleteBtn.frame = CGRectMake(editBtn.right - .5, 0, butWidth, self.height);
        
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setTitle:NSLocalizedString( @"add", nil) forState:UIControlStateNormal];
        [sendButton setTitleColor:mRGBToColor(0xffb152) forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:SX(17)];
        [self addSubview:sendButton];
        
        
        cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [cancleBtn setTitle:NSLocalizedString( @"return", nil) forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancleBtn setTitleColor:mRGBToColor(0xa2acb3) forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:SX(17)];
        [self addSubview:cancleBtn];
        
        cancleBtn.layer.borderWidth = .5;
        cancleBtn.layer.borderColor = mRGBToColor(0xe0e3e6).CGColor;
        [cancleBtn setBackgroundColor:[UIColor whiteColor]];
        
        
        editBtn.layer.borderWidth = .5;
        editBtn.layer.borderColor = mRGBToColor(0xe0e3e6).CGColor;
        [editBtn setBackgroundColor:[UIColor whiteColor]];

        deleteBtn.layer.borderWidth = .5;
        deleteBtn.layer.borderColor = mRGBToColor(0xe0e3e6).CGColor;
        [deleteBtn setBackgroundColor:[UIColor whiteColor]];

        sendButton.layer.borderWidth = .5;
        sendButton.layer.borderColor = mRGBToColor(0xe0e3e6).CGColor;
        [sendButton setBackgroundColor:[UIColor whiteColor]];

        cancleBtn.frame = CGRectMake(0, 0, self.width/2+.5, self.height);
        sendButton.frame = CGRectMake(self.width/2, 0, self.width/2, self.height);
        
     
        
        
        currentModle = HabitModleNormal;

        [self loadNormailModleView];

    }
    return self;
}


- (void)setSelectModle:(PDHabitCultureModle *)selectModle{

//    if([selectModle isKindOfClass:[PDHabitCultureModle class]]){
//        _selectModle = [selectModle copy];
//        if([_selectModle.isNetData boolValue]){
//            currentModle = HabitModleSelect;
//        }else{
//            currentModle = HabitModleUserDataSelect;
//        }
//        
//    }else{
//        _selectModle = nil;
//        currentModle = HabitModleNormal;
//    }
//    
//    [UIView animateWithDuration:.3 animations:^{
//        [self updateCurrentModle];
//    }];
    
}



- (void)cancleAction:(id)sender{
    self.selectModle = nil;

}

- (void)updateCurrentModle{

    switch (currentModle) {
        case HabitModleNormal: {
            [self loadNormailModleView];
            break;
        }
        case HabitModleSelect: {
            break;
        }
        case HabitModleUserDataSelect: {
            [self loadUserDataModleSelectView];
            break;
        }
    }

}


- (void)loadNormailModleView{
    cancleBtn.frame = CGRectMake(0, 0, self.width/2+.5, self.height);
    sendButton.frame = CGRectMake(self.width/2, 0, self.width/2, self.height);

}


- (void)loadUserDataModleSelectView{
    float butWidth = (self.width - SX(140))/3;
    
    cancleBtn.frame = CGRectMake(0, 0, butWidth, self.height);
    editBtn.frame = CGRectMake(cancleBtn.right - .5, 0, butWidth, self.height);
    deleteBtn.frame = CGRectMake(editBtn.right - .5, 0, butWidth, self.height);
    sendButton.frame = CGRectMake(deleteBtn.right - .5, 0, SX(140), self.height + .15);
}

@end
