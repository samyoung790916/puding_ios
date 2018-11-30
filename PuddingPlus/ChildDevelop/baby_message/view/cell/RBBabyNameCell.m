//
//  RBBabyNameCell.m
//  PuddingPlus
//
//  Created by kieran on 2018/3/29.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <RBAlterView/UITextField+CircleBg.h>
#import "RBBabyNameCell.h"
#import "RBBabyBtnView.h"
#import "UIViewController+SelectImage.h"

@interface RBBabyNameCell() <UITextFieldDelegate>
@property(nonatomic, strong) UILabel *nameTipLabel;
@property(nonatomic, strong) RBBabyBtnView *nameTextField;
@property(nonatomic, strong) UIButton *userImageBtn;
@end

@implementation RBBabyNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.userImageBtn.hidden = NO;
        self.nameTipLabel.hidden = NO;
        self.nameTextField.hidden = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setBabyName:(NSString *)babyName {
    [self.nameTextField setText:babyName];
}

- (NSString *)babyName {
    return self.nameTextField.text;
}

#pragma mark 懒加载 nameTextField
- (RBBabyBtnView *)nameTextField{
    if (!_nameTextField){
        UITextField * textField = [[UITextField alloc] init];
        textField.font = [UIFont systemFontOfSize:16];
        textField.clipsToBounds = YES;
        textField.delegate = self;
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = mRGBToColor(0x4a4a4a);
        [textField setPlaceholderString:NSLocalizedString(@"input_baby_name", @"填写宝宝姓名")];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.borderStyle = UITextBorderStyleNone;

        RBBabyBtnView * view = [[RBBabyBtnView alloc] initWithFrame:CGRectZero ContentView:textField];
        view.backgroundColor = mRGBToColor(0xf4f6f8);
        view.layer.cornerRadius = 20;
        view.clipsToBounds = YES;
        view.edgeInsets = UIEdgeInsetsMake(3, 20, 3, 20);
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameTipLabel.mas_bottom).offset(10);
            make.height.equalTo(@40);
            make.right.equalTo(self.userImageBtn.mas_left).offset(-20);
            make.left.equalTo(self.mas_left).offset(20);
        }];

        _nameTextField = view;
    }
    return _nameTextField;
}


#pragma mark 懒加载 nameTipLabel
- (UILabel *)nameTipLabel{
    if (!_nameTipLabel){
        UILabel * view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:15];
        view.backgroundColor = [UIColor clearColor];
        view.textColor = mRGBToColor(0x555555);
        view.text = @"사용자 이름";
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.left.equalTo(@40);
        }];
        _nameTipLabel = view;
    }
    return _nameTipLabel;
}

#pragma mark 懒加载 userImageBtn
- (UIButton *)userImageBtn{
    if (!_userImageBtn){
        UIButton * view = [[UIButton alloc] init];
        view.layer.cornerRadius = 35;
        view.layer.masksToBounds = true;
        view.backgroundColor = [UIColor clearColor];
        [view setImage:[UIImage imageNamed:@"ic_information_camera"] forState:UIControlStateNormal];
        [self addSubview:view];
        [view addTarget:self action:@selector(imageBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.right.equalTo(self.mas_right).offset(-20);
            make.width.equalTo(@70);
            make.height.equalTo(@70);
        }];
        _userImageBtn = view;
    }
    return _userImageBtn;
}
- (void)setGrowplan:(PDGrowplan *)growplan{
    _growplan = growplan;
    [_userImageBtn setImageWithURL:[NSURL URLWithString:growplan.img] forState:(UIControlStateNormal) placeholder:[UIImage imageNamed:@"ic_information_camera"]];
}
- (void)imageBtnClick{
    [[self viewController] showSheetWithItems:@[NSLocalizedString( @"photograph", nil),NSLocalizedString( @"picture_album", nil)] DestructiveItem:nil CancelTitle:NSLocalizedString( @"g_cancel", nil) WithBlock:^(int selectIndex) {
        LogError(@"%d",selectIndex);
        if(selectIndex == 0){
            [[self viewController] showCamera];
            [[self viewController] openPhotoAlbum];
        }else if(selectIndex == 1){
            [[self viewController] openPhotoAlbum];
            [[self viewController] openPhotoAlbum];
        }
    }];
    [self doneAction];
}
- (void)doneAction{
    @weakify(self);
    [[self viewController]  setDoneAction:^(UIImage * image) {
        if(image){
            @strongify(self);
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_editing", nil)];
            [RBNetworkHandle uploadBabyAvatarImage:image withBlock:^(id res) {
                [MitLoadingView dismiss];
                if(res && [[res objectForKey:@"result"] integerValue] == 0){
                    [self.userImageBtn setImage:image forState:(UIControlStateNormal)];
                    NSString *imgurl= [[res objectForKey:@"data"] objectForKey:@"imgurl"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshBabyHeadView" object:nil];
                    RBDeviceModel *deviceModel   = [RBDataHandle currentDevice];
                    PDGrowplan *growInfo  = deviceModel.growplan;
                    growInfo.img = imgurl;
                    [RBDataHandle updateDeviceDetail:deviceModel];
                    
                }else{
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
                [self.delegate photoChange];
            }];
        }
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.delegate nameChange:textField.text];
}
@end
