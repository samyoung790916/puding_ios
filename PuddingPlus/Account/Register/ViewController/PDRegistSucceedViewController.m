//
//  PDRegistSucceedViewController.m
//  Pudding
//
//  Created by william on 16/3/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDRegistSucceedViewController.h"
//#import "PDConfigNetStepOneController.h"


@interface PDRegistSucceedViewController ()
/** 添加布丁 */
@property (nonatomic, weak) UIButton * addPudding;
/** 布丁数组 */
@property (nonatomic, strong) NSArray *puddingArr;

@end

@implementation PDRegistSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化导航栏
    [self initialNav];
    
    /** 添加新布丁 */
    self.addPudding.layer.cornerRadius = 5;
    
    /** 设置数据源 */
//    self.puddingArr = DataHandle.loginData.mcids;
    
    
    
    
    
    
}

#pragma mark - 初始化导航栏
- (void)initialNav{
    self.navView.hidden = YES;
    self.view.backgroundColor = PDBackColor;
    
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

static CGFloat kEdgePacing = 45;
static CGFloat kTxtHeight = 45;
#pragma mark - 创建 -> 添加布丁
-(UIButton *)addPudding{
    if (!_addPudding) {
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(kEdgePacing, kEdgePacing, self.view.width - 2*kEdgePacing, kTxtHeight);
        [btn setTitle:R.add_new_pudding forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor blueColor];
        [btn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _addPudding = btn;
    }
    return _addPudding;
}

#pragma mark - action: 添加新布丁按钮点击
- (void)addAction{
//    LogWarm(@"%s",__func__);
//    PDConfigNetStepOneController *vc = [PDConfigNetStepOneController new];
//    vc.isAddRoobo = YES;
//    [self.navigationController pushViewController:vc animated:YES];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
