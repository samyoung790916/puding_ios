//
//  UIViewController+RBNodataView.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/8.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "UIViewController+RBNodataView.h"
#import "AFNetworkReachabilityManager.h"

@interface RBNetNodataView : UIView{
    
}
@property(nonatomic,strong) UIImage * tipImage;
@property(nonatomic,strong) NSString * tipString;

@property(nonatomic,weak) UIImageView * tipImageView;
@property(nonatomic,weak) UILabel * tipLable;
-(instancetype)initWithTop:(NSNumber *)number;
@end


@implementation RBNetNodataView

-(instancetype)initWithTop:(NSNumber *)number{
    if(self = [super init]){
        // 网络连接失败时的提示
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_data_empty"]];
        [self addSubview:img];
        
        
        @weakify(self)
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            if(number){
                make.top.equalTo(number);
            }else{
                make.centerY.equalTo(self.mas_centerY).offset(-50);

            }
            make.centerX.equalTo(self.mas_centerX);
            
        }];
        self.tipImageView = img;
        
        
        UILabel *lab = [[UILabel alloc] init];
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = mRGBToColor(0xa2abb2);
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(img.mas_bottom).offset(15);
            make.centerX.equalTo(img.mas_centerX);
            make.width.equalTo(self.mas_width).offset(-(SX(50)));
        }];
        
        self.tipLable = lab;
    }
    return self;
}

- (void)setTipImage:(UIImage *)tipImage{
    [self.tipImageView setImage:tipImage];
}

- (void)setTipString:(NSString *)tipString{
    self.tipLable.text = tipString;
}

@end



@implementation UIViewController (RBNodataView)
@dynamic noImageIcon,tipString,ShowNoDataViewBlock,nd_bg_disableCover;

#pragma mark - set get
-(void)setNoDataViewTop:(NSNumber *)noDataViewTop{
    objc_setAssociatedObject(self, @"noDataViewTop", noDataViewTop, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)noDataViewTop{
    return objc_getAssociatedObject(self, @"noDataViewTop");
}

- (void)setNd_bg_disableCover:(BOOL)nd_bg_disableCover{
    objc_setAssociatedObject(self, @"nd_bg_disableCover", @(nd_bg_disableCover), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(BOOL)nd_bg_disableCover{
    return [objc_getAssociatedObject(self, @"nd_bg_disableCover") boolValue];
}

- (void (^)(BOOL))ShowNoDataViewBlock{
    return objc_getAssociatedObject(self, @"ShowNoDataViewBlock");
}

- (void)setShowNoDataViewBlock:(void (^)(BOOL))ShowNoDataViewBlock{
    objc_setAssociatedObject(self, @"ShowNoDataViewBlock", ShowNoDataViewBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)noNetTipString{
    return objc_getAssociatedObject(self, @"noNetTipString");
}

- (void)setNoNetTipString:(NSString *)noNetTipString{
    objc_setAssociatedObject(self, @"noNetTipString", noNetTipString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTipString:(NSString *)tipString{
    objc_setAssociatedObject(self, @"tipString", tipString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


-(NSString *)tipString{
    return objc_getAssociatedObject(self, @"tipString");
}

- (void)setNoImageIcon:(NSString  *)noImageIcon{
    objc_setAssociatedObject(self, @"noImageIcon", noImageIcon, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString  *)noImageIcon{
    
    NSString * str =  objc_getAssociatedObject(self, @"noImageIcon");
    if(str == nil){
        str = @"img_data_empty";
    }
    return str;
}

- (BOOL)IsShowNodataView{
    return [objc_getAssociatedObject(self, @"IsShowNodataView") boolValue];
}

- (void)setIsShowNodataView:(BOOL)showView{
    objc_setAssociatedObject(self, @"IsShowNodataView", @(showView), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setShowContentView:(UIView *)showContentView{
    objc_setAssociatedObject(self, @"showContentView", showContentView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)showContentView{
    UIView * contentView =  objc_getAssociatedObject(self, @"showContentView");
    if(contentView == nil)
        return self.view;
    
    return contentView;
}

- (NSString *)getTipString{
    NSString * tipString ;
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        if(self.noNetTipString){
            tipString = self.noNetTipString;
        }else{
            tipString = NSLocalizedString( @"server_go_wrong_tips", nil);
        }
        
    }else{
        if([self.tipString mStrLength] == 0)
            tipString = NSLocalizedString( @"not_got_data_ps_later", nil);
        else
            tipString = self.tipString;
    }
    return tipString;
}

- (RBNetNodataView *)getNodataView{
    __block UIView * contentView = [self showContentView];

    RBNetNodataView * v = (RBNetNodataView *)[contentView viewWithTag:[@"1" hash]];
    v.hidden = NO;
    if([v isKindOfClass:[RBNetNodataView class]]){
        return v;
    }
    RBNetNodataView * noDataView = [[RBNetNodataView alloc] initWithTop:self.noDataViewTop];
    [self setIsShowNodataView:YES];
    noDataView.tag = [@"1" hash];
    [contentView addSubview:noDataView];
    
    if(!self.nd_bg_disableCover)
        noDataView.backgroundColor = mRGBToColor(0xf7f7f7);
    
    float offset = (contentView.frame.size.height >= SC_HEIGHT - 10) ? NAV_HEIGHT : 20;
    
    
    noDataView.userInteractionEnabled = NO;
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.right.equalTo(contentView.mas_right);
        make.top.equalTo(@(offset));
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    return noDataView;
}

#pragma mark - public methoc

- (void)showNoDataView:(UIView*) inView{
    [self setShowContentView:inView];
    [self showNoDataView];
}



- (void)showNoDataView{
    if(self.ShowNoDataViewBlock){
        self.ShowNoDataViewBlock(YES);
    }
    NSString * tipString = [self getTipString];
   
    RBNetNodataView * nodataView = [self getNodataView];
    nodataView.userInteractionEnabled = NO;
    nodataView.tipString = tipString;
    nodataView.tipImage = [UIImage imageNamed:self.noImageIcon];
    if(!self.nd_bg_disableCover)
        nodataView.backgroundColor = mRGBToColor(0xf7f7f7);

}

- (void)hiddenNoDataView{
    if(self.ShowNoDataViewBlock){
        self.ShowNoDataViewBlock(NO);
    }
    UIView * showView = [self showContentView];
    if(showView == nil)
        showView = self.view;
    UIView * v = [self.view viewWithTag:[@"1" hash]];
    [v removeFromSuperview];

}
@end
