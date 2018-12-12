//
// Created by kieran on 2018/2/26.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import "RBBookBuyViewController.h"
#import "RBBookSourceModle.h"
#import "PDHtmlViewController.h"
#import "RBBookViewModle.h"

@interface RBBookBuyViewController()
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UIView *headView;
@property(nonatomic, strong) UILabel *lookInfoLabel;
@property(nonatomic, strong) UILabel *titleLable;
@property(nonatomic, strong) UIImageView *detailIcon;
@property(nonatomic, strong) UITextView *bookDetailView;
@property(nonatomic, strong) UIButton *buyButton;

@end

@implementation RBBookBuyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.headImageView.hidden = NO;
    self.headView.hidden = NO;
    self.titleLable.hidden = NO;
    self.lookInfoLabel.hidden = NO;
    self.detailIcon.hidden = NO;
    self.bookDetailView.hidden = NO;

    self.automaticallyAdjustsScrollViewInsets = YES;

    
    if (_bookId) {
        [MitLoadingView showWithStatus:@"loading"];
        @weakify(self)
        [RBBookViewModle fetrueBookDetail:_bookId Result:^(RBBookSourceModle * modle, NSError *error ) {
            @strongify(self)
            if (error) {
                [MitLoadingView showErrorWithStatus:error.localizedDescription afterTime:.1];
                return ;
            }
            [MitLoadingView dismissDelay:.1];
            self.modle = modle;
            [self updateModle];
        }];
    }
    [self initialNav];
    [self updateModle];

}

- (void)updateModle{
    self.titleLable.text = _modle.name;
    self.lookInfoLabel.text = [NSString stringWithFormat:@"%d아이가 본것들",[_modle.babysNums intValue]];
    self.bookDetailView.attributedText = [self formatDetailString: _modle.des];
    [self.headImageView setImageWithURL:[NSURL URLWithString:_modle.pictureBig] placeholder:[UIImage imageNamed:@"ic_picturebooks_details_lack"]];
  
    
    if (![_modle.ableBuy boolValue]) {
        [self.bookDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.buyButton.mas_top).offset(SX(30));
        }];
        self.buyButton.hidden = YES;
    }else{
        [self.bookDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.buyButton.mas_top).offset(-SX(18));
        }];
        self.buyButton.hidden = NO;
    }
    
    if ([_modle.des length] == 0) {
        self.detailIcon.hidden = YES;
    }else{
        self.detailIcon.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    NSLog(@"%@ isFree", [self class]);
}

- (void)setupBack{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backBtn];
    @weakify(self)
    [backBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(50);
        make.top.mas_equalTo(STATE_HEIGHT);
    }];
    [backBtn setImage:[UIImage imageNamed:@"btn_video_back_p"] forState:UIControlStateNormal];
}

#pragma mark 懒加载 buyButton
- (UIButton *)buyButton{
    if (!_buyButton){
        UIButton * view = [[UIButton alloc] init];
        view.backgroundColor = mRGBToColor(0x8ec31f);
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont boldSystemFontOfSize:SX(18)];
        [view addTarget:self action:@selector(buyBookAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-SC_FOODER_BOTTON);
            make.width.equalTo(self.view.mas_width);
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.equalTo(@(SX(50)));
        }];
        [view setTitle:NSLocalizedString(@"book_buy", @"购买本书") forState:UIControlStateNormal];

        _buyButton = view;
    }
    return _buyButton;
}

- (void)buyBookAction:(id)buyBookAction {
    if ([_modle.buyLink mStrLength] > 0) {
        PDHtmlViewController * v = [PDHtmlViewController new];
        v.urlString = _modle.buyLink;
        [self.navigationController pushViewController:v animated:YES];
    }else{
        [MitLoadingView showErrorWithStatus:@"购买信息错误"];
    }
}

#pragma mark 懒加载 bookDetailView
- (UITextView *)bookDetailView{
    if (!_bookDetailView){
        UITextView * view = [[UITextView alloc] init];
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.editable = NO;
        view.textColor = mRGBToColor(0x787878);
        view.font = [UIFont systemFontOfSize:SX(14)];
        view.backgroundColor = [UIColor clearColor];
        if([view respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)])
            if (@available(iOS 11.0, *)) {
                view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        [self.view addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailIcon.mas_bottom).offset(SX(18));
            make.bottom.equalTo(self.buyButton.mas_top).offset(-SX(18));
            make.left.equalTo(@(SX(15)));
            make.right.equalTo(self.view.mas_right).offset(-SX(15));
        }];

        _bookDetailView = view;
    }
    return _bookDetailView;
}


#pragma mark 懒加载 detailIcon
- (UIImageView *)detailIcon{
    if (!_detailIcon){
        UIImageView * view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.image = [[UIImage imageNamed:@"bg_details"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 28, 2, 28)];
        [self.view addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headView.mas_bottom).offset(SX(21));
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(@(SX(140)));
            make.height.equalTo(@(23.5));
        }];


        UILabel * lable = [UILabel new];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:14];
        [view addSubview:lable];
        lable.text = NSLocalizedString(@"book_detail", nil);

        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.centerY.equalTo(view.mas_centerY);
        }];

        _detailIcon = view;
    }
    return _detailIcon;
}


#pragma mark - 初始化导航栏
- (void)initialNav{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupBack];

}

#pragma mark 懒加载 lookInfoLabel
- (UILabel *)lookInfoLabel{
    if (!_lookInfoLabel){

        UIView * lookBg = [UIView new];
        lookBg.layer.cornerRadius = SX(10);
        lookBg.clipsToBounds = YES;
        lookBg.backgroundColor = mRGBToColor(0xf4f6f8);
        [self.view addSubview:lookBg];

        UIImageView * lookIcon = [[UIImageView alloc] init];
        lookIcon.image = [UIImage imageNamed:@"ic_eyes"];
        [self.view addSubview:lookIcon];

        [lookIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(SX(23));
            make.top.equalTo(self.titleLable.mas_bottom).offset(SX(15));
            make.size.mas_equalTo(CGSizeMake(SX(13), SX(9.5)));
        }];

        UILabel * view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:SX(12)];
        view.textColor = mRGBToColor(0x787878);
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lookIcon.mas_centerY);
            make.left.equalTo(lookIcon.mas_right).offset(SX(5));
        }];

        [lookBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lookIcon.mas_left).offset(-SX(8));
            make.centerY.equalTo(lookIcon.mas_centerY);
            make.right.equalTo(view.mas_right).offset(SX(8));
            make.height.equalTo(@(SX(20)));
        }];

        _lookInfoLabel = view;
    }
    return _lookInfoLabel;
}


#pragma mark 懒加载 headView
- (UIView *)headView{
    if (!_headView){
        UIView * view = [[UIView alloc] init];
        view.layer.cornerRadius = SX(18);
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImageView.mas_bottom).offset(-SX(20));
            make.width.equalTo(self.view.mas_width);
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(SX(83));
        }];

        UIView * lineView = [UIView new];
        lineView.backgroundColor = mRGBToColor(0xeaebed);
        [self.view addSubview:lineView];

        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0.5));
            make.left.mas_equalTo(SX(15));
            make.right.mas_equalTo(self.view.mas_right).offset(-SX(15));
            make.bottom.equalTo(view.mas_bottom);
        }];

        _headView = view;
    }
    return _headView;
}


#pragma mark 懒加载 titleView
- (UILabel *)titleLable{
    if (!_titleLable){
        UILabel * view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:SX(18)];
        view.textColor = [UIColor blackColor];
        view.backgroundColor = [UIColor clearColor];
        _titleLable = view;

        [self.view addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headView.mas_top).offset(SX(20));
            make.left.equalTo(@(SX(15)));
        }];

    }
    return _titleLable;
}


#pragma mark 懒加载 headImageView
- (UIImageView *)headImageView{
    if (!_headImageView){
        UIImageView * view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.clipsToBounds = YES;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.image = [UIImage imageNamed:@"story_bng_fox"];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.width.equalTo(self.view.mas_width);
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.equalTo(@(SX(230) + STATE_HEIGHT));
        }];

        _headImageView = view;
    }
    return _headImageView;
}


#pragma mark - 数据
- (void)setModle:(RBBookSourceModle *)modle {
    _modle = modle;
}

- (NSAttributedString *)formatDetailString:(NSString *)string{
    if ([string mStrLength] == 0)
        return nil;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = SX(6);

    NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:SX(14)],
            NSForegroundColorAttributeName: mRGBToColor(0x787878),
            NSParagraphStyleAttributeName:paragraphStyle
    };
    return  [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

@end
