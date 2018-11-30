//
//  UIViewController+RBAlter.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/2/10.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "UIViewController+RBAlter.h"
#import "RBNikeNameAlter.h"
#import "RBActionSheet.h"
#import "BlockButton.h"
#import "RBInvitationAlter.h"
#import "PDInviteView.h"
#import <objc/runtime.h>
#import "ZYAlterView.h"
#import "RBAlterView.h"
#import "ZYChosseManagerAlter.h"
#import "UIView+RBAdd.h"
#import "RBAPublic.h"
#import "UIDevice+RBAdd.h"
#import "ZYSelectTimerView.h"
#import "UIImage+ImageEffects.h"
#import "ZYSelectMinutesView.h"
#import "ZYSelectDateView.h"
#import "ZYSelectGradeView.h"

#define RB_SC_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define RB_IS_IPHONE_X ((RB_SC_HEIGHT == 812.0f) ? YES : NO)

@implementation UIViewController (RBAlter)
@dynamic currentTran;
@dynamic alterBg;

#pragma mark -  set get
-(void)setCurrentTran:(NSInteger)currentTran{
    objc_setAssociatedObject(self, @"currentTran", [NSNumber numberWithInteger:currentTran], OBJC_ASSOCIATION_RETAIN);
    
}

- (NSInteger)currentTran{
    NSNumber * num = objc_getAssociatedObject(self, @"currentTran");
    if(!num){
        return UIInterfaceOrientationPortrait;
    }
    return [num integerValue];
    
}

- (void)setAlterBg:(UIView *)alterBg{
    objc_setAssociatedObject(self, @"alterBg", alterBg, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)alterBg{
    return  objc_getAssociatedObject(self, @"alterBg");
}

#pragma mark - bgView
/**
 *  提示框背景
 */
- (RBAlterBgView *)getBgView{
    
    if([[self.view viewWithTag:[@"alterBg" hash]] isKindOfClass:[RBAlterBgView class]]){
        RBAlterBgView * al = (RBAlterBgView *)[self.view viewWithTag:[@"al_bg" hash]] ;
        al.transform = rbtransform(self.currentTran); ;
        return (RBAlterBgView *)[self.view viewWithTag:[@"alterBg" hash]];
    }
    RBAlterBgView * view = [[RBAlterBgView alloc] initWithFrame:self.view.bounds];
    view.tag = [@"alterBg" hash];
    
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    view.alpha = 0.f;
    [self.view addSubview:view];
    return view;
}
#pragma mark - alter
- (void)removeBgView:(BOOL)animail{
    RBAlterBgView * bgAView = [self getBgView];
    if([bgAView.subviews count] == 0){
        bgAView.alpha = 0 ;
        [bgAView removeFromSuperview];
        
    }
}

- (void)hiddenAlterView:(UIView *)view delay:(float)delay{
    [self hiddenAlterView:view delay:delay animail:YES];
}

- (void)hiddenAlterView:(UIView *)view delay:(float)delay animail:(BOOL)animail{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        RBAlterBgView * bgView = [self getBgView];
        UIView * lastView = nil;
        for(int i = (int)[bgView.subviews count] - 1 ; i >=0 ; i--){
            lastView = [bgView.subviews objectAtIndex:i];
            if(lastView && lastView.alpha == 0){
                break;
            }
        }
        
        if(animail){
            [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                if(self.currentTran != UIInterfaceOrientationPortrait){
                    view.left= self.view.width;
                }else{
                    view.top= self.view.height + ASY(30);
                }
                
            } completion:^(BOOL finished) {
                if([view respondsToSelector:@selector(deallocBlockData)]){
                    [(ZYAlterView *)view deallocBlockData];
                }
                [view removeFromSuperview];
                [self removeBgView:YES];
            }];
        }else{
            if([view respondsToSelector:@selector(deallocBlockData)]){
                [(ZYAlterView *)view deallocBlockData];
            }
            [view removeFromSuperview];
            [self removeBgView:NO];
        }
    });
}

- (void)showAlterView:(UIView *)view IsCenter:(BOOL)isCenter isKeyboard:(BOOL)isKeyboard delay:(float)delay AutoHiddenTime:(float) hiddenTime{
    
    CGFloat offsetY = 0;
    if (isKeyboard) {
        offsetY = ASX(65);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        view.transform = rbtransform(self.currentTran);
        if(self.currentTran != UIInterfaceOrientationPortrait){
            view.left= isCenter ? -view.height : self.view.bottom;
        }else{
            view.top= isCenter ? -view.height : self.view.bottom;
            
        }
        UIView * bgView = [self getBgView];
        
        [UIView animateWithDuration:0.3 delay:delay usingSpringWithDamping:isCenter? .6:.8 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            if(bgView.alpha < 1){
                bgView.alpha = 1;
            }
            if(isCenter){
                UIDevice *device = [[UIDevice alloc]init];
                BOOL isFourInch =  [device isMoreThanIphone4];
                if (!isFourInch) {
                    view.center = CGPointMake(self.view.center.x, self.view.center.y - 1.5* offsetY);
                }else{
                    view.center = CGPointMake(self.view.center.x, self.view.center.y - offsetY);
                    
                }
            }else{
                view.top = self.view.height - view.height - (RB_IS_IPHONE_X ? 36 : 0);
            }
        } completion:^(BOOL finished) {
            if(hiddenTime > 0){
                [self hiddenAlterView:view delay:hiddenTime];
            }
        }];
    });
}

- (void)showAlterView:(UIView *)view isKeyboard:(BOOL)isKeyboard delay:(float)delay AutoHiddenTime:(float) hiddenTime{
    [self showAlterView:view IsCenter:YES isKeyboard:isKeyboard delay:delay AutoHiddenTime:hiddenTime];
}


- (void)updateAlter:(ZYAlterView *) alterView delay:(float)delay alterString:(NSString *) alterstring type:(ZYAlterType) type auotHidden:(BOOL)ishidden{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alterView clearCacheData];
        alterView.titleString = alterstring;
        [alterView loadAnimil:type];
        [alterView reset];
        if(ishidden){
            [self hiddenAlterView:alterView delay:1.5];
        }
    });
    
}

#pragma mark - AlterView

#pragma mark  public alter

- (void)updateAlter:(ZYAlterView *) alterView alterString:(NSString *) titleString type:(ZYAlterType) type auotHidden:(BOOL)ishidden{
    [self updateAlter:alterView delay:0 alterString:titleString type:type auotHidden:ishidden ];
}

- (ZYAlterView *)tipAlter:(NSString *)titleString type:(ZYAlterType) type{
    return [self tipAlter:titleString type:type delay:0 auotHidden:YES];
}

- (ZYAlterView *)tipAlter:(NSString *)imageNamed TitleString:(NSString *)titleString DescribeString:(NSString *)describeString Items:(NSArray *)items :(void(^)(int index)) block{
    ZYAlterView * alter = [self tipAlter:titleString DescribeString:describeString ContentImageNamed:imageNamed Item:items AnimailType:ZYAlterNone :block];
    [self showAlterView:alter isKeyboard:NO delay:0 AutoHiddenTime:0];
    return alter;
}

- (ZYAlterView *)tipAlter:(NSString *)titleString type:(ZYAlterType) type delay:(float)delay auotHidden:(BOOL)ishidden{
    ZYAlterView * alter = [self tipAlter:titleString DescribeString:nil ContentImageNamed:nil Item:nil AnimailType:type :nil];
    [self showAlterView:alter isKeyboard:NO delay:delay AutoHiddenTime:ishidden?1.0:0];
    return alter;
}

- (ZYAlterView *)tipAlter:(NSString *)titleString AlterString:(NSString *)describeString type:(ZYAlterType) type delay:(float)delay auotHidden:(BOOL)ishidden{
    ZYAlterView * alter = [self tipAlter:titleString DescribeString:nil ContentImageNamed:nil Item:nil AnimailType:type :nil];
    [self showAlterView:alter isKeyboard:NO delay:delay AutoHiddenTime:ishidden?1.0:0];
    return alter;
    
}

- (ZYAlterView *)tipAlter:(NSString *)titleString AlterString:(NSString *)describeString Item:(NSArray *)items type:(ZYAlterType) type delay:(float)delay :(void(^)(int index)) block{
    
    ZYAlterView * alter = [self tipAlter:titleString DescribeString:describeString ContentImageNamed:nil Item:items AnimailType:type :block];
    [self showAlterView:alter isKeyboard:NO delay:delay AutoHiddenTime:0];
    return alter;
}

- (ZYAlterView *)tipAlter:(NSString *)titleString AlterString:(NSString *)describeString Item:(NSArray *)items type:(ZYAlterType) type  :(void(^)(int index)) block{
    
    ZYAlterView * alter = [self tipAlter:titleString DescribeString:describeString ContentImageNamed:nil Item:items AnimailType:type :block];
    [self showAlterView:alter isKeyboard:YES delay:0 AutoHiddenTime:0];
    return alter;
}
//#pragma mark - 配网最后一步提示
//- (ZYAlterView *)tipAlter:(NSString *)titleString AlterString:(NSString *)describeString Item:(NSArray *)items type:(ZYAlterType) type delay:(float)delay :(void(^)(int index)) block{
//    ZYAlterView * alter = [self tipAlter:titleString DescribeString:describeString ContentImageNamed:nil Item:items AnimailType:type :block];
//    [self showAlterView:alter isKeyboard:NO delay:delay AutoHiddenTime:0];
//    return alter;
//}

- (ZYAlterView *)tipAlterWithAttributeStr:(NSAttributedString *)describeAttributeString ItemsArray:(NSArray *)items :(void(^)(int index)) block{
    ZYAlterView * alter = [self tipAlter:nil DescribeAttributeString:describeAttributeString ContentImageNamed:nil Item:items AnimailType:ZYAlterNone :block];
    [self showAlterView:alter isKeyboard:NO delay:0 AutoHiddenTime:0];
    return alter;
    
}

- (ZYAlterView *)tipAlter:(NSString *)describeString ItemsArray:(NSArray *)items :(void(^)(int index)) block{
    ZYAlterView * alter = [self tipAlter:nil DescribeString:describeString ContentImageNamed:nil Item:items AnimailType:ZYAlterNone :block];
    [self showAlterView:alter isKeyboard:NO delay:0 AutoHiddenTime:0];
    return alter;
    
}
- (ZYAlterView *)tipAlter:(NSString *)titleString DescribeAttributeString:(NSAttributedString *)describeAttString ContentImageNamed:(NSString *)imageNamed Item:(NSArray *)items AnimailType:(ZYAlterType) type  :(void(^)(int index)) block{
    UIView * view = [self getBgView];
    if(items .count == 0 && [imageNamed length] == 0){
        view.backgroundColor = [UIColor clearColor];
    }
    //获取高度
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    //    CGRect rect = [describeAttString boundingRectWithSize:CGSizeMake(self.view.width - ASX(40), MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FontSize ]} context:nil];
    CGRect rect = [describeAttString boundingRectWithSize:CGSizeMake(self.view.width - ASX(40), MAXFLOAT) options:options context:nil];
    
    if (describeAttString.length == 0) {
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 0);
    }
    //创建主画面
    ZYAlterView * alter = [[ZYAlterView alloc] initWithFrame:CGRectMake((self.view.width - ASX(285))/2, 100, ASX(285), ASX(120) + rect.size.height)];
    CGPoint center = self.view.center;
    center.y -= 30;
    alter.tag = [@"aa" hash];
    alter.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
    alter.titleString = titleString;
    alter.describeAttributeString = describeAttString;
    alter.btnitems = items;
    alter.imageName = imageNamed;
    [alter loadAnimil:type];
    __weak UIView * weakAlter = alter;
    [alter setClickActionBlock:^(int index) {
        [self hiddenAlterView:weakAlter delay:0];
        if(block){
            block(index);
        }
    }];
    
    [alter reset];
    [view addSubview:alter];
    return alter;
}

- (ZYAlterView *)tipAlter:(NSString *)titleString DescribeString:(NSString *)describeString ContentImageNamed:(NSString *)imageNamed Item:(NSArray *)items AnimailType:(ZYAlterType) type  :(void(^)(int index)) block{
    UIView * view = [self getBgView];
    if(items .count == 0 && [imageNamed length] == 0){
        view.backgroundColor = [UIColor clearColor];
    }
    //获取高度
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [describeString boundingRectWithSize:CGSizeMake(ASX(285) - ASX(40), MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 ]} context:nil];
    
    if (describeString.length == 0) {
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 0);
    }
    //创建主画面
    ZYAlterView * alter = [[ZYAlterView alloc] initWithFrame:CGRectMake((self.view.width - ASX(285))/2, 100, ASX(285), ASX(120) + rect.size.height)];
    CGPoint center = self.view.center;
    center.y -= 30;
    alter.tag = [@"aa" hash];
    alter.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
    alter.titleString = titleString;
    alter.describeString = describeString;
    alter.btnitems = items;
    alter.imageName = imageNamed;
    [alter loadAnimil:type];
    __weak UIView * weakAlter = alter;
    [alter setClickActionBlock:^(int index) {
        [self hiddenAlterView:weakAlter delay:0];
        if(block){
            block(index);
        }
    }];
    
    [alter reset];
    [view addSubview:alter];
    return alter;
}

- (UIView *)showChooseManager:(NSArray *)array DefaultIcon:(UIImage *)icon EndAlter:(void(^)(int selectIndex)) block{
    UIView * view = [self getBgView];
    float height = 244 ;
    ZYChosseManagerAlter * alter = [[ZYChosseManagerAlter alloc] initWithFrame:CGRectMake((self.view.width - 260)/2, 100, 260, height)];
    [alter addItems:array DefaultImage:icon];
    alter.center = self.view.center;
    [view addSubview:alter];
    __weak ZYChosseManagerAlter * weakAlter = alter;
    
    [alter setClickActionBlock:^(int index) {
        
        [self hiddenAlterView:weakAlter delay:0];
        if(block && index == 1){
            block(weakAlter.selectIndex);
        }
    }];
    
    [self showAlterView:alter isKeyboard:NO delay:0 AutoHiddenTime:0];
    
    return alter;
}



- (UIView *)showInviteTextViewAlter:(NSString *)titleString  PlaceHodler:(NSString *)place DoneBtnText:(NSString *)doneText CancleText:(NSString *)cancleText Text:(NSString *)text SelectCountries:(void(^)(PDInviteView * invaitev)) SelectCountry :(void(^)(NSString * selectedName,NSString * pcode)) block{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    UIView * view = [self getBgView];
    PDInviteView * alter = [[PDInviteView alloc] initWithFrame:CGRectMake(ASX(30), 100, ASX(260), ASX(250))];
    alter.placeHodler = place;
    alter.title = titleString;
    alter.text = [text length] > 0 ? text : @"";
    if (doneText != nil) {
        alter.doneBtnText = doneText;
    }
    if (cancleText != nil) {
        alter.cancleBtnText = cancleText;
    }
    alter.textField.keyboardType = UIKeyboardTypePhonePad;
    
    
    __weak PDInviteView * al = alter;
    [alter setDoneAction:^(NSString * str,NSString*pcode) {
        //如果不是手机号就直接回传
        [self hiddenAlterView:al delay:0];
        if(block){
            block(str,pcode);
        }
    }];
    
    [alter setSelectPcode:^{
        if(SelectCountry){
            SelectCountry(al);
        }
        
    }];
    
    [view addSubview:alter];
    
    [self showAlterView:alter isKeyboard:YES delay:0 AutoHiddenTime:0];
    return alter;
}


- (UIView *)showTextViewAlter:(NSString *)titleString  PlaceHodler:(NSString *)place DoneBtnText:(NSString *)doneText CancleText:(NSString *)cancleText Text:(NSString *)text :(void(^)(NSString * selectedName)) block{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    UIView * view = [self getBgView];
    RBInvitationAlter * alter = [[RBInvitationAlter alloc] initWithFrame:CGRectMake(ASX(30), 100, ASX(260), 200)];
    alter.placeHodler = place;
    alter.title = titleString;
    alter.text = [text isKindOfClass:[NSString class]] ? text : @"";
    if (doneText != nil) {
        alter.doneBtnText = doneText;
    }
    if (cancleText != nil) {
        alter.cancleBtnText = cancleText;
    }
    __weak RBInvitationAlter * al = alter;
    [alter setDoneAction:^(NSString * str ) {
        //如果不是手机号就直接回传
        [self hiddenAlterView:al delay:0];
        if(block){
            block(str);
        }
        
    }];
    [view addSubview:alter];
    [self showAlterView:alter isKeyboard:YES delay:0 AutoHiddenTime:0];
    return alter;
}

- (UIView *)showAlterWithView:(RBBaseAlterView *)alterView ButtonItem:(NSArray <NSString *> *) items Block:(void(^)(int index)) block{
    UIView * view = [self getBgView];
    __weak UIView * weakAlter = alterView;

    [alterView setClickActionBlock:^(int index){
        [self hiddenAlterView:weakAlter delay:0];
        if(block){
            block(index);
        }
    }];
    [alterView setBottomItems:items];
    [view addSubview:alterView];
    [self showAlterView:alterView isKeyboard:YES delay:0 AutoHiddenTime:0];
    
    return alterView;
}

#pragma mark - action: 修改昵称
- (UIView *)showUpdateNickName:(NSString *)currentName title:(NSString *)title isPhone:(BOOL)isPhoneTxt EndAlter:(void(^)(NSString * selectedName)) block{
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    UIView * view = [self getBgView];
    
    float height = 180;
    RBNikeNameAlter * alter = [[RBNikeNameAlter alloc] initWithFrame:CGRectMake((view.frame.size.width - ASX(260))/2 , 100, ASX(260), ASX(height))];
    if (title&&title.length>0) {
        alter.title = [NSString stringWithFormat:@"%@",title];
    }
    
    [alter setCurrentName:currentName];
    __weak RBNikeNameAlter * al = alter;
    if (isPhoneTxt) {
        al.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    [alter setDoneAction:^(NSString * str ,RBNikeNameAlterClickType type) {
        if (type == RBNikeNameAlterClickTypeMakeSure) {
            if(block){
                block(str);
            }
        }
        [self hiddenAlterView:al delay:0];
    }];
    
    [view addSubview:alter];
    [self showAlterView:alter isKeyboard:YES delay:0 AutoHiddenTime:0];
    
    return alter;
}
- (UIView *)showSelectGrades:(NSUInteger)gradesIndex ShowGradess:(NSArray *)allGrades :(void(^)(NSUInteger gradesIndex)) selectBlock{
    UIView * bgView = [self getBgView];

    float height = 240;

    ZYSelectGradeView * actionselect = [[ZYSelectGradeView alloc] initWithFrame:CGRectMake(0, self.view.bottom , self.view.width, height)];
    [actionselect setSelectGrade:gradesIndex];
    __weak  ZYSelectGradeView * weakselecter = actionselect;
    actionselect.showGrades = allGrades;
    __weak typeof(self) weakSelf = self;
    [actionselect setSelectGradeBlock:^(NSUInteger index) {
        [weakSelf hiddenAlterView:weakselecter delay:0];
        if (selectBlock) {
            selectBlock(index);
        }
    }];
    [bgView addSubview:actionselect];
    [self showAlterView:actionselect IsCenter:NO isKeyboard:NO delay:0 AutoHiddenTime:0];
    return actionselect;

}

- (UIView *)showSelectMinutes:(NSUInteger)minutes ShowMinues:(NSArray *)showMinues :(void(^)(NSUInteger  selectMintes)) selectBlock{
    UIView * bgView = [self getBgView];
    
    float height = 240;
    
    ZYSelectMinutesView * actionselect = [[ZYSelectMinutesView alloc] initWithFrame:CGRectMake(0, self.view.bottom , self.view.width, height)];
    __weak  ZYSelectMinutesView * weakselecter = actionselect;
    actionselect.showMinutes = showMinues;
    [actionselect setSelectMinutes:minutes];
    [actionselect setSelectMintusBlock:^(NSUInteger selectValue) {
        [self hiddenAlterView:weakselecter delay:0];
        if(selectBlock){
            selectBlock(selectValue);
        }
    }];
    [bgView addSubview:actionselect];
    [self showAlterView:actionselect IsCenter:NO isKeyboard:NO delay:0 AutoHiddenTime:0];
    return actionselect;
    
}

- (UIView *)showSelectDateString:(NSString *)selectDateString DateFormat:(NSString *)format :(void(^)(NSDate * selectDate)) selectBlock{
    __block NSDateFormatter * formoat = [[NSDateFormatter alloc] init];
    [formoat setDateFormat:format];
    formoat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    [formoat setTimeZone:localzone];
    
    NSDate * selectDate = [formoat dateFromString:selectDateString];
    
    UIView * bgView = [self getBgView];
    
    float height = 240;
    
    ZYSelectDateView * actionselect = [[ZYSelectDateView alloc] initWithFrame:CGRectMake(0, self.view.bottom , self.view.width, height)];
    __weak  ZYSelectDateView * weakselecter = actionselect;
    [actionselect setSelectDate:selectDate];
    [actionselect setSelectDateBlock:^(NSDate * date) {
        [self hiddenAlterView:weakselecter delay:0];
        if (selectBlock) {
            selectBlock(date);
        }
    }];
    
    [bgView addSubview:actionselect];
    [self showAlterView:actionselect IsCenter:NO isKeyboard:NO delay:0 AutoHiddenTime:0];
    return actionselect;
}

- (UIView *)showSelectTime:(NSString *)startTime EndTime:(NSString *)endTime :(void(^)(NSString * s1, NSString * s2)) selectBlock{
    UIView * bgView = [self getBgView];
    
    float height = 240;
    
    ZYSelectTimerView * actionselect = [[ZYSelectTimerView alloc] initWithFrame:CGRectMake(0, self.view.bottom , self.view.width, height)];
    __weak  ZYSelectTimerView * weakselecter = actionselect;
    [actionselect setSelectTime:startTime :endTime];
    [actionselect setSelectTimeBlock:^(NSString * s1, NSString * s2) {
        [self hiddenAlterView:weakselecter delay:0];
        if(selectBlock){
            selectBlock(s1,s2);
        }
    }];
    
    [bgView addSubview:actionselect];
    [self showAlterView:actionselect IsCenter:NO isKeyboard:NO delay:0 AutoHiddenTime:0];
    return actionselect;
    
}

#pragma mark - action: 修改头像--actionsheet
- (UIView *)showSheetWithItems:(NSArray *)array DestructiveItem:(NSString *)destrucivieTitle CancelTitle:(NSString *)cancelTitle WithBlock:(void(^)(int selectIndex)) selectBlock{
    CGFloat btnHeight = 45;
    //1.创建背景视图
    RBAlterBgView * bgView = [self getBgView];
    //2.计算需要提醒的按钮的高度
    float desheiht = [destrucivieTitle length] > 0 ? btnHeight : 0;
    //3.计算普通按钮的高度
    float height = 10 + btnHeight + array.count * btnHeight + desheiht;
    //4.创建点击回调视图
    RBActionSheet * actionSheet = [[RBActionSheet alloc] initWithFrame:CGRectMake(0, self.view.bottom , self.view.width, height ) WithItems:array DestructiveItem:destrucivieTitle CancleItem:cancelTitle];
    __weak  RBActionSheet * weaksheet = actionSheet;
    [actionSheet setSelectActionIndexBlock:^(int index) {
        [self hiddenAlterView:weaksheet delay:0];
        if(index >= 0){
            selectBlock(index);
        }
    }];
    [bgView addSubview:actionSheet];
    
    //5.设置 view 的不可用点击的 frame
    bgView.disEnableFrame = CGRectMake(0, bgView.bottom - height, self.view.width, height + 100 );
    [bgView setTouchAction:^{
        [self hiddenAlterView:weaksheet delay:0];
    }];
    
    [self showAlterView:actionSheet IsCenter:NO isKeyboard:NO delay:0 AutoHiddenTime:0];
    return actionSheet;
}

- (UIView *)showSheetWithItems:(NSArray *)array Images:(NSArray*)images Title:(NSString*)title CancelTitle:(NSString *)cancelTitle WithBlock:(void(^)(int selectIndex)) selectBlock{
    CGFloat btnHeight = 55;
    //1.创建背景视图
    RBAlterBgView * bgView = [self getBgView];
    //2.计算需要提醒的按钮的高度
    float desheiht = [title length] > 0 ? 40 : 0;
    //3.计算普通按钮的高度
    float height = btnHeight + array.count * btnHeight + desheiht;
    //4.创建点击回调视图
    RBActionSheet * actionSheet = [[RBActionSheet alloc] initWithFrame:CGRectMake(0, self.view.bottom , self.view.width, height ) WithItems:array Images:images Title:title CancleItem:cancelTitle];
    __weak  RBActionSheet * weaksheet = actionSheet;
    [actionSheet setSelectActionIndexBlock:^(int index) {
        [self hiddenAlterView:weaksheet delay:0];
        if(index >= 0){
            selectBlock(index);
        }
    }];
    [bgView addSubview:actionSheet];
    
    //5.设置 view 的不可用点击的 frame
    bgView.disEnableFrame = CGRectMake(0, bgView.bottom - height, self.view.width, height + 100 );
    [bgView setTouchAction:^{
        [self hiddenAlterView:weaksheet delay:0];
    }];
    
    [self showAlterView:actionSheet IsCenter:NO isKeyboard:NO delay:0 AutoHiddenTime:0];
    return actionSheet;
}
#pragma mark - handle method

//获得屏幕图像
- (UIImage *)imageFromView: (UIView *) theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}




#define AnimailDuration .1



@end
