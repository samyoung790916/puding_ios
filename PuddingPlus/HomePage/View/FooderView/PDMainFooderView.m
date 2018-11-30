//
//  PDMainFooderView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/22.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMainFooderView.h"
#import "RBMessageHandle+UserData.h"
#import "PDMainFooderCellView.h"

@interface PDMainFooderView()
@end


@implementation PDMainFooderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self resetBottomBtn];
    }
    return self;
}

- (void)setPuddingDouDouCell:(PDMainFooderCellView*)cellView index:(int)index{
    if(index == 0){
        cellView.tag = ButtonTypeSpake;
        [cellView.buttonAction setImage:[UIImage imageNamed:@"ic_bottom_bybd"] forState:UIControlStateNormal];
        cellView.desLable.text = R.play_pudding;
    }else if(index == 1){
        cellView.tag = ButtonTypeVideo;
        [cellView.buttonAction setImage:[UIImage imageNamed:@"ic_bottom_spth"] forState:UIControlStateNormal];
        cellView.desLable.text = @"远程看护";
    }else if(index == 2){
        cellView.tag = ButtonTypeClass;
        [cellView.buttonAction setImage:[UIImage imageNamed:@"ic_bottom_kcb"] forState:UIControlStateNormal];
        cellView.desLable.text = @"布丁课表";
    }else if(index == 3){
        cellView.tag = ButtonTypeData;
        [cellView.buttonAction setImage:[UIImage imageNamed:@"ic_bottom_bdyx"] forState:UIControlStateNormal];
        cellView.desLable.text = NSLocalizedString(@"pudding_resource", nil);
    }
}
- (void)setPuddingPlusCell:(PDMainFooderCellView*)cellView index:(int)index{
    if(index == 0){
        cellView.tag = ButtonTypeSpake;
        [cellView.buttonAction setImage:[UIImage imageNamed:@"ic_bottom_bybd"] forState:UIControlStateNormal];
        cellView.desLable.text = R.play_pudding;
    }else if(index == 1){
        cellView.tag = ButtonTypeVideo;
        [cellView.buttonAction setImage:[UIImage imageNamed:@"ic_bottom_spth"] forState:UIControlStateNormal];
        cellView.desLable.text = NSLocalizedString(@"remote_video", nil);
    }else if(index == 2){
        cellView.tag = ButtonTypeData;
        [cellView.buttonAction setImage:[UIImage imageNamed:@"ic_bottom_bdyx"] forState:UIControlStateNormal];
        cellView.desLable.text = NSLocalizedString(@"pudding_resource", nil);
    }
}
- (void)setPuddingXCell:(PDMainFooderCellView*)cellView index:(int)index{
    if(index == 0){
        cellView.tag = ButtonTypeVideo;
        [cellView.buttonAction setImage:[UIImage imageNamed:@"iocn_yuancheng"] forState:UIControlStateNormal];
        cellView.desLable.text = NSLocalizedString(@"remote_video", nil);
    }else if(index == 1){
        cellView.tag = ButtonTypeSpake;
        [cellView.buttonAction setImage:[UIImage imageNamed:@"icon_weiliao"] forState:UIControlStateNormal];
        cellView.desLable.text = NSLocalizedString(@"smart chat", nil);
    }else if(index == 2){
        cellView.tag = ButtonTypeData;
        [cellView.buttonAction setImage:[UIImage imageNamed:@"icon_guangchang"] forState:UIControlStateNormal];
        cellView.desLable.text = NSLocalizedString(@"pudding_recommend__", nil);
    }
}
- (void)updateRedPoint{
    
    // samyoung79
    if(RBDataHandle.currentDevice.isStorybox) {
        BOOL isNew = [RBMessageHandle fetchWechatNewMessage:RBDataHandle.currentDevice.mcid];
        PDMainFooderCellView * view = (PDMainFooderCellView *)[self viewWithTag:ButtonTypeSpake];
        if([view isKindOfClass:[PDMainFooderCellView class]]){
            [view setIsNew:isNew];
        }
    }
    
    
    
    
    
//    PDMainFooderCellView * view = (PDMainFooderCellView *)[self viewWithTag:ButtonTypeData];
//    if([view isKindOfClass:[PDMainFooderCellView class]]){
//        NSString * st =  [[NSUserDefaults standardUserDefaults] objectForKey:@"pudding_all_resouce_new"];
//        if(st == nil){
//            [view setIsNew:YES];
//        }else{
//            [view setIsNew:NO];
//        }
//    }
}
- (void)resetBottomBtn{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[PDMainFooderCellView class]]) {
            [view removeFromSuperview];
        }
    }
    float startXvalue = 10;
    int tabCount = 3;
    if ([RBDataHandle.currentDevice isPuddingPlus]) {
        tabCount = 4;
    }
    int fooderPdWidth = 0;
    if (RBDataHandle.currentDevice.isStorybox) {
        fooderPdWidth = 100;
    }
    float cellWidth = (self.width - startXvalue * 2-fooderPdWidth)/tabCount;
    self.backgroundColor = [UIColor clearColor];
    for(int i = 0 ; i < tabCount ; i++){
        PDMainFooderCellView * cellView = [[PDMainFooderCellView alloc] initWithFrame:CGRectMake(startXvalue + cellWidth * i, 0, cellWidth, 66)];
        @weakify(self);
        [cellView setMenuClickBlock:^(ButtonType type) {
            @strongify(self);
            if (self.MenuClickBlock)
                self.MenuClickBlock(type);
        }];
        [self setCell:cellView index:i];
        [self addSubview:cellView];
    }
    [self updateRedPoint];
}
- (void)setCell:(PDMainFooderCellView*)cellView index:(int)index{
    if (RBDataHandle.currentDevice.isPuddingPlus) { //samyoung79
        [self setPuddingDouDouCell:cellView index:index];
    }
    else if (RBDataHandle.currentDevice.isStorybox){
        [self setPuddingXCell:cellView index:index];
    }
    else{
        [self setPuddingPlusCell:cellView index:index];
    }
}
@end
