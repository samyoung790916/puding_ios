//
//  PDVideoTTSChatHistoryView.m
//  Pudding
//
//  Created by baxiang on 16/3/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSChatHistoryView.h"
#import "PDTTSHistoryChatCell.h"
#import "PDTTSHistoryModle.h"
#import "PDTTSCollectionCell.h"
#import "PDTTSListModel.h"
@interface PDTTSChatHistoryView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UITableView *speechTable;
@property (nonatomic,strong) NSMutableArray *speechData;
@property (nonatomic,strong) NSMutableArray *speechEditData;
@property (nonatomic,strong) PDTTSHistoryModle *needEditModel;
@property (nonatomic,weak) UIMenuController *myMenuController;
@property (nonatomic,assign) BOOL hasData;
@end
@implementation PDTTSChatHistoryView



-(instancetype) initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
      
        
        [self setupSubView];
    }
    return self;
}
-(void)setupSubView{
    
    UITableView *speechTable = [UITableView new];
    [self addSubview:speechTable];
    UITapGestureRecognizer *gestureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapGesture)];
    [speechTable addGestureRecognizer:gestureTap];
    speechTable.dataSource = self;
    speechTable.delegate = self;
    [speechTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
    speechTable.transform = CGAffineTransformMakeRotation(-M_PI);
    speechTable.showsHorizontalScrollIndicator = NO;
    speechTable.showsVerticalScrollIndicator = NO;
    speechTable.backgroundColor = [UIColor clearColor];
    [speechTable registerClass:[PDTTSHistoryChatCell class] forCellReuseIdentifier:NSStringFromClass([PDTTSHistoryChatCell class])];
    speechTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.speechTable = speechTable;
}




- (NSMutableArray *)speechData{
    if (!_speechData) {
         _speechData = [NSMutableArray new];
    }
    return _speechData;
}

- (NSMutableArray *)speechEditData {
    if (!_speechEditData) {
        _speechEditData = [NSMutableArray new];
    }
    return _speechEditData;
}
-(void) insertChatText:(NSString*) text{

    NSArray * result = [PDTTSHistoryModle searchWithWhere:nil orderBy:@"rowid DESC" offset:0 count:10];
    if (result.count > 0) {
        self.hasData = YES;
    }
    PDTTSHistoryModle *model = [result objectAtIndexOrNil:0];
    if (!model) {
        model = [[PDTTSHistoryModle alloc] init];
        model.tts_content = text;
    }
    [self.speechEditData insertObject:model atIndex:0];
    PDSpeechFrameModel *firstFrameModel= [_speechData objectAtIndexOrNil:0];
    if (firstFrameModel.contentModel.isTipMessage) {
        [_speechData removeObjectAtIndex:0];
        [self.speechTable beginUpdates];
        [self.speechTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [self.speechTable endUpdates];
    }
    PDSpeechFrameModel *frameModel = [PDSpeechFrameModel new];
    PDSpeechTextModel *contentModel = [PDSpeechTextModel new];
    contentModel.text = text;
    contentModel.isTipMessage = NO;
    frameModel.contentModel = contentModel;
    [self.speechData insertObject:frameModel atIndex:0];
    [self.speechTable beginUpdates];
    [self.speechTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    [self.speechTable endUpdates];
    if (self.speechData.count >1) {
        [self.speechTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    }
 
}

-(void) addHistoryMessageData:(NSArray *)historys{
    self.speechData = [NSMutableArray array];
    self.speechEditData = [NSMutableArray array];
    if ([historys count]!=0) {
        self.hasData = YES;
        for (int i= (int)historys.count; i>0; i--) {
            PDTTSHistoryModle *modle = [historys objectAtIndexOrNil:i-1];
            PDSpeechFrameModel *frameModel = [PDSpeechFrameModel new];
            PDSpeechTextModel *contentModel = [PDSpeechTextModel new];
            contentModel.text = modle.tts_content;
            contentModel.isTipMessage = NO;
            frameModel.contentModel = contentModel;
            [self.speechData insertObject:frameModel atIndex:0];
            [self.speechEditData insertObject:modle atIndex:0];
        }
        [self.speechTable reloadData];
    }else{
        self.hasData = NO;
        [self addTipMessageData];
    }
}
-(void) addTipMessageData{
    
    PDSpeechFrameModel *frame = [PDSpeechFrameModel new];
    PDSpeechTextModel *text = [PDSpeechTextModel new];
    text.text = R.say_pudding;
    text.isTipMessage = YES;
    frame.contentModel = text;
    [self.speechData addObject:frame];
    [self.speechTable reloadData];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.speechData.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDTTSHistoryChatCell *cell   = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDTTSHistoryChatCell class]) forIndexPath:indexPath];
    cell.frameModel = self.speechData[indexPath.row];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    [cell addGestureRecognizer:gesture];

    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDSpeechFrameModel *model = self.speechData[indexPath.row];
    return model.cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.myMenuController) {
        [self.myMenuController setMenuVisible:NO];
    }
}

- (void)tableTapGesture {
    if (self.myMenuController) {
        [self.myMenuController setMenuVisible:NO];
    }
    
    if(self.TagSpaceBlock){
        self.TagSpaceBlock();
    }
    
}

- (void)cellLongPress:(UILongPressGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
       
        [self becomeFirstResponder];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        self.myMenuController = menuController;
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:NSLocalizedString( @"copy", nil) action:@selector(copyAction:)];
        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString( @"delete_", nil) action:@selector(delAction:)];
        if (self.hasData) {
            menuController.menuItems = @[item,item1];
        } else {
            menuController.menuItems = @[item];
        }
        
        [menuController setTargetRect:gesture.view.frame inView:gesture.view.superview];
        [menuController setMenuVisible:NO animated:NO];
        [menuController setMenuVisible:YES animated:YES];
        [UIMenuController sharedMenuController].menuItems = nil;
        CGPoint point = [gesture locationInView:self.speechTable];
        NSIndexPath *indexPath = [self.speechTable indexPathForRowAtPoint:point];
        
        if (self.hasData) {
            PDTTSHistoryModle *model = self.speechEditData[indexPath.row];
            self.needEditModel = model;
        } else {
            PDSpeechFrameModel *model = self.speechData[indexPath.row];
            PDTTSHistoryModle *changeModel = [PDTTSHistoryModle new];
            changeModel.tts_content = model.contentModel.text;
            self.needEditModel = changeModel;
        }
    }
}

- (void)delAction:(UIMenuController *)sender {
//    [self.needEditModel remove];
    NSInteger index = [_speechEditData indexOfObject:self.needEditModel];
    if(index < _speechEditData.count){
        [_speechEditData removeObjectAtIndex:index];
    }
    [self addHistoryMessageData:_speechEditData];
}
- (void)copyAction:(UIMenuController *)sender {
    NSString *needCopyStr = self.needEditModel.tts_content;
    [UIPasteboard generalPasteboard].string = needCopyStr;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
@end
