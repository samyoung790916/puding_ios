//
//  UIViewController+RBAlter.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/2/10.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYAlterView.h"
#import "PDInviteView.h"

typedef NS_ENUM(int, RBAlterType) {
    RBAlterTypeNone         = 0,
    RBAlterTypeFail         = 1,
    RBAlterTypeScuess       = 2,
    RBAlterTypeLoading      = 3,
};

@interface UIViewController (RBAlter)
@property (nonatomic,assign) NSInteger          currentTran;
@property (nonatomic,strong) UIView           * alterBg;


#pragma mark - alter
- (void)updateAlter:(ZYAlterView *) alterView delay:(float)delay alterString:(NSString *) alterstring type:(ZYAlterType) type auotHidden:(BOOL)ishidden;
- (void)hiddenAlterView:(UIView *)view delay:(float)delay;
- (void)hiddenAlterView:(UIView *)view delay:(float)delay animail:(BOOL)animail;
#pragma mark - public alter

- (void)updateAlter:(ZYAlterView *) alterView alterString:(NSString *) titleString type:(ZYAlterType) type auotHidden:(BOOL)ishidden;
- (ZYAlterView *)tipAlter:(NSString *)titleString type:(ZYAlterType) type;
- (ZYAlterView *)tipAlter:(NSString *)imageNamed TitleString:(NSString *)titleString DescribeString:(NSString *)describeString Items:(NSArray *)items :(void(^)(int index)) block;
- (ZYAlterView *)tipAlter:(NSString *)titleString type:(ZYAlterType) type delay:(float)delay auotHidden:(BOOL)ishidden;
- (ZYAlterView *)tipAlter:(NSString *)titleString AlterString:(NSString *)describeString type:(ZYAlterType) type delay:(float)delay auotHidden:(BOOL)ishidden;
- (ZYAlterView *)tipAlter:(NSString *)titleString AlterString:(NSString *)describeString Item:(NSArray *)items type:(ZYAlterType) type delay:(float)delay :(void(^)(int index)) block;
- (ZYAlterView *)tipAlter:(NSString *)describeString ItemsArray:(NSArray *)items :(void(^)(int index)) block;
#pragma mark - 特殊alter
//{@"imgUrl":@"http://www.baidu.com",@"title":@"biaoti"}
- (UIView *)showChooseManager:(NSArray *)array DefaultIcon:(UIImage *)icon EndAlter:(void(^)(int selectIndex)) block;
- (UIView *)showTextViewAlter:(NSString *)titleString PlaceHodler:(NSString *)place DoneBtnText:(NSString *)doneText CancleText:(NSString *)cancleText Text:(NSString *)text :(void(^)(NSString * selectedName)) block;
- (UIView *)showUpdateNickName:(NSString *)currentName title:(NSString *)title isPhone:(BOOL)isPhoneTxt EndAlter:(void(^)(NSString * selectedName)) block;


- (UIView *)showAlterWithView:(RBBaseAlterView *)alterView ButtonItem:(NSArray <NSString *> *) items Block:(void(^)(int index)) block;
- (UIView *)showSelectMinutes:(NSUInteger)minutes ShowMinues:(NSArray *)showMinues :(void(^)(NSUInteger  selectMintes)) selectBlock;
- (UIView *)showSelectTime:(NSString *)startTime EndTime:(NSString *)endTime :(void(^)(NSString * s1, NSString * s2)) selectBlock;
- (UIView *)showSheetWithItems:(NSArray *)array DestructiveItem:(NSString *)destrucivieTitle CancelTitle:(NSString *)cancelTitle WithBlock:(void(^)(int selectIndex)) selectBlock;
- (UIView *)showSheetWithItems:(NSArray *)array Images:(NSArray*)images Title:(NSString*)title CancelTitle:(NSString *)cancelTitle WithBlock:(void(^)(int selectIndex)) selectBlock;
- (ZYAlterView *)tipAlter:(NSString *)titleString AlterString:(NSString *)describeString Item:(NSArray *)items type:(ZYAlterType) type  :(void(^)(int index)) block;
- (UIView *)showSelectDateString:(NSString *)selectDateString DateFormat:(NSString *)format :(void(^)(NSDate * selectDate)) selectBlock;
- (UIView *)showSelectGrades:(NSUInteger)gradesIndex ShowGradess:(NSArray *)allGrades :(void(^)(NSUInteger gradesIndex)) selectBlock;
#pragma mark - handle method

//获得屏幕图像
- (UIImage *)imageFromView: (UIView *) theView;

- (UIView *)showInviteTextViewAlter:(NSString *)titleString  PlaceHodler:(NSString *)place DoneBtnText:(NSString *)doneText CancleText:(NSString *)cancleText Text:(NSString *)text SelectCountries:(void(^)(PDInviteView * invaitev)) block :(void(^)(NSString * selectedName,NSString * pcode)) block;



- (ZYAlterView *)tipAlterWithAttributeStr:(NSAttributedString *)describeAttributeString ItemsArray:(NSArray *)items :(void(^)(int index)) block;
@end
