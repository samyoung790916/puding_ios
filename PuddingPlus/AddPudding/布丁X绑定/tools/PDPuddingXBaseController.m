//
//  PDPuddingXBaseController.m
//  PuddingPlus
//
//  Created by kieran on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDPuddingXBaseController.h"
#import "PDPuddingXBaseController+PDPuddingxNavController.h"


@interface PDPuddingXBaseController (){
    Boolean isPushIn;
}
@end

@implementation PDPuddingXBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    isPushIn = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    @weakify(self)
    [self.navView setLeftCallBack:^(BOOL isSelected) {
        @strongify(self)
        [self puddingxPopViewControllerAnimated:YES CurrentProgress:self.sepView.progress];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    float progress = self.sepView.progress;
    
    [self.sepView setProgress:progress + (isPushIn ? -0.2 : 0.2) Animail:false];
    [self.sepView setProgress:progress Animail:true];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    isPushIn = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (PDConfigSepView *)sepView{
    if(_sepView == nil){
        PDConfigSepView * view = [[PDConfigSepView alloc] initWithFrame:CGRectMake(0, self.view.height - SX(37), self.view.width, SX(37))];
        [self.view addSubview:view];
    
        _sepView = view;
    }
    return _sepView;
}

- (void)dealloc{
    
}

@end
