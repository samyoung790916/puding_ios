//
//  RBAlterView.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/2/9.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGeometry.h>

typedef NS_ENUM(int, RBAlterAnimailType) {
    RBAlterAnimailNone              = 0,
    RBAlterAnimailActinSheet        = 1,
};


@interface RBAlterBgView : UIView<UIDynamicAnimatorDelegate>
@property (nonatomic,assign) CGRect  disEnableFrame;
@property (nonatomic,copy) UIDynamicAnimator * animator;
@property (nonatomic,strong) void(^AnimailEndBlock)(void);
@property (nonatomic,strong) void(^touchAction)(void);
@end


@interface RBBaseAlterView : UIView{

    UILabel        *   titleLable;

}

@property (nonatomic,assign) RBAlterAnimailType * animalType;

@property (nonatomic,copy) void(^ClickActionBlock)(int index);

@property (nonatomic,strong) NSArray * bottomItems;

@property (nonatomic,strong) NSString * title;


- (void)deallocBlockData;
@end
