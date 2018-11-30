//
//  PDeatureListHeaderContentView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDeatureListHeaderContentView.h"
extern float feature_min_height;
@implementation PDeatureListHeaderContentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLable.textColor = [UIColor whiteColor];
        titleLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLable];
       desLable = [[UILabel alloc] initWithFrame:CGRectZero];
        desLable.textColor = [UIColor whiteColor];
        desLable.numberOfLines = 0;
//        desLable.scrollEnabled = NO;
//        desLable.editable = NO;
        desLable.hidden = YES;
        desLable.backgroundColor = [UIColor clearColor];
        desLable.font = [UIFont systemFontOfSize:12];
//        desLable.numberOfLines = 0;
//        [desLable setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:desLable];
        
//        showButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [showButton setImage:[UIImage imageNamed:@"icon_arrow_up"] forState:0];
//        [showButton addTarget:self action:@selector(showButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:showButton];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:collectBtn];
        [collectBtn setImage:[UIImage imageNamed:@"list_uncollect"] forState:UIControlStateNormal];
        [collectBtn setImage:[UIImage imageNamed:@"list_collect"] forState:UIControlStateSelected];
//        [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-55);
//            make.top.bottom.mas_equalTo(0);
//            make.width.mas_equalTo(50);
//        }];
        [collectBtn addTarget:self action:@selector(collectDataHandle:) forControlEvents:UIControlEventTouchUpInside];
        self.collectBtn = collectBtn;
    }
    return self;
}

-(void)collectDataHandle:(UIButton*)btn{
    if (self.collectDataBlock) {
        self.collectDataBlock(btn);
    }
}
- (void)setShowContent:(BOOL)showContent{
  if(_showContent == showContent)
      return;
    
    _showContent = showContent;
//    [UIView animateWithDuration:.3 animations:^{
//        showButton.transform =showContent ? CGAffineTransformRotate(CGAffineTransformIdentity, M_PI) : CGAffineTransformIdentity;
//    }];
    //    [self imageFromView:self.view]
    [self showContent:.3];
}

- (void)showButtonAction:(id)sender{
    self.showContent = !_showContent;
    
}
- (void)showContent:(float)aniTime{
    self.collectBtn.frame = CGRectMake(self.width  - 55 , (feature_min_height - 50)/2, 50, 50);

    if(_showContent){
        desLable.hidden = NO;
        titleLable.frame = CGRectMake(10, 23, titleLable.width, 20);
        showButton.frame = CGRectMake(SC_WIDTH - 60, 15, 40, 35);
        CGSize size = [desLable sizeThatFits:CGSizeMake(SC_WIDTH - 60, 1000)];
        
        desLable.frame = CGRectMake(10, feature_min_height - 15, SC_WIDTH - 60, MIN(size.height, 50));
        
        [UIView animateWithDuration:aniTime animations:^{
            self.frame = CGRectMake(0, bottom - desLable.bottom - 15, SC_WIDTH, desLable.bottom + 15 );
        } completion:^(BOOL finished) {
        }];
    }else{
        titleLable.frame = CGRectMake(10, 23, titleLable.width, 20);
        showButton.frame = CGRectMake(SC_WIDTH - 60, 0, 40, feature_min_height);

        [UIView animateWithDuration:aniTime animations:^{
          
            self.frame = CGRectMake(0, bottom-feature_min_height, SC_WIDTH, feature_min_height);
            desLable.frame = CGRectMake(10, feature_min_height , SC_WIDTH - 20, 0);

        } completion:^(BOOL finished) {
            desLable.frame = CGRectMake(10, feature_min_height , SC_WIDTH - 20, 0);

            desLable.hidden = YES;

        }];
    }
}

/**
 *  @author 智奎宇, 16-02-05 16:02:02
 *
 *  展示标题和内容
 *
 *  @param titleString   标题
 *  @param contentString 内容
 *  @param Bottom        最底部
 */
- (void)showContentWithTitle:(NSString *)titleString ContentString:(NSString *)contentString Bottom:(float)bm{
    titleLable.text = titleString;
    [titleLable sizeToFit];
    desLable.text= contentString;
    bottom = bm;
    _showContent = YES;

    if(contentString == nil || [contentString length] == 0 ){
        showButton.hidden = YES;
        _showContent = NO;

    }
    [self showContent:.0];
}

- (void)middleToTitle:(float)progress{
    float middleXvalue = (self.width - titleLable.width)/2 - 10;
    titleLable.font = [UIFont systemFontOfSize:14 + progress * 6];
    [titleLable sizeToFit];
    titleLable.frame = CGRectMake(10 + middleXvalue * progress, 23 + 8 * progress, titleLable.width, 20);
    showButton.alpha = 1- progress;
}

@end
