//
//  ChartListViewController.m
//  FWRootChartUI
//
//  Created by 张志微 on 16/10/26.
//  Copyright © 2016年 张志微. All rights reserved.
//

#import "RBChartListViewController.h"
#import "RBClassifyTableViewCell.h"
#import "RBBabyTriangleView.h"
#import "RBBabyMessageViewController.h"
#import "PDBabyPlan.h"
#import "LQRadarChart.h"
#import "PDFeatureDetailsController.h"
#import "PDTimerManager.h"
#import "UIGestureRecognizer+YYAdd.h"
#import "PDInteractViewController.h"
#import "PDMorningCallController.h"
#import "RBBabyNightStoryController.h"
#import "RBClassTableViewController.h"

static NSString *collectIndefiter = @"collectIndefiter";
static NSString *tableIndefiter = @"tableIndefiter";

@interface RBChartListViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,LQRadarChartDelegate,LQRadarChartDataSource>
@property (strong, nonatomic) UIScrollView* scrollView;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIColor *backColor;
@property (nonatomic,weak)  UILabel *stageLab;
@property (nonatomic,weak)  UIView *stageLabBg;
@property (nonatomic,weak)  UILabel *teachTipsLab;
@property (nonatomic,weak)  UIView *teachTipsLabBg;
@property (nonatomic,strong) PDBabyPlan *babyPlan;
@property (nonatomic,weak) LQRadarChart * chart;
@property (nonatomic,weak) UILabel *contentLab;
@property (nonatomic,weak) UILabel *ageLab;
@property (nonatomic,weak) UIImageView *iconImg;
@property (nonatomic,weak) UILabel *nameLab;
@property (nonatomic,weak) UIImageView *topbackView;
@property (nonatomic,weak)  UICollectionView *collectionView;
@property (nonatomic,weak) UIView *developeView;
@property (nonatomic,weak)  UIView* contentView; //scrollView的内容View
@property (nonatomic,weak)UITableView *resTableView;
@property (nonatomic,weak) UIView *polygonView;
@property (nonatomic,strong)NSArray *colorArr;
@property (nonatomic,weak)UIView *featureView;
@property (nonatomic,weak)UIView *tipSepView;
@property (nonatomic,weak)UIView *tipSep2View;
@property (nonatomic,assign) NSInteger autoSrollIndex;
@property (nonatomic,weak)UIButton *joinClassTableBtn;
@property (assign, nonatomic)BOOL isJoined;

@end

@implementation RBChartListViewController{
    UIView *navview;
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorArr = @[mRGBToColor(0xFF8291),mRGBToColor(0xFFAC5A),mRGBToColor(0xFFE420),mRGBToColor(0x8FE531),mRGBToColor(0x5AF0CF),mRGBToColor(0x3CC5F9),mRGBToColor(0xE980FF)];
    [RBStat logEvent:PD_BABY_DEVELOP_DETAIL message:nil];
    [self setupNavView];
//    [self addScrollView];
//    [self mineLayoutSubviews];
    [self fetchBabyPlanData];
    
    [self loadBabyMessage];
}


- (void)dealloc{
   
    
}

#pragma mark - 发展模型

- (void)babydevelopeModel{
    
    BOOL isplus = RBDataHandle.currentDevice.isPuddingPlus;
    @weakify(self)
//    UIView * pointView = (UIView *)^(){
//        @strongify(self)
//        UIView * view = [[UIView alloc] init];
//        view.layer.cornerRadius = SX(2.5);
//        view.backgroundColor = isplus ? mRGBToColor(0x8fc321) : mRGBToColor(0x27bef5);
//        view.clipsToBounds = YES;
//        [self.contentView addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(SX(15)));
//            make.top.equalTo(self.topbackView.mas_bottom).offset(SX(15));
//            make.height.mas_equalTo(SX(12));
//            make.width.mas_equalTo(SX(5));
//        }];
//        return view;
//    }();
//
//    UILabel * title = (UILabel *)^(){
//        UILabel * view = [[UILabel alloc] init];
//        view.font = [UIFont systemFontOfSize:SX(16)];
//        view.textColor = mRGBToColor(0x4A4A4A);
//        [self.contentView addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(pointView.mas_centerY);
//            make.left.equalTo(pointView.mas_right).offset(SX(10));
//        }];
//
//
//        return view;
//    }();
//
//    title.text = NSLocalizedString( @"baby_mental_development_model", nil);

    self.collectionView = (UICollectionView *)^(){
        //单选
        UICollectionViewFlowLayout *flowlayout=[[UICollectionViewFlowLayout alloc] init];
        flowlayout.minimumInteritemSpacing = SX(10);
        flowlayout.minimumLineSpacing =  SX(10);
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *colView =[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        colView.showsHorizontalScrollIndicator = NO;
        colView.delegate = self;
        colView.scrollEnabled = NO;
        colView.backgroundColor = [UIColor clearColor];
        colView.dataSource = self;
        [self.contentView addSubview:colView];
        [colView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectIndefiter];
        [colView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topbackView.mas_bottom).offset(SX(18));
            make.left.mas_equalTo(SX(15));
            make.width.equalTo(self.contentView.mas_width).offset(-SX(30));
            make.height.mas_equalTo(SY(29));
        }];
        [colView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        return colView;
        
    }();
    
    
    
    self.polygonView = (UIView *)^(){
        @strongify(self)
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        return view;
    }();
    
    self.chart  = (LQRadarChart *)^(){
        @strongify(self)

        LQRadarChart * view = [[LQRadarChart alloc]initWithFrame:CGRectZero];
        view.radius = 150 / 3;
        view.delegate = self;
        view.dataSource = self;
        view.minValue = 0;
        view.maxValue = 100;
        [view reloadData];
        [self.polygonView addSubview:view];
        return view;
    }();

    
    
    self.contentLab = (UILabel *)^(){
        @strongify(self)
        UILabel *view = UILabel.new;
        view.numberOfLines = 0;
        view.textColor = mRGBToColor(0x9B9B9B);
        view.font = [UIFont systemFontOfSize:13];
        [self.polygonView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.polygonView.mas_top).offset(5);
            make.left.equalTo(self.chart.mas_right);
            make.right.mas_equalTo(-30);
            make.height.mas_greaterThanOrEqualTo(150);
        }];
        return view;
    }();



    [self.chart mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(5);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(150);
        make.width.mas_equalTo(200);
        make.centerY.mas_equalTo(self.contentLab.mas_centerY);
    }];

    NSArray *modsArray  = self.babyPlan.mod;
    PDBabyPlanMod *mod  = [modsArray objectAtIndex:self.selectIndex];
    self.contentLab.attributedText = [self getContentLableText:mod.features];
    [self.polygonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(SX(15));
        make.left.right.equalTo(@(0));
        make.bottom.equalTo(self.contentLab.mas_bottom);
    }];
    [self tipSep2View];
    
    [self addBottomTableView];

}

- (NSAttributedString *)getContentLableText:(NSString *)string{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 2; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    UIColor * color = mRGBToColor(0x9B9B9B);
    UIFont * font = [UIFont systemFontOfSize:13];
    
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSForegroundColorAttributeName:color,NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:string attributes:dic];

    return attributeStr;
}

#pragma mark - line

- (UIView *)tipSepView{
    if(!_tipSepView){
        UIView * line = [UIView new];
        line.backgroundColor = mRGBToColor(0xe1e7ec);
        [self.contentView insertSubview:line atIndex:0];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(SX(26)));
            make.width.equalTo(@(1));
            make.top.equalTo(self.topbackView.mas_bottom).offset(-SX(10));
            make.bottom.equalTo(self.teachTipsLabBg.mas_bottom).offset(SX(20));
        }];
        
        UIView * sepView = [UIView new];
        sepView.backgroundColor = mRGBToColor(0xeeeeee);
        [self.contentView addSubview:sepView];
        
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.width.equalTo(self.contentView.mas_width);
            make.top.equalTo(line.mas_bottom);
            make.height.equalTo(@(SX(10)));
        }];
        _tipSepView = sepView;
        
    }
    return _tipSepView;
}

- (UIView *)tipSep2View{
    if(!_tipSep2View){
        
        UIView * sepView = [UIView new];
        sepView.backgroundColor = mRGBToColor(0xeeeeee);
        [self.contentView addSubview:sepView];
        
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.width.equalTo(self.contentView.mas_width);
            make.top.equalTo(self.polygonView.mas_bottom).offset(SX(15));
            make.height.equalTo(@(SX(10)));
        }];
        _tipSep2View = sepView;
        
    }
    return _tipSep2View;
}
#pragma mark 最底下TableView
- (void)addBottomTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    //tableView.rowHeight = 110;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    tableView.backgroundColor = mRGBToColor(0xeeeeee);
    tableView.bounces = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.contentView  addSubview:tableView];
    self.resTableView = tableView;
    NSArray *modArray  = self.babyPlan.mod;
    PDBabyPlanMod *currMod  = [modArray objectAtIndex:self.selectIndex];
    [tableView registerClass:[RBClassifyTableViewCell class] forCellReuseIdentifier:tableIndefiter];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipSep2View.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SX(85)*currMod.resources.count+35);
    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tableView.mas_bottom);
    }];
    
}
#pragma mark - early teach

- (void)loadEarlyTeach{
    
    @weakify(self)
    
    self.teachTipsLabBg = (UIView *)^(){
        @strongify(self)
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.layer.cornerRadius = SX(4);
        view.layer.borderColor = mRGBToColor(0xf4f5f6).CGColor;
        view.layer.borderWidth = 1;
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        return view;
    }();
    
    UIView * sepTitleBg = (UIView *)^(){
        @strongify(self)
        UIView * view = [[UIView alloc] init];
        //阶段特征标题栏 背景
        view.backgroundColor = mRGBToColor(0xf4f5f6);
        [self.teachTipsLabBg addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(SX(0)));
            make.top.equalTo(self.stageLabBg.mas_bottom).offset(SX(14));
            make.height.equalTo(@(SX(41)));
            make.right.equalTo(self.stageLabBg.mas_right);
        }];
        return view;
    }();
    
    UIImageView * sepIcon = (UIImageView *)^(){
        ///标题icon
        UIImageView * view = [UIImageView new];
        view.image = [UIImage imageNamed:@"ic_psychology_tips"];
        [sepTitleBg addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(sepTitleBg.mas_centerY);
            make.left.equalTo(@(SX(15)));
        }];
        return view;
    }();
    
    
    
    UILabel * titlelable = (UILabel *)^(){
        UILabel * lable = [UILabel new];
        lable.font = [UIFont systemFontOfSize:SX(15)];
        lable.textColor = mRGBToColor(0x4A4A4A);
        [sepTitleBg addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(sepTitleBg.mas_centerY);
            make.left.equalTo(sepIcon.mas_right).offset(SX(8));
        }];
        return lable;
    }();
    titlelable.text = NSLocalizedString( @"early_education_tips", nil);
    BOOL isplus = RBDataHandle.currentDevice.isPuddingPlus;

    //圆圈
    ^{
        @strongify(self)
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = isplus ? mRGBToColor(0xc8e788) .CGColor : mRGBToColor(0x82d6f5).CGColor;
        view.layer.borderWidth = SX(3);
        view.layer.cornerRadius = SX(5);
        
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(SX(21 )));
            make.width.height.equalTo(@(SX(10)));
            make.centerY.equalTo(sepIcon.mas_centerY);
        }];
        return view;
    }();
    
    self.teachTipsLab = (UILabel *)^(){
        @strongify(self)
        UILabel *lable = [UILabel new];
        lable.text = NSLocalizedString( @"prompt_prompt", nil) ;
        lable.font = [UIFont systemFontOfSize:SX(13)];
        lable.numberOfLines = 0;
        lable.textColor =  mRGBToColor(0x787878);
        [lable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.teachTipsLabBg addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sepTitleBg.mas_bottom).offset(SX(15));
            make.left.equalTo(@(SX(15)));
            make.right.equalTo(self.contentView.mas_right).offset(-SX(29));
        }];
        return lable;
    }();
    
    [self.teachTipsLabBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stageLabBg.mas_bottom).offset(SX(15));
        make.left.equalTo(@(SX(45)));
        make.right.equalTo(self.view.mas_right).offset(-SX(15));
        make.bottom.equalTo(self.teachTipsLab.mas_bottom).offset(SX(15));
    }];
 
}


#pragma mark -  step developer

- (void)loadBabyStep{
    @weakify(self)
    
    self.stageLabBg = (UIView *)^(){
        @strongify(self)
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.layer.cornerRadius = SX(4);
        view.layer.borderColor = mRGBToColor(0xf4f5f6).CGColor;
        view.layer.borderWidth = 1;
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        return view;
    }();
    
    UIView * sepTitleBg = (UIView *)^(){
        @strongify(self)
        UIView * view = [[UIView alloc] init];
        //阶段特征标题栏 背景
        view.backgroundColor = mRGBToColor(0xf4f5f6);
        [self.stageLabBg addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@(SX(0)));
            make.height.equalTo(@(SX(41)));
            make.right.equalTo(self.stageLabBg.mas_right);
        }];
        return view;
    }();

    UIImageView * sepIcon = (UIImageView *)^(){
        ///标题icon
        UIImageView * view = [UIImageView new];
        view.image = [UIImage imageNamed:@"ic_psychology_stage"];
        [sepTitleBg addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(sepTitleBg.mas_centerY);
            make.left.equalTo(@(SX(15)));
        }];
        return view;
    }();
    
    
    
    UILabel * titlelable = (UILabel *)^(){
        UILabel * lable = [UILabel new];
        lable.text = NSLocalizedString( @"phase_characteristics", nil);
        lable.font = [UIFont systemFontOfSize:SX(15)];
        lable.textColor = mRGBToColor(0x4A4A4A);
        [sepTitleBg addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(sepTitleBg.mas_centerY);
            make.left.equalTo(sepIcon.mas_right).offset(SX(8));
        }];
        return lable;
    }();
    titlelable.text = NSLocalizedString( @"phase_characteristics", nil);
    
    //圆圈
  ^{
      @strongify(self)
      UIView * view = [UIView new];
      view.backgroundColor = [UIColor whiteColor];
      view.layer.borderColor = mRGBToColor(0xc8e788).CGColor;
      view.layer.borderWidth = SX(3);
      view.layer.cornerRadius = SX(5);
      
      [self.contentView addSubview:view];
      
      [view mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(@(SX(21)));
          make.width.height.equalTo(@(SX(10)));
          make.centerY.equalTo(sepIcon.mas_centerY);
      }];
      return view;
    }();
    
    self.stageLab = (UILabel *)^(){
        @strongify(self)
        UILabel *lable = [UILabel new];
        lable.text = NSLocalizedString( @"prompt_prompt", nil) ;
        lable.font = [UIFont systemFontOfSize:SX(13)];

        lable.numberOfLines = 0;
        lable.textColor =  mRGBToColor(0x787878);
        [lable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.stageLabBg addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sepTitleBg.mas_bottom).offset(SX(15));
            make.left.equalTo(@(SX(15)));
            make.right.equalTo(self.contentView.mas_right).offset(-SX(29));
        }];
        return lable;
    }();
    
    [self.stageLabBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topbackView.mas_bottom).offset(SX(8));
        make.left.equalTo(@(SX(45)));
        make.right.equalTo(self.view.mas_right).offset(-SX(15));
        make.bottom.equalTo(self.stageLab.mas_bottom).offset(SX(15));
    }];
    
}

#pragma mark - load baby message


- (void)loadBabyMessage{
    RBDeviceModel *model  = RBDataHandle.currentDevice;
    @weakify(self)
    self.scrollView = (UIScrollView *)^(){
        @strongify(self)

        UIScrollView *scrollView = UIScrollView.new;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.bounces = NO;
        scrollView.delegate = self;
        [self.view insertSubview:scrollView atIndex:0];
        
        scrollView.delaysContentTouches = true;
        
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(NAV_HEIGHT));
            make.bottom.equalTo(self.view.mas_bottom);
            make.left.equalTo(@0);
            make.right.equalTo(self.view.mas_right);
        }];
        return scrollView;
    }();
    
    _contentView = (UIView *)^(){
        @strongify(self)
        UIView * v = [UIView new];
        [self.scrollView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
//            make.height.equalTo(self.scrollView);
        }];
        return v;
    }();
    
    self.topbackView = (UIImageView *)^(){
        @strongify(self)
//        UIImageView *imageView = [[UIImageView alloc]initWithImage:model.isPuddingPlus ? [UIImage imageNamed:@"bg_psychology_dou"] : [UIImage imageNamed:@"bg_psychology_s"]];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_growup"]];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(self.contentView.mas_width);
        }];
        return imageView;
    }();
    UILabel *growthGuideTitleLabel = (UILabel *)^(){
        @strongify(self)
        //成长指南 四个大字
        UILabel *lable = UILabel.new;
        lable.backgroundColor = [UIColor clearColor];
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont boldSystemFontOfSize:SX(18)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = NSLocalizedString( @"guide_growth", nil);
        [self.contentView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topbackView).offset(SX(108));
            make.top.mas_equalTo(self.topbackView).offset(SX(28));
        }];
        return lable;
    }();
    UILabel *growthGuideDetailLabel = (UILabel *)^(){
        @strongify(self)
        //成长指南详情
        UILabel *lable = UILabel.new;
        lable.backgroundColor = [UIColor clearColor];
        lable.textColor = [UIColor whiteColor];
        lable.numberOfLines = 0;
        lable.font = [UIFont boldSystemFontOfSize:SX(13)];
//        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = NSLocalizedString( @"교육부 어린이 학습 및 초등학교 수업 개발 안내서, 몬테소리의 맟춤형 연간 개발 목표에 따라 진행됩니다. 매주 업데이트되는 스마트 학습법입니다!", nil);
        [self.contentView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(growthGuideTitleLabel.mas_left);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.top.mas_equalTo(growthGuideTitleLabel.mas_bottom).offset(8);
        }];
        return lable;
    }();
    self.joinClassTableBtn = (UIButton *)^(){
        @strongify(self)
        
        //加入课表按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(joinClassTableAct:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:NSLocalizedString( @"join_timetable", nil) forState:(UIControlStateNormal)];
        button.layer.cornerRadius = SX(13);
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1;
        button.clipsToBounds = YES;
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(growthGuideDetailLabel.mas_bottom).offset(10);
            make.left.equalTo(growthGuideDetailLabel.mas_left);
            make.height.mas_equalTo(SX(26));
            make.width.mas_equalTo(SX(76));
        }];
        
        
        return button;
    }();
    if ([RBDataHandle.currentDevice isPuddingPlus]) {
        self.joinClassTableBtn.hidden = NO;
    }
    else{
        self.joinClassTableBtn.hidden = YES;
    }
/*
    self.iconImg = (UIImageView *)^(){
        @strongify(self)

        UIImageView * view = [[UIImageView alloc] init];
        //头像
        view.image = [UIImage imageNamed:@"ic_psychology_head"];
        [self.contentView addSubview:view];
        view.userInteractionEnabled = NO;
        view.layer.masksToBounds = YES;
        view.layer.borderWidth = 3;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.cornerRadius = SX(75)/2;
        
        UITapGestureRecognizer  *iconTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            [self babyIconClick];
        }];
        [view addGestureRecognizer:iconTap];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SX(9));
            make.height.width.mas_equalTo(SX(75));
            make.centerX.mas_equalTo(self.topbackView.mas_centerX);
        }];
        return view;
    }();
    
     self.nameLab = (UILabel *)^(){
         @strongify(self)

         UILabel *lable = UILabel.new;
         lable.font = [UIFont systemFontOfSize:17];

         lable.textColor = [UIColor whiteColor];
         lable.textAlignment = NSTextAlignmentCenter;
         lable.text = NSLocalizedString( @"name", nil);
         [self.contentView addSubview:lable];
         [lable mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.iconImg.mas_bottom).offset(SX(7));
             make.centerX.equalTo(self.iconImg.mas_centerX).offset(-SX(24));
         }];

         return lable;
    }();
    
    
    self.ageLab = (UILabel *)^(){
        @strongify(self)

        //年龄
        UILabel *lable = UILabel.new;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:15];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = NSLocalizedString( @"age_4_year_5_month", nil);

        lable.layer.cornerRadius = SX(9);
        lable.layer.borderColor = [UIColor whiteColor].CGColor;
        lable.layer.borderWidth = 0.5;
        lable.clipsToBounds = YES;
        lable.font = [UIFont systemFontOfSize:SX(12)];
        
        [self.contentView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLab.mas_centerY);
            make.left.equalTo(self.nameLab.mas_right).offset(SX(4));
            make.height.mas_equalTo(SX(18));
        }];

        
        return lable;
    }();
    
    
    UILabel * desLable = (UILabel *)^(){
        @strongify(self)
        
        //年龄
        UILabel *lable = UILabel.new;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:12];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = NSLocalizedString( @"every_baby_is_unique_we_give_hime_suitable_content", nil);
        
        lable.font = [UIFont systemFontOfSize:SX(12)];
        
        [self.contentView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLab.mas_bottom).offset(SX(2));
            make.centerX.equalTo(self.view.mas_centerX).offset(SX(10));
            make.height.mas_equalTo(SX(18));
        }];
        
        
        return lable;
    }();
    */
}


#pragma mark -



-(void)fetchBabyPlanData{
    [MitLoadingView showWithStatus:NSLocalizedString( @"loading_data", nil)];
    [RBNetworkHandle fetchBabyPlanInfo:^(id res) {
        [MitLoadingView dismiss];
        _babyPlan = [PDBabyPlan modelWithJSON:res];
        if (_babyPlan.result == 0) {
//            [self loadBabyStep];
//            [self loadEarlyTeach];
//            [self tipSepView];
            [self babydevelopeModel];
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            style.lineSpacing = 3;
            style.lineBreakMode = NSLineBreakByTruncatingTail;
            NSMutableAttributedString *desString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_babyPlan.des]];
            [desString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, desString.length)];
            self.stageLab.attributedText = desString;
            NSMutableAttributedString *tipString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_babyPlan.tips]];
            [tipString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, tipString.length)];
            self.teachTipsLab.attributedText = tipString;
        }else if (_babyPlan.result!=0){
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}

#pragma mark - 设置navigationController
-(void)setupNavView{
    
    navview = [UIView new];
    [self.view addSubview:navview];
    navview.backgroundColor = mRGBToColor(0xFFFFFF);
    [navview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(NAV_HEIGHT);
    }];
    
    UILabel *titleLabel = [UILabel new];
    [navview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(navview.mas_centerX);
        make.height.mas_equalTo(44);
    }];
    titleLabel.textColor = mRGBToColor(0x505a66);
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.titleContent;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navview addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
    }];
    [backBtn addTarget:self action:@selector(backAct) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navview addSubview:settingBtn];
    [settingBtn setImage:[UIImage imageNamed:@"ic_setup"] forState:UIControlStateNormal];
    settingBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
    }];
    [settingBtn addTarget:self action:@selector(babyIconClick) forControlEvents:UIControlEventTouchUpInside];
}


- (void)rbcollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSInteger )index
{

    NSArray *modsArray  = self.babyPlan.mod;
    self.selectIndex = index;
    PDBabyPlanMod *currMod   = [modsArray objectAtIndex:self.selectIndex];
    self.contentLab.attributedText = [self getContentLableText:currMod.features];
    [self.chart reloadData];
    [self.resTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SX(85)*currMod.resources.count+35);
    }];
    [self.resTableView reloadData];
}


#pragma mark - 返回按钮
-(void)backAct{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 加入课程表按钮
- (void)joinClassTableAct:(UIButton*)btn{
    NSDictionary *dic = RBDataHandle.classTableStoreDic;

    if (dic == nil) {
        [self toClassTable];
    }
    else{
        [self joinClassWith:dic];
    }
}

- (void)joinClassWith:(NSDictionary*)dic{
    if (_isJoined) {
        return;
    }

    [MitLoadingView showWithStatus:@"show"];
    @weakify(self)
    
    [RBNetworkHandle addCourseData:[NSString stringWithFormat:@"%ld",(long)self.babyPlan.code] type:@"1" menuId:dic[@"menuId"] dayIndex:[dic[@"dayIndex"] intValue] WithBlock:^(id res) {
        [MitLoadingView dismiss];
        @strongify(self)
        if(res && [[res objectForKey:@"result"] integerValue] == 0){
            [_joinClassTableBtn setTitle:@"已加入" forState:(UIControlStateNormal)];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshClassTable" object:nil];
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"success", nil) maskType:MitLoadingViewMaskTypeBlack];
            self.isJoined = YES;
            RBDataHandle.classTableStoreDic = nil;
            [self popBack];
        }
        else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}
- (void)popBack{
    UINavigationController *navVC = self.navigationController;
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (UIViewController *vc in [navVC viewControllers]) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:[RBClassTableViewController class]]) {
            break;
        }
    }
    [navVC setViewControllers:viewControllers animated:YES];
}
- (void)toClassTable{
    RBClassTableViewController * v = [[RBClassTableViewController alloc] init];
    v.mid = [NSString stringWithFormat:@"%ld",(long)self.babyPlan.code];
    v.classType = 1;
    [self.navigationController pushViewController:v animated:YES];
    
}
- (UIScrollView *)scrollView{
    return _scrollView;
    
}

#pragma mark  分享截屏按钮
-(void)shareAct:(UIBarButtonItem *)item{
    [self CaptureScreen];
}

#pragma mark -
- (void)setBabyAge:(NSString *)age{
    NSMutableAttributedString* attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",age]];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(12)] range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:SX(6)] range:NSMakeRange(0, 1)];
    [attributedStr addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:SX(8)] range:NSMakeRange(attributedStr.length-1, 1)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0xffffff) range:NSMakeRange(0, attributedStr.length)];
    self.ageLab.attributedText = attributedStr;
}


#pragma mark 阶段特征控件布局
- (void)featureLayoutSubviews{
    [self stageLab];
    [self stageLabBg];
    [self teachTipsLab];
    [self teachTipsLabBg];
//    [self tipSepView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.nameLab.text = RBDataHandle.currentDevice.growplan.nickname;

    [self setBabyAge:RBDataHandle.currentDevice.growplan.age];
//    [self.iconImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.growplan.img]] placeholder: [UIImage imageNamed:@"ic_home_head"]];
}





#pragma mark - tableView的数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *modArray  = self.babyPlan.mod;
    PDBabyPlanMod *currMod  = [modArray objectAtIndex:self.selectIndex];
    return currMod.resources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RBClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIndefiter];
    if (cell==nil) {
        cell = [[RBClassifyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIndefiter];
    }
    NSArray *modArray  = self.babyPlan.mod;
    PDBabyPlanMod *currMod  = [modArray objectAtIndex:self.selectIndex];
    PDBabyPlanResources *currResources  = [currMod.resources objectAtIndex:indexPath.row];
    cell.indexPath = indexPath;
    cell.resours = currResources;
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SX(85);
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *modArray  = self.babyPlan.mod;
    PDBabyPlanMod *currMod  = [modArray objectAtIndex:self.selectIndex];
    PDBabyPlanResources *currResources  = [currMod.resources objectAtIndex:indexPath.row];
    PDFeatureModle *modle = [PDFeatureModle new];
    modle.title = currResources.title;
    modle.mid = currResources.cid;
    modle.img = nil;
    modle.isBabyPlan = YES;
    modle.thumb = currResources.thumb;
    [RBStat logEvent:PD_BABY_DEVELOP_RESOUSE message:nil];
    [self.navigationController pushFetureList:modle ];

}

//-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 75;
//}
//-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 75)];
//    footView.backgroundColor = [UIColor whiteColor];
//
//    UIImageView *endImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"growplan_end_word"]];
//    [footView addSubview:endImageView];
//
//    [endImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(20);
//        make.width.mas_equalTo(endImageView.image.size.width);
//        make.height.mas_equalTo(endImageView.image.size.height);
//        make.centerX.mas_equalTo(footView.mas_centerX);
//    }];
//    return footView;
//
//}




#pragma mark - 截屏方法
- (void)CaptureScreen{
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, YES, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = self.scrollView.contentOffset;
        CGRect savedFrame = self.scrollView.frame;
        self.scrollView.contentOffset = CGPointZero;
        self.scrollView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
        [self.scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        self.scrollView.contentOffset = savedContentOffset;
        self.scrollView.frame = savedFrame;
        
    }
    UIGraphicsEndImageContext();
    if (image != nil) {
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

#pragma mark 截屏指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = NSLocalizedString( @"save_pic_fail", nil) ;
    }else{
        msg = NSLocalizedString( @"save_picture_success_cloud_view_in_glbum", nil) ;
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString( @"prompt_message", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"g_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 单元格布局
#pragma mark 每组单元格个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return MIN(_babyPlan.mod.count, 5);
}

#pragma mark配置单元格



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectIndefiter forIndexPath:indexPath];
    NSArray *modArray  = _babyPlan.mod;

    PDBabyPlanMod *currMod = [modArray objectAtIndex:indexPath.row];
    UIView * backView = [[UIView alloc] initWithFrame:cell.bounds];
    backView.layer.borderColor = mRGBToColor(0x9b9b9b).CGColor;
    backView.layer.cornerRadius = SX(14);
    backView.layer.borderWidth = 1;
    backView.clipsToBounds = YES;
    
    cell.backgroundView = backView;
    
    
    UIView * selectView = [[UIView alloc] initWithFrame:cell.bounds];
    selectView.layer.cornerRadius = SX(14);
    selectView.clipsToBounds = YES;
    selectView.backgroundColor = mRGBToColor(0x8fc321);
    cell.selectedBackgroundView = selectView;
    
    
    UILabel * lable = (UILabel *)^(){
        
        UILabel * lable = [cell viewWithTag:123];
        if (lable == nil || ![lable isKindOfClass:[UILabel class]]) {
            lable = [[UILabel alloc] init];
            lable.tag = 123;
            lable.textAlignment = NSTextAlignmentCenter;
            lable.font = [UIFont systemFontOfSize:15];
            [cell addSubview:lable];
            
            [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell);
            }];
        }
    
        return lable;
    }();
    lable.textColor = cell.selected  ? mRGBToColor(0xffffff) : mRGBToColor(0x9b9b9b);

    lable.text = currMod.name;
    return cell;
}

#pragma mark单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *modArray  = _babyPlan.mod;
    PDBabyPlanMod *currMod = [modArray objectAtIndex:indexPath.row];
    
    CGSize size = [currMod.name sizeForFont:[UIFont systemFontOfSize:SX(15)] size:CGSizeMake(NSUIntegerMax, SX(28)) mode:NSLineBreakByClipping];
    return CGSizeMake(size.width + SX(30), SY(28));
}

#pragma mark 点击单元格方法

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0]];
    UILabel * lable = (UILabel *)[cell viewWithTag:123];
    if([lable isKindOfClass:[UILabel class]])
        lable.textColor =  mRGBToColor(0x9b9b9b) ;
    return YES;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel * lable = (UILabel *)[cell viewWithTag:123];
    if([lable isKindOfClass:[UILabel class]])
        lable.textColor =  mRGBToColor(0xffffff) ;

    
    self.selectIndex = indexPath.row;
    NSArray *modsArray  = self.babyPlan.mod;
    PDBabyPlanMod *currMod   = [modsArray objectAtIndex:self.selectIndex];
    self.contentLab.attributedText = [self getContentLableText:currMod.features];
    [self.chart reloadData];
    [self.resTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SX(85)*currMod.resources.count+35);
    }];
    [self.resTableView reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel * lable = (UILabel *)[cell viewWithTag:123];
    if([lable isKindOfClass:[UILabel class]])
        lable.textColor =  mRGBToColor(0x9b9b9b) ;
}
    
    
-(void)babyIconClick{
    RBBabyMessageViewController *babyDevelopVC = [RBBabyMessageViewController new];
    babyDevelopVC.configType = PDAddPuddingTypeUpdateData;
    [self.navigationController pushViewController:babyDevelopVC animated:YES];
}

- (NSInteger)numberOfStepForRadarChart:(LQRadarChart *)radarChart
{
    return 3;
}
- (NSInteger)numberOfRowForRadarChart:(LQRadarChart *)radarChart
{
    NSArray *modArray  = self.babyPlan.mod;
    PDBabyPlanMod *currMod  = [modArray objectAtIndex:self.selectIndex];
    return currMod.tags.count;
}
- (NSInteger)numberOfSectionForRadarChart:(LQRadarChart *)radarChart
{
    return 1;
}
- (NSString *)titleOfRowForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row{
    NSArray *modArray  = self.babyPlan.mod;
    PDBabyPlanMod *currMod  = [modArray objectAtIndex:self.selectIndex];
    NSArray *tagsArray = currMod.tags;
    PDBabyPlanTags *currTag =  [tagsArray objectAtIndex:row];
    return currTag.name;
}
- (CGFloat)valueOfSectionForRadarChart:(LQRadarChart *)radarChart row:(NSInteger)row section:(NSInteger)section
{
    NSArray *modArray  = self.babyPlan.mod;
    PDBabyPlanMod *currMod  = [modArray objectAtIndex:self.selectIndex];
    NSArray *tagsArray = currMod.tags;
    PDBabyPlanTags *currTag =  [tagsArray objectAtIndex:row];
    return currTag.val;
    
}

- (UIColor *)colorOfTitleForRadarChart:(LQRadarChart *)radarChart
{
    return mRGBToColor(0x9B9B9B);
    
}
- (UIColor *)colorOfLineForRadarChart:(LQRadarChart *)radarChart
{
    return mRGBToColor(0xd1d1d1);
    
}
- (UIColor *)colorOfFillStepForRadarChart:(LQRadarChart *)radarChart step:(NSInteger)step
{
    UIColor * color = [UIColor clearColor];
    return color;
}
- (UIColor *)colorOfSectionFillForRadarChart:(LQRadarChart *)radarChart section:(NSInteger)section
{
    
    UIColor *currlor  = [_colorArr objectAtIndex:self.selectIndex];
    return [currlor colorWithAlphaComponent:0.5];
}
- (UIColor *)colorOfSectionBorderForRadarChart:(LQRadarChart *)radarChart section:(NSInteger)section{
    
    
    return [UIColor clearColor];
}
- (UIFont *)fontOfTitleForRadarChart:(LQRadarChart *)radarChart
{
    return [UIFont systemFontOfSize:11];
}



@end
