//
//  RBBabyMessageViewController.m
//  Pudding
//
//  Created by baxiang on 16/10/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
#import "PDBabyDevelopmentController.h"
#import "PDBabyTextFiled.h"
#import "MitPickerView.h"
#import "PDBindPuddingSucessAnimailView.h"
#import "AppDelegate.h"
#import "PDBabyModel.h"
#import "NSDate+RBExtension.h"
#import "UIViewController+SelectImage.h"
#import "RBUserDataHandle+Device.h"
#import "UIImage+YYAdd.h"
#import "NSDate+YYAdd.h"
#import "UIGestureRecognizer+YYAdd.h"
#import "RBHomePageViewController+PDSideView.h"
#import "RBUserDataHandle+Device.h"
#import "PDBaseViewController.h"
#import "RBMethodShot.h"
#import "RBNetworkHandle.h"
#import "RBNetHeader.h"
#import "ZYSource.h"
#import "MitLoadingView.h"
#import "RBDeviceModel.h"
#import "RBError.h"
#import "RBLog.h"


@interface PDBabyDevelopmentController ()<UITextFieldDelegate>
@property (nonatomic,weak)PDBabyTextFiled *nameFiled;
@property (nonatomic,weak)PDBabyTextFiled *ageFiled;
@property (nonatomic,weak) UIButton *developBtn;
@property (nonatomic,weak)UIButton *maleBtn;
@property (nonatomic,weak)UIButton *femaleBtn;
@property (nonatomic,weak)UIButton *selectBtn;
@property (nonatomic, strong) MitPickerView * pickerView;
@property (nonatomic, strong) PDBabyAdviceModel *babyAdviceModel;
@property (nonatomic,weak) UITextView *developView;
@property (nonatomic,weak) UIImageView *genderIcon;
@property (nonatomic,weak)UIImageView *headIcon;
@end

@implementation PDBabyDevelopmentController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavView];
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor whiteColor];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAV_HEIGHT);
        make.bottom.left.right.mas_equalTo(0);
    }];
    scrollView.bounces = NO;
    UIView *containerView = [UIView new];
    [scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIImageView *headBackView = [UIImageView new];
    [containerView addSubview:headBackView];
    headBackView.userInteractionEnabled = YES;
    headBackView.image = [UIImage imageNamed:@"baby_bg"];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    UIImageView *headIcon = [UIImageView new];
    [headBackView addSubview:headIcon];
    headIcon.image = [UIImage imageNamed:@"ic_home_head"];
    [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2);
        make.centerX.mas_equalTo(headBackView.mas_centerX);
        make.width.height.mas_equalTo(55);
    }];
    headIcon.layer.masksToBounds = YES;
    headIcon.layer.cornerRadius = 55/2.0f;
    headIcon.userInteractionEnabled = YES;
    self.headIcon = headIcon;
    
    @weakify(self);
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        [self modifyHeaderImg];
    }];
    [headIcon addGestureRecognizer:iconTap];
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headBackView addSubview:headBtn];
    headBtn.adjustsImageWhenHighlighted = NO;
    [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(headIcon.mas_bottom).offset(20);
    }];
    [headBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headBtn setTitle:NSLocalizedString( @"modify_baby_head_portrait", nil) forState:UIControlStateNormal];
    [headBtn setImage:[UIImage imageNamed:@"icon_write"] forState:UIControlStateNormal];
    headBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -headBtn.imageView.frame.size.width, 0, headBtn.imageView.frame.size.width);
    headBtn.imageEdgeInsets = UIEdgeInsetsMake(0, headBtn.titleLabel.frame.size.width, 0, -(headBtn.titleLabel.frame.size.width+5));
    [headBtn addTarget:self action:@selector(modifyHeaderImg) forControlEvents:UIControlEventTouchUpInside];
    UILabel *nameLabel = [UILabel new];
    [containerView addSubview:nameLabel];
    nameLabel.text = NSLocalizedString( @"baby_name", nil);
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = UIColorHex(0xb9bcc0);
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headBackView.mas_bottom).offset(15);
        make.left.mas_equalTo(35);
    }];
    PDBabyTextFiled *nameFiled = [PDBabyTextFiled new];
    [containerView addSubview:nameFiled];
    nameFiled.textColor = UIColorHex(0x505a66);
    nameFiled.font = [UIFont systemFontOfSize:15];
    [nameFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.right.mas_equalTo(-35);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(30);
    }];
    nameFiled.attributedPlaceholder =[[NSAttributedString alloc] initWithString:R.say_baby_name
                                                                     attributes:@{
                                                                                  NSForegroundColorAttributeName: UIColorHex(0xb5b8bc),
                                                                                  NSFontAttributeName : [UIFont systemFontOfSize:15]
                                                                                  }];
    [nameFiled addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    self.nameFiled = nameFiled;
    
    UILabel *ageLabel = [UILabel new];
    [containerView addSubview:ageLabel];
    ageLabel.text = NSLocalizedString( @"baby_age", nil);
    ageLabel.font = [UIFont systemFontOfSize:15];
    ageLabel.textColor = UIColorHex(0xb9bcc0);
    [ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameFiled.mas_bottom).offset(20);
        make.left.mas_equalTo(nameLabel.mas_left);
    }];
    PDBabyTextFiled *ageFiled = [PDBabyTextFiled new];
    ageFiled.delegate = self;
    [containerView addSubview:ageFiled];
    ageFiled.textColor = UIColorHex(0x505a66);
    ageFiled.font = [UIFont systemFontOfSize:15];
    [ageFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.right.mas_equalTo(nameFiled.mas_right);
        make.top.mas_equalTo(ageLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(30);
    }];
    [ageFiled addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    ageFiled.attributedPlaceholder =[[NSAttributedString alloc] initWithString:NSLocalizedString( @"write_baby_brithday", nil)
                                                                    attributes:@{
                                                                                 NSForegroundColorAttributeName: UIColorHex(0xb5b8bc),
                                                                                 NSFontAttributeName : [UIFont systemFontOfSize:15]
                                                                                 }];
    
    self.ageFiled = ageFiled;
    self.ageFiled.inputView = self.pickerView;
    UILabel *genderLabel = [UILabel new];
    [containerView addSubview:genderLabel];
    genderLabel.text = NSLocalizedString( @"baby_gender", nil);
    genderLabel.font = [UIFont systemFontOfSize:15];
    genderLabel.textColor = UIColorHex(0xb9bcc0);
    [genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ageFiled.mas_bottom).offset(20);
        make.left.mas_equalTo(nameLabel.mas_left);
    }];
    
    UIButton *maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [containerView addSubview:maleBtn];
    [maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(-12.5);
        make.height.mas_equalTo(35);
        make.left.mas_equalTo(nameLabel.mas_left);
        make.top.mas_equalTo(genderLabel.mas_bottom).offset(15);
    }];
    [maleBtn setTitle:NSLocalizedString( @"princeling", nil) forState:UIControlStateNormal];
    [maleBtn setImage:[UIImage imageNamed:@"growadvice_icon_boy_unselect"] forState:UIControlStateNormal];
    [maleBtn setImage:[UIImage imageNamed:@"growadvice_icon_boy"] forState:UIControlStateSelected];
    [maleBtn setTitleColor:mRGBToColor(0x29c6ff) forState:UIControlStateSelected];
    [maleBtn setTitleColor:mRGBToColor(0xb9bcc0) forState:UIControlStateNormal];
    [maleBtn setBackgroundImage:[UIImage imageNamed:@"growadvice_btn_unselect"] forState:UIControlStateNormal];
    [maleBtn setBackgroundImage:[UIImage imageNamed:@"growadvice_btn_boy_select"] forState:UIControlStateSelected];
    [maleBtn addTarget:self action:@selector(genderSelectHandle:) forControlEvents:UIControlEventTouchUpInside];
    maleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.maleBtn = maleBtn;
    
    UIButton *femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [containerView addSubview:femaleBtn];
    femaleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(12.5);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(nameFiled.mas_right);
        make.top.mas_equalTo(maleBtn.mas_top);
    }];
    [femaleBtn setTitle:NSLocalizedString( @"the_little_princess", nil) forState:UIControlStateNormal];
    [femaleBtn setImage:[UIImage imageNamed:@"growadvice_icon_girl_unselect"] forState:UIControlStateNormal];
    [femaleBtn setImage:[UIImage imageNamed:@"growadvice_icon_girl"] forState:UIControlStateSelected];
    [femaleBtn setTitleColor:mRGBToColor(0xff8c99) forState:UIControlStateSelected];
    [femaleBtn setTitleColor:mRGBToColor(0xb9bcc0) forState:UIControlStateNormal];
    [femaleBtn setBackgroundImage:[UIImage imageNamed:@"growadvice_btn_unselect"] forState:UIControlStateNormal];
    [femaleBtn setBackgroundImage:[UIImage imageNamed:@"growadvice_btn_girl_select"]forState:UIControlStateSelected];
    self.femaleBtn = femaleBtn;
    [femaleBtn addTarget:self action:@selector(genderSelectHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextView *developView = [UITextView new];
    [containerView addSubview:developView];
    developView.backgroundColor = [UIColor whiteColor];
    developView.layer.masksToBounds = YES;
    developView.layer.cornerRadius = 15;
    developView.layer.borderColor = [UIColorHex(0xd6d9dc) CGColor];
    developView.layer.borderWidth = 1;
    [developView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.right.mas_equalTo(nameFiled.mas_right);
        make.height.mas_equalTo(167);
        make.top.mas_equalTo(maleBtn.mas_bottom).offset(20);
    }];
    
    developView.textContainerInset = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
    developView.editable = NO;
    self.developView = developView;
    
    UIButton *developBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [containerView addSubview:developBtn];
    [developBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.right.mas_equalTo(nameFiled.mas_right);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(developView.mas_bottom).offset(20);
        
    }];
    developBtn.layer.masksToBounds = YES;
    developBtn.layer.cornerRadius = 20;
    [developBtn setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xd3d6db)] forState:UIControlStateDisabled];
    [developBtn setBackgroundImage:[UIImage imageWithColor:PDMainColor] forState:UIControlStateNormal];
    [developBtn setTitle:NSLocalizedString( @"finnish_", nil) forState:UIControlStateNormal];
    [developBtn addTarget:self action:@selector(createDevelopAdvice) forControlEvents:UIControlEventTouchUpInside];
    [developBtn setEnabled:NO];
    self.developBtn = developBtn;
    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    skipBtn.hidden = YES;
    [containerView addSubview:skipBtn];
    [skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.right.mas_equalTo(nameFiled.mas_right);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(developBtn.mas_bottom).offset(15);
    }];
    if (self.configType != PDAddPuddingTypeUpdateData) {
        NSMutableAttributedString *skipStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString( @"click_skip", nil)];
        [skipStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, skipStr.length)];
        [skipStr addAttribute:NSForegroundColorAttributeName value:UIColorHex(0xb9b9b9) range:NSMakeRange(0, skipStr.length)];
        [skipStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, skipStr.length)];
        [skipBtn setAttributedTitle:skipStr forState:UIControlStateNormal];
        [skipBtn addTarget:self action:@selector(skipHandle) forControlEvents:UIControlEventTouchUpInside];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(skipBtn.mas_bottom).offset(10);
        }];
    }else{
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(developBtn.mas_bottom).offset(10);
        }];
    }
    
    NSData *babyData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"baby" withExtension:@"json"]];
    self.babyAdviceModel = [PDBabyAdviceModel modelWithJSON:babyData];
    UIImageView *genderIcon = [UIImageView  new];
    [self.view addSubview:genderIcon];
    self.genderIcon = genderIcon;
    genderIcon.image = [UIImage imageNamed:@"bookmarks_boy"];
    [genderIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(developView.mas_right).offset(-15);
        make.top.mas_equalTo(developView.mas_top);
        make.height.mas_equalTo(genderIcon.image.size.height);
        make.width.mas_equalTo(genderIcon.image.size.width);
    }];
    
    if (self.configType !=PDAddPuddingTypeUpdateData&&[RBDataHandle.currentDevice isPuddingPlus]==NO) {
        PDBindPuddingSucessAnimailView *animailView = [[PDBindPuddingSucessAnimailView alloc] initWithFrame:CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT)];
        [animailView setSendBindPuddingCmd:^(id sender) {
            [RBNetworkHandle bindNewRooboWelcome:^(id res) {
            }];
        }];
        [self.view addSubview:animailView];
        [animailView beginPlayAnimail];
    }
    [self loadBabyInfoData];
    
}

-(void)setupNavView{
    
    UIView *navView = [UIView new];
    [self.view addSubview:navView];
    navView.backgroundColor = mRGBToColor(0x3EBDFF);
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(NAV_HEIGHT);
    }];
    
    UILabel *titleLabel = [UILabel new];
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(navView.mas_centerX);
        make.height.mas_equalTo(44);
    }];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString( @"baby_message", nil);
    
    if (self.configType ==PDAddPuddingTypeUpdateData) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [navView addSubview:backBtn];
        [backBtn setImage:[UIImage imageNamed:@"icon_white_back"] forState:UIControlStateNormal];
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(44);
            make.bottom.mas_equalTo(0);
        }];
        [backBtn addTarget:self action:@selector(backHandle) forControlEvents:UIControlEventTouchUpInside];
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)backHandle{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
-(void)loadBabyData{
    if (self.date&&self.date.length>0) {
        [self.ageFiled setText:[NSString stringWithFormat:@"%@",self.date]];
    }
    self.selectBtn = self.maleBtn;
    if (self.sex&&[self.sex isEqualToString:@"girl"]) {
        self.selectBtn = self.femaleBtn;
        self.genderIcon.image = [UIImage imageNamed:@"bookmarks_girl"];
    }
    [ self.selectBtn setSelected:YES];
    if (self.name&&self.name.length>0) {
        self.nameFiled.text = [NSString stringWithFormat:@"%@",self.name];
    }
    
    [self createBabyDevelop:self.nameFiled.text date:self.ageFiled.text];
    [self.headIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.img]] placeholder:[UIImage imageNamed:@"ic_home_head"]];
}
- (void)loadBabyInfoData{
    @weakify(self)

     [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    [RBNetworkHandle getBabyBlock:^(id res) {
        @strongify(self)
         [MitLoadingView dismiss];
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            NSDictionary * babyInfo = [[res objectForKey:@"data"] firstObject];
            self.name = [babyInfo objectForKey:@"nickname"];
            self.date = [babyInfo objectForKey:@"birthday"];
            self.sex = [babyInfo objectForKey:@"sex"];
            self.img = [babyInfo objectForKey:@"img"];
            RBDeviceModel *deviceModel   = [RBDataHandle currentDevice];
            PDGrowplan *growInfo  = deviceModel.growplan;
            growInfo.nickname = [babyInfo objectForKey:@"nickname"];
            growInfo.birthday = [babyInfo objectForKey:@"birthday"];
            growInfo.sex = [babyInfo objectForKey:@"sex"];
            growInfo.img = [babyInfo objectForKey:@"img"];
            [RBDataHandle updateDeviceDetail:deviceModel];
            [self loadBabyData];
            
        }else{
           [MitLoadingView showErrorWithStatus:NSLocalizedString( @"loading_fail", nil)];
        }
    }];

}
-(MitPickerView *)pickerView{
    if (!_pickerView) {
        MitPickerView * vi = [[MitPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 260)];
        vi.backgroundColor = [UIColor whiteColor];
        vi.normalColor = mRGBToColor(0xb5b8bc);
        vi.selectedColor = mRGBToColor(0x00aceb);
        __weak typeof(self) weakself = self;
        vi.dateMsg= ^(NSString * dateString){
            weakself.ageFiled.text = dateString;
            
        };
        vi.cancelBlock = ^(){
            [weakself.view endEditing:YES];
        };
        vi.makeSureBlock = ^(NSString *str){
            if (str.length>0) {
                weakself.ageFiled.text = str;
                [self textFieldDidChange:weakself.ageFiled];
            }
            [weakself.view endEditing:YES];
        };
        _pickerView  = vi;
    }
    
    return _pickerView;
}
-(void)genderSelectHandle:(UIButton*)btn{
    if (btn!=self.selectBtn) {
        [self.selectBtn setSelected:NO];
        [btn setSelected:YES];
        self.selectBtn = btn;
        [self textFieldDidChange:nil];
    }
    if (self.selectBtn == _femaleBtn) {
        self.genderIcon.image = [UIImage imageNamed:@"bookmarks_girl"];
    }else{
        self.genderIcon.image = [UIImage imageNamed:@"bookmarks_boy"];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.ageFiled&&self.ageFiled.text>0) {
        _pickerView.selectedDateString =self.ageFiled.text;
    }
    return YES;
}


-(void)textFieldDidChange :(UITextField *)textField{
    
    if (self.nameFiled.markedTextRange == nil &&[self.nameFiled.text length]>7) {
        self.nameFiled.text = [NSString stringWithFormat:@"%@",[textField.text substringToIndex:7]];
    }
    if (self.nameFiled.text.length>0&&self.ageFiled.text.length>0) {
        [self createBabyDevelop:self.nameFiled.text date:self.ageFiled.text];
        [self.developBtn setEnabled:YES];
    }else{
        [self.developBtn setEnabled:NO];
    }
}
-(void)createBabyDevelop:(NSString*) babyNameStr date:(NSString*) babyDateStr{
    NSInteger month = 0;
    if (babyDateStr&&babyDateStr.length>0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *babyDate = [dateFormatter dateFromString:babyDateStr];
        NSInteger  babyYear= babyDate.year;
        NSInteger babyMonth = babyDate.month;
        NSDate *currData = [NSDate convertDateToLocalTime:[NSDate date]];
        NSInteger currYear = currData.year;
        NSInteger currMonth = currData.month;
        month = (currYear-babyYear)*12+(currMonth-babyMonth);
        if (babyYear==currYear&&babyMonth==currMonth) {
            month = 1;
        }else if (month>73){
            month = 73;
        }
    }
    NSInteger age  =[[self.babyAdviceModel.age objectForKey:[NSString stringWithFormat:@"%zd",month]] integerValue];
    NSString *advice = [self.babyAdviceModel.advice objectForKey:[NSString stringWithFormat:@"%zd",age]];
    NSString *nickName = babyNameStr;
    if (babyNameStr&&babyNameStr.length>0) {
        if (self.selectBtn == _maleBtn&&![babyNameStr containsString:NSLocalizedString( @"prince", nil)]) {
            nickName = [NSString stringWithFormat:NSLocalizedString( @"little_prince", nil),babyNameStr];
        }else if (self.selectBtn == _femaleBtn&&![babyNameStr containsString:NSLocalizedString( @"princess", nil)]){
            nickName = [NSString stringWithFormat:NSLocalizedString( @"little_princess", nil),babyNameStr];
        }
        nickName = [NSString stringWithFormat:NSLocalizedString( @"stringwithformat_give_lively_baby_some_suggest", nil),nickName];
    }else{
        nickName = [NSString stringWithFormat:@"%@\n",babyNameStr];
    }
    NSString *content = [NSString stringWithFormat:@"%@%@",nickName ,advice];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, nickName.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorHex(0x505a66) range:NSMakeRange(0, nickName.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorHex(0xadb4b8) range:NSMakeRange(nickName.length, advice.length)];
    self.developView.attributedText  = attrStr;
    
}
-(void)createDevelopAdvice{
    NSString *genderStr = @"boy";
    if (self.selectBtn == _femaleBtn) {
        genderStr = @"girl";
    }
    //数据没有修改不请求网络
    if ([self.ageFiled.text isEqualToString:self.date]&&[self.nameFiled.text isEqualToString:self.name]&&[genderStr isEqualToString:self.sex]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    @weakify(self);
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    [RBNetworkHandle bindBabyMsgWithBirthday:self.ageFiled.text Sex:genderStr NickName:self.nameFiled.text Mcid:RBDataHandle.currentDevice.mcid WithBlock:^(id res) {
        
        [MitLoadingView dismiss];
        if(res && [[res mObjectForKey:@"result"] intValue] == 0){
            RBDeviceModel *deviceModel   = [RBDataHandle currentDevice];
            PDGrowplan *growInfo  = deviceModel.growplan;
            growInfo.nickname = self.nameFiled.text;
            growInfo.birthday = self.ageFiled.text;
            growInfo.sex = genderStr;
            [RBDataHandle updateDeviceDetail:deviceModel];
            
            @strongify(self);
            if (self.configType == PDAddPuddingTypeFirstAdd) {
                [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshMainControl" object:nil userInfo:@{@"showLoading":[NSNumber numberWithBool:YES]}];
                NSArray *viewControllers = self.navigationController.viewControllers;
                RBHomePageViewController *rootViewController = [viewControllers mObjectAtIndex:0];
                if ([rootViewController isKindOfClass:[RBHomePageViewController class]]&&rootViewController.show) {
                    [rootViewController sideMenuAction];
                }
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            }
        }else{
            self.view.userInteractionEnabled = YES;
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
    
}
-(void)skipHandle{
    if (self.configType == PDAddPuddingTypeFirstAdd) {
        [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
    }else if (self.configType == PDAddPuddingTypeRootToAdd){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshMainControl" object:nil userInfo:@{@"showLoading":[NSNumber numberWithBool:YES]}];
        NSArray *viewControllers = self.navigationController.viewControllers;
        RBHomePageViewController *rootViewController = [viewControllers mObjectAtIndex:0];
        if ([rootViewController isKindOfClass:[RBHomePageViewController class]]&&rootViewController.show) {
            [rootViewController sideMenuAction];
        }
        [self.navigationController popToRootViewControllerAnimated:NO];

    }
}
-(void)modifyHeaderImg{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [self showSheetWithItems:@[NSLocalizedString( @"photograph", nil),NSLocalizedString( @"picture_album", nil)] DestructiveItem:nil CancelTitle:NSLocalizedString( @"g_cancel", nil) WithBlock:^(int selectIndex) {
        LogError(@"%d",selectIndex);
        if(selectIndex == 0){
            [self showCamera];
            [self editHeadImage];
        }else if(selectIndex == 1){
            [self openPhotoAlbum];
            [self editHeadImage];
        }
    }];
}
- (void)editHeadImage{
    @weakify(self);
    [self  setDoneAction:^(UIImage * image) {
        @strongify(self);
        if(image){
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_editing", nil)];
            [RBNetworkHandle uploadBabyAvatarImage:image withBlock:^(id res) {
                [MitLoadingView dismiss];
                if(res && [[res objectForKey:@"result"] integerValue] == 0){
                    [self.headIcon setImage:image];
                    NSString *imgurl= [[res objectForKey:@"data"] objectForKey:@"imgurl"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshBabyHeadView" object:nil];

                    RBDeviceModel *deviceModel   = [RBDataHandle currentDevice];
                    PDGrowplan *growInfo  = deviceModel.growplan;
                    growInfo.img = imgurl;
                    [RBDataHandle updateDeviceDetail:deviceModel];
                    
                }else{
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
            }];
          
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
