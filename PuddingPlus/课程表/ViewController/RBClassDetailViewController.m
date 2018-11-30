//
//  RBClassDetailViewController.m
//  PuddingPlus
//
//  Created by liyang on 2018/4/14.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBClassDetailViewController.h"
#import "RBClassDetailTableViewController.h"

@interface RBClassDetailViewController () <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    NSMutableArray *buttonsArray;
    NSMutableArray *weekLabelArray;
    NSMutableArray *dateLabelArray;
}

@end
static int todayIndex = 1;
@implementation RBClassDetailViewController
- (void)dealloc{
    NSLog(@"dealloc");
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.title = NSLocalizedString(@"today_class", @"今日课表");
    [self setupTopView];
    [self setupScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTopView{
    buttonsArray = [NSMutableArray array];
    weekLabelArray = [NSMutableArray array];
    dateLabelArray = [NSMutableArray array];
    CGFloat buttonWidth = self.view.width/_dayModelArray.count;
    for (int i=0; i<_dayModelArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(buttonWidth*i, NAV_HEIGHT, buttonWidth, 54);
        [self.view addSubview:button];
        UIView *containerView = [[UIView alloc] init];
        containerView.userInteractionEnabled = NO;
        UILabel *weekLabel = [[UILabel alloc] init];
        weekLabel.textColor = RGB(74, 74, 74);
        [weekLabel setFont:[UIFont systemFontOfSize:12]];
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.textColor = RGB(155, 155, 155);
        [dateLabel setFont:[UIFont systemFontOfSize:10]];
        [self.view addSubview:containerView];
        [containerView addSubview:weekLabel];
        [containerView addSubview:dateLabel];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(button);
        }];
        [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(containerView);
            make.left.mas_equalTo(containerView);
            make.right.mas_equalTo(containerView);
            make.bottom.mas_equalTo(dateLabel.mas_top).mas_offset(-3);
        }];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weekLabel);
            make.bottom.mas_equalTo(containerView);
        }];
        RBClassDayModle *dayModel = _dayModelArray[i];
        weekLabel.text = dayModel.week;
        dateLabel.text = dayModel.day;
        if (dayModel.today) {
            weekLabel.text = @"今天";
        }
        button.tag = i+10;
        [button addTarget:self action:@selector(topButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [buttonsArray addObject:button];
        [weekLabelArray addObject:weekLabel];
        [dateLabelArray addObject:dateLabel];
    }
    [self changeButtonColor:todayIndex];
}
- (void)topButtonClick:(UIButton*)button{
    NSInteger index = button.tag-10;
    [self changeButtonColor:index];
}
- (void)changeButtonColor:(NSInteger)index{
    for (int i=0; i<buttonsArray.count; i++) {
        UIButton *btn = buttonsArray[i];
        if (i==todayIndex) {
            btn.backgroundColor = RGB(238, 238, 238);
        }
        else{
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
    for (UILabel *label in weekLabelArray) {
        label.textColor = RGB(74, 74, 74);
    }
    for (UILabel *label in dateLabelArray) {
        label.textColor = RGB(155, 155, 155);
    }
    UILabel *button = buttonsArray[index];
    button.backgroundColor = RGB(142, 195, 31);
    UILabel *weekLabel = weekLabelArray[index];
    weekLabel.textColor = [UIColor whiteColor];
    UILabel *dateLabel = dateLabelArray[index];
    dateLabel.textColor = [UIColor whiteColor];
    scrollView.contentOffset = CGPointMake(scrollView.width*index, 0);
}

- (void)setupScrollView{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT+54, self.view.width, self.view.height-54-NAV_HEIGHT)];
    scrollView.contentSize = CGSizeMake(scrollView.width*_dayModelArray.count, scrollView.height);
    scrollView.contentOffset = CGPointMake(scrollView.width*todayIndex, 0);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    for (int i=0; i<_dayModelArray.count; i++) {
        [self setupChildTableView:i];
    }
}
- (void)setupChildTableView:(int)index{
    RBClassDetailTableViewController *vc = [[RBClassDetailTableViewController alloc] init];
    vc.view.frame = CGRectMake(scrollView.width*index, 0, scrollView.width, scrollView.height);
    vc.timesArray = _model.menu;
    vc.modulsArray = [self mixData:index];
    vc.contentModel = _model.module;
    [self addChildViewController:vc];
    [scrollView addSubview:vc.view];
}
- (NSMutableArray*)mixData:(int)index{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<_model.module.count; i++) {
        RBClassTableContentModel *content = _model.module[i];
         RBClassTableContentDetailModel *detail = [self getContentDetailModel:content index:index-todayIndex];
        if (detail.content._id>0) {
            [array addObject:detail];
        }
    }
    
    return array;
}
- (RBClassTableContentDetailModel*)getContentDetailModel:(RBClassTableContentModel*)model index:(int)index{
    for (int i=0; i<model.content.count; i++) {
        RBClassTableContentDetailModel *detailModel = model.content[i];
        NSTimeInterval time = detailModel.date;
        NSTimeInterval day_target = [RBNetworkHandle getCurrentTimeInterval]+60*60*24*index;
        if (time>=day_target && time <(day_target+60*60*24)) {
            return detailModel;
        }
    }
    return nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    [self changeButtonColor:index];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
