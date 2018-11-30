//
//  NetConfigStepOneViewController.m
//  PuddingPlus
//
//  Created by liyang on 2018/5/18.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "NetConfigStepOneViewController.h"
#import "NetConfigStepTwoViewController.h"
@interface NetConfigStepOneViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressLength;

@end

@implementation NetConfigStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navView.backgroundColor = [UIColor clearColor];
    self.navView.lineView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _progressLength.constant = self.view.width/5+10;
}
- (IBAction)nextBtnAction:(id)sender {
    NetConfigStepTwoViewController *vi = [[NetConfigStepTwoViewController alloc] initWithNibName:@"NetConfigStepTwoViewController" bundle:nil];
    vi.configType = self.configType;
    [self.navigationController pushViewController:vi animated:YES];
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