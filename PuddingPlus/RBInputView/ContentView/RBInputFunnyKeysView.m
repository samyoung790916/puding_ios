//
//  RBInputFunnyKeysView.m
//  RBInputView
//
//  Created by kieran on 2017/2/9.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBInputFunnyKeysView.h"
#import "RBInputCotentViewModle.h"
#import "RBInputFunnyKeysCell.h"
@interface RBInputFunnyKeysView(){
    RBInputFunnyKeysViewModle * viewModle;
    UIView * contentView;

}

@end



@implementation RBInputFunnyKeysView
@synthesize SendPlayCmdBlock = _SendPlayCmdBlock;
@synthesize SelectTextBlock = _SelectTextBlock;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        viewModle = [[RBInputFunnyKeysViewModle alloc] init];
        
        
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - SX(50))];
        contentView.backgroundColor = mRGBToColor(0xf7f7f7);
        [self addSubview:contentView];
        
        
        
        UIButton * menuView = [[UIButton alloc] initWithFrame:CGRectMake(0, contentView.bottom, self.width, SX(50))];
        [menuView setTitle:NSLocalizedString( @"change_change", nil) forState:0];
        [menuView setTitleColor:mRGBToColor(0xffb152) forState:UIControlStateNormal];
        menuView.layer.borderWidth = .5;
        menuView.layer.borderColor = mRGBToColor(0xe0e3e6).CGColor;
        [menuView setBackgroundColor:[UIColor whiteColor]];
        [menuView addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuView];

        [self loadData];
    }
    return self;
}



- (void)loadData{
    [viewModle changeFunnyKeys:^{
       dispatch_async(dispatch_get_main_queue(), ^{
           [self resetSubviews];
       });
    }];

}


- (void)resetSubviews{
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float xValue = SX(20);
    float yValue = SX(20);
    float xBetween = SX(10);
    float maxWidth = contentView.width -  xValue ;
    
    for(int i = 0 ; i < [viewModle.funnyKeys count] ; i ++){
        PDFunnyResouseModle * modle = [viewModle.funnyKeys objectAtIndex:i] ;
        
        RBInputFunnyKeysCell * cell = [[RBInputFunnyKeysCell alloc] initWithFrame:CGRectZero];
        [cell setDataSource:modle] ;
        cell.tag = i + 1000;
        [cell addTarget:self action:@selector(messageCellAction:) forControlEvents:UIControlEventTouchUpInside] ;
        if(xValue + cell.width - xBetween > maxWidth){
            xValue = SX(20);
            yValue += cell.height + SX(12);
        }
        if(yValue >= self.height - SX(42) - 10 - cell.height)
            break;
        
        cell.frame = CGRectMake(xValue, yValue, cell.width, cell.height) ;
        [contentView addSubview:cell];
        xValue = cell.right + xBetween;
    }
    
    
}

- (void)messageCellAction:(RBInputFunnyKeysCell *) sender{
    if([sender isKindOfClass:[RBInputFunnyKeysCell class]]){
        if([sender.dataSource.type intValue] == 0){
            if(self.SelectTextBlock){
                __weak typeof(self) weakSelf = self;
                self.SelectTextBlock(sender.dataSource.name,weakSelf);
            }

        }else{
            if(self.SendPlayCmdBlock){
                __weak typeof(self) weakSelf = self;
                self.SendPlayCmdBlock(sender.dataSource.content,weakSelf);
            }
        }
    }
}

#pragma mark -  RBInputInterface

///更新内部数据
- (void)updateData{


}
@end
