//
//  RBEditQuestionViewController.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/12/4.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import "RBEditQuestionViewController.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "UIViewController+RBAlter.h"
#import "PDNewQuestionCell.h"
#import "RACSignal+Operations.h"

@implementation RBEditQuestionViewModle

@synthesize currentModle = _currentModle;
@synthesize editModle = _editModle;
/**
 *  @author 智奎宇, 15-12-07 18:12:31
 *
 *  判断是否需要显示添加按钮
 *
 */
-(BOOL)checkbtnShow{
    if([_currentModle isEqual:_editModle]){
        return YES;
    }
    return NO;
}

/**
 *  @author 智奎宇, 15-12-07 18:12:00
 *
 *  提交问题修改
 */
- (void)commitUpdate{
    LogError(@"commitUpdate");

    if(_CommitResultBlock){
        BOOL isUpdate  = _editModle == nil ? NO : YES;
        if(_editModle != nil)
            _currentModle.qid = _editModle.qid;
       _CommitResultBlock(_currentModle ,isUpdate ,YES);
    }
}

/**
 *  @author 智奎宇, 15-12-07 17:12:02
 *
 *  判断是否可以点击，如果信息不全不可以可以点击按钮
 *
 */
-(RACSignal *)canEditSignal{
    return [RACSignal combineLatest:@[RACObserve(self.currentModle, question),RACObserve(self.currentModle, response)] reduce:^id(NSString * title,NSString * answer){
        if([title length] > 0 && [answer length] > 0){
            return @(YES);
        }
        return @(NO);
    }];
    
}



- (QuestionModle *)currentModle{
    if(_currentModle == nil){
        _currentModle = [[QuestionModle alloc] init];
        _currentModle.qid = @(-1);
    }
    return _currentModle;
}

- (void)setEditModle:(QuestionModle *)editModle{
    _currentModle = [editModle copy];
    _editModle = [editModle copy];
    

}


/**
 *  @author 智奎宇, 15-12-07 21:12:20
 *
 *  更新回答列表
 *
 */
- (void)updateQuestionList:(void (^)(BOOL isSucess,id res)) endBlock{
    BOOL isUpdate  = _editModle == nil ? NO : YES;
    @weakify(self);
    [RBNetworkHandle updateDIYModle:self.currentModle.qid Question:self.currentModle.question Response:self.currentModle.response WithBlock:^(id res) {
        @strongify(self);
        if(res && [[res mObjectForKey:@"result"] intValue] == 0){
            if(!isUpdate){
                self.currentModle.qid = [[res mObjectForKey:@"data"] mObjectForKey:@"id"];
            }
            if(endBlock){
                endBlock(YES,res);
            }
        }else{
            if(endBlock){
                endBlock(NO,res);
            }
        }
        
    }];
}

@end


@interface RBEditQuestionViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,PDNewQuestionCellDelegate>{
         CGFloat _cellHeight[2];
}

@property (nonatomic,strong) UITableView *questionTableView;
@property (nonatomic,strong) NSMutableArray *questArray;
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,assign) BOOL isShowKeyboard;
@end

@implementation RBEditQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    if (self.type == RBEditQuestionViewStyleAdd) {
        self.title = NSLocalizedString( @"add_new_problem", nil);

    }else{
        self.title = NSLocalizedString( @"edit_problem_", nil);
 
    }
    PDNavItem *item = [PDNavItem new];
    item.titleColor = PDTextColor;
    item.title = NSLocalizedString( @"finnish_", nil);
    self.navView.rightItem = item;
    @weakify(self)
    self.navView.rightCallBack = ^(BOOL selected){
        @strongify(self)
        self.navView.rightBtn.selected = NO;
        [self editQuestionAction:nil];
    };
    self.view.backgroundColor = mRGBToColor(0xffffff);
    self.questionTableView = [UITableView new];
    [self.view addSubview:self.questionTableView];
    [self.questionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(NAV_HEIGHT, 0, 0, 0));
    }];
    self.questionTableView.dataSource = self;
    self.questionTableView.delegate =self;
    self.questionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.questionTableView registerClass:[PDNewQuestionCell class] forCellReuseIdentifier:NSStringFromClass([PDNewQuestionCell class])];
    self.questionTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (self.type ==RBEditQuestionViewStyleAdd ) {
         [RBStat logEvent:PD_Diy_Add message:nil];
        self.questArray = [[NSMutableArray alloc] initWithArray:@[@"",@""]];
    }else{
       self.questArray = [[NSMutableArray alloc] initWithArray:@[_viewModle.editModle.question,_viewModle.editModle.response]];
    }
   
}


#pragma mark - UITabelView;
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return MAX(63.0, _cellHeight[indexPath.row]);
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDNewQuestionCell *cell  = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDNewQuestionCell class])];
    if (indexPath.row==1) {
    cell.isAnswerView = YES;
    }else{
    cell.isAnswerView = NO;
    }
    cell.delegate = self;
    cell.contentText = self.questArray[indexPath.row];
    return cell;
}

#pragma mark - PDNewQuestionCellDelegate
- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath{
    _cellHeight[indexPath.row] = height;
}
- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath{
    [self.questArray replaceObjectAtIndex:indexPath.row withObject:text];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[self.questionTableView removeObserver:self forKeyPath:@"contentSize"];
}
-(void) removeFromParentViewController {
    [super removeFromParentViewController];
    if(self.questionTableView!=nil) {
        self.questionTableView.delegate = nil;
        self.questionTableView.dataSource = nil;
        self.questionTableView = nil;
    }
}

- (RBEditQuestionViewModle *)viewModle{
    if(!_viewModle){
        _viewModle = [[RBEditQuestionViewModle alloc] init];
    }
    return _viewModle;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actioin


- (void)editQuestionAction:(id)sender{
    self.viewModle.currentModle.question = [NSString stringWithFormat:@"%@",self.questArray[0]];
    self.viewModle.currentModle.response = [NSString stringWithFormat:@"%@",self.questArray[1]];
    if (!self.viewModle.currentModle.question.length) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"problem_is_empty", nil)];
        return;
    }
    if (self.viewModle.currentModle.question.length<4) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"at_least_4_word_problem", nil)];
        return;
    }
    if (!self.viewModle.currentModle.response.length) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"answer_is_empty", nil)];
        return;
    }
    if([self.viewModle.currentModle isEqual:self.viewModle.editModle]){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_editing", nil)];
    
    [self.viewModle  updateQuestionList:^(BOOL isSucess,id res) {
        if(isSucess){
            [MitLoadingView dismissDelay:.2];
            [self.viewModle commitUpdate];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            if ([[res mObjectForKey:@"result"] integerValue]==-345) {
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"exit_same_problem", nil)];
                return ;
            }
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"update_fail_2", nil)];
        }
        
    }];
}


@end
