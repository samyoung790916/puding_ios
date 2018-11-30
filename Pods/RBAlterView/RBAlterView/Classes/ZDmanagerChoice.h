//
//  ZDmanagerChoice.h
//  JuanRoobo
//
//  Created by william on 15/9/1.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDmanagerChoice : UIButton
@property (strong, nonatomic)  UILabel *useraNameLable;
@property (strong, nonatomic)  UILabel *tittle;
@property (strong, nonatomic)  UIImageView *headImageBtn;
@property (strong,nonatomic)   UIView *backCircle;
@property(nonatomic,assign) int  index;
@property(nonatomic,strong) NSString * title;


- (void)setImageURL:(NSString *)imageURL DefaultImage:(UIImage *)image Title:(NSString *)title;

-(void)getChosen;
-(void)disChosen;

@end
