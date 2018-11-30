//
//  PDTTSHabitCultureCell.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSHabitCultureCell.h"


@interface TestScrol : UIScrollView

@end


@implementation TestScrol
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}


@end

@interface PDTTSHabitCultureCell()<UIScrollViewDelegate>{
    UIImageView * imageView;
    UIView      * subView;
    UIControl   * rightItemBtn;
    TestScrol * scrollerView;
    
    UIButton    * unMarkBtn;
}

@end


@implementation PDTTSHabitCultureCell

+ (UIControl *)createMarkButton:(float)height{
    UIControl * control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SX(94), height)];
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(SX(15), (height - SX(17.5))/2, SX(19), SX(17.5))];
    image.image  = [UIImage imageNamed:@"icon_fav_unselected"];
    [image setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    [control addSubview:image];
    
    
    UILabel * lable= [[UILabel alloc] initWithFrame:CGRectMake(image.right + SX(5), (height - 20)/2, SX(40), 20)];
    lable.text = NSLocalizedString( @"collection", nil);
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
        
        
        scrollerView = [[TestScrol alloc] initWithFrame:self.bounds];
        scrollerView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        scrollerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        scrollerView.delegate = self;
        scrollerView.backgroundColor = [UIColor clearColor];
        scrollerView.showsHorizontalScrollIndicator = NO;
        scrollerView.contentSize = CGSizeMake(SC_WIDTH + SX(94), 1);
        [self.contentView addSubview:scrollerView];
        [scrollerView setUserInteractionEnabled:NO];
        [self.contentView addGestureRecognizer:scrollerView.panGestureRecognizer];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _contentLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLable.numberOfLines = 0 ;
        _contentLable.userInteractionEnabled = NO;
        _contentLable.textColor = mRGBToColor(0x777c80);
        _contentLable.font = [UIFont systemFontOfSize:SX(17)];
        _contentLable.lineBreakMode = NSLineBreakByWordWrapping;
        [scrollerView addSubview:_contentLable];
        
        imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"icon_habit_custom"];
        [scrollerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(SX(25));
            make.left.mas_equalTo(19);
            make.centerY.mas_equalTo(scrollerView.mas_centerY);
        }];
        
        unMarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(SC_WIDTH - SX(15) - SX(30), (self.height - SX(40))/2, SX(40), SX(40))];
        [unMarkBtn setImage:[UIImage imageNamed:@"icon_fav_selected"] forState:0];
        [unMarkBtn addTarget:self action:@selector(unMarkAction:) forControlEvents:UIControlEventTouchUpInside];
        [unMarkBtn setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [self addSubview:unMarkBtn];
        
        rightItemBtn = [PDTTSHabitCultureCell createMarkButton:self.height];
        rightItemBtn.frame = CGRectMake(SC_WIDTH , 0, SX(94), scrollerView.height);
        rightItemBtn.backgroundColor = mRGBToColor(0xffb152);
        [rightItemBtn addTarget:self action:@selector(markAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightItemBtn];
        


        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)unMarkAction:(id)sender{
    if(_MarkActionBlock){
        _MarkActionBlock(_dataSource,NO);
    }
}

- (void)markAction:(id)sender{
    if(_MarkActionBlock){
        _MarkActionBlock(_dataSource,YES);
    }
    [scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];

}

-(void)setDataSource:(PDHabitCultureModle *)dataSource{
    if(scrollerView.contentOffset.x > 0)
        [scrollerView setContentOffset:CGPointMake(0, 0)];

    _dataSource = dataSource;
    
    unMarkBtn.hidden = !dataSource.isMark;
    scrollerView.scrollEnabled = !_dataSource.isMark;
    

    float width = [UIScreen mainScreen].bounds.size.width - SX(50) - SX(15) - SX(28);

    float height = [PDTTSHabitCultureCell textHeight:_dataSource.content];
    _contentLable.frame = CGRectMake(SX(50), SX(12), width, height);
    _contentLable.text = _dataSource.content;
    _contentLable.backgroundColor = [UIColor clearColor];
    
    subView.frame = CGRectMake(SX(15), SX(6), MIN([UIScreen mainScreen].bounds.size.width - SX(30), _contentLable.right - SX(2) ), height  + SX(12) );
    subView.layer.cornerRadius = SX(33)/2;
    subView.clipsToBounds = YES;
    imageView.image = [UIImage imageNamed:@"icon_habit_custom"];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    if(scrollerView.contentOffset.x > 0)
        [scrollerView setContentOffset:CGPointMake(0, 0) animated:selected];
}


- (void)tapTarget:(id)sender{

    [scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
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
    
    
    NSLog(@"scrollViewWillEndDragging");

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");


}
+ (float)textHeight:(NSString *) textString{
    float width = [UIScreen mainScreen].bounds.size.width - SX(50) - SX(15) - SX(28);
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [textString boundingRectWithSize:CGSizeMake(width, 200) options:options attributes:@{NSFontAttributeName:[UIFont  systemFontOfSize:SX(17)]} context:nil];
    float heigth = ceilf(rect.size.height) ;
    return heigth;
}

+ (float)cellHeight:(NSString *) textString{
   
   return [PDTTSHabitCultureCell textHeight:textString] + SX(12) + SX(12);
    
}
@end
