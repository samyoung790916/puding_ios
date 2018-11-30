//
//  PDTTSSearchHistoryCell.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/2.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSSearchHistoryCell.h"
#import "PDTTSHistoryModle.h"

@interface PDTTSSearchHistoryCell()<UIScrollViewDelegate>{
    UIControl   * rightItemBtn;
    UIScrollView * scrollerView;
}

@end

@implementation PDTTSSearchHistoryCell

+ (UIControl *)createMarkButton:(float)height{
    UIControl * control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SX(94), height)];
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(SX(15), (height - SX(17.5))/2, SX(19), SX(17.5))];
    image.image  = [UIImage imageNamed:@"icon_history_del"];
    [image setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    [control addSubview:image];
    
    
    UILabel * lable= [[UILabel alloc] initWithFrame:CGRectMake(image.right + SX(5), (height - 20)/2, SX(40), 20)];
    lable.text = NSLocalizedString( @"delete_", nil) ;
    lable.userInteractionEnabled = NO;
    [lable setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    lable.font = [UIFont systemFontOfSize:SX(17)];
    lable.textColor = [UIColor whiteColor];
    [control addSubview:lable];
    
    control.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    return control;
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        
        
        scrollerView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollerView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        scrollerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        scrollerView.delegate = self;
        scrollerView.backgroundColor = [UIColor clearColor];
        scrollerView.showsHorizontalScrollIndicator = NO;
        scrollerView.contentSize = CGSizeMake(SC_WIDTH + SX(94), 1);
        [self.contentView addSubview:scrollerView];
        [scrollerView setUserInteractionEnabled:NO];
        [self.contentView addGestureRecognizer:scrollerView.panGestureRecognizer];
        
        rightItemBtn = [PDTTSSearchHistoryCell createMarkButton:self.height];
        rightItemBtn.frame = CGRectMake(SC_WIDTH, 0, SX(94), scrollerView.height);
        rightItemBtn.backgroundColor = mRGBToColor(0xff6a52);
        [rightItemBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightItemBtn];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _contentLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLable.numberOfLines = 0 ;
        _contentLable.userInteractionEnabled = NO;
        _contentLable.textColor = mRGBToColor(0x777c80);
        _contentLable.font = [UIFont systemFontOfSize:SX(17)];
        _contentLable.lineBreakMode = NSLineBreakByWordWrapping;
        [scrollerView addSubview:_contentLable];
    
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)deleteAction:(UIButton *)sender{
    if(_DeleteActionBlock){
        _DeleteActionBlock(_dataSource);
    }
    [scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];

}

- (void)setDataSource:(PDTTSHistoryModle *)dataSource{
    _dataSource = dataSource;
    float width = [UIScreen mainScreen].bounds.size.width - SX(28) - SX(15) - SX(8);
    
    float height = [PDTTSSearchHistoryCell textHeight:_dataSource.tts_content];
    _contentLable.frame = CGRectMake(SX(28), SX(14), width, height);
    _contentLable.text = _dataSource.tts_content;
    [_contentLable sizeToFit];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    if(scrollerView.contentOffset.x > 0)
        [scrollerView setContentOffset:CGPointMake(0, 0) animated:selected];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.x);
    if(scrollView.contentOffset.x < 0){
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    }else{
        rightItemBtn.left = scrollView.width - MIN(SX(94), scrollView.contentOffset.x);
    }
    
    
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if(fabs(velocity.x) >.8){
        
        if(velocity.x > 0 ){
            targetContentOffset->x = SX(94);
        }else{
            targetContentOffset->x = 0;
        }
        
    }else{
        if(scrollView.contentOffset.x > SX(94/2.0) ){
            targetContentOffset->x = scrollView.contentSize.width - scrollView.width - .5;
        }else{
            targetContentOffset->x = 0;
        }
    }
}

+ (float)textHeight:(NSString *) textString{
    float width = [UIScreen mainScreen].bounds.size.width - SX(28) - SX(15) - SX(8);
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [textString boundingRectWithSize:CGSizeMake(width, 200) options:options attributes:@{NSFontAttributeName:[UIFont  systemFontOfSize:SX(17)]} context:nil];
    float heigth = ceilf(rect.size.height) ;
    
  
    return heigth;
}

+ (float)cellHeight:(NSString *) textString{
    
    return [PDTTSSearchHistoryCell textHeight:textString] + SX(14) + SX(14);
    
}

@end
