//
//  PDSidePuddingCellView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDSidePuddingCellView.h"
// 充电状态
//typedef NS_ENUM(int ,PuddingChargeType) {
//    PuddingChargeType_Charging ,
//    PuddingChargeType_Full ,
//    PuddingChargeType_High,
//    PuddingChargeType_Middle,
//    PuddingChargeType_Low,
//    PuddingChargeType_Offline,
//};

@implementation InsetsLabel
@synthesize insets=_insets;
-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end

@interface PDSidePuddingCellView ()
@end
@implementation PDSidePuddingCellView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
   
        headImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        headImage.image = [UIImage imageNamed:@"setting_pudding_png"];
        headImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:headImage];
        
        
        nameLabel = [[InsetsLabel alloc]initWithFrame:CGRectZero];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:SX(17)];
        nameLabel.textColor = mRGBToColor(0x29c6ff);
        [self addSubview:nameLabel];
        nameLabel.backgroundColor =  [UIColor clearColor];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    nameLabel.text = title;
}

- (void)setImageNamed:(NSString *)imageNamed{
    if(imageNamed){
        headImage.image = [UIImage imageNamed:imageNamed];
    }else{
        headImage.image = [UIImage imageNamed:@"p1"];

    }
}

- (void)layoutSubviews {
    CGFloat WH = SX(35);
    CGFloat x = SX(27.5);
    headImage.frame = CGRectMake(x, (self.height - WH) * .5,WH, WH);
    CGFloat labelMaxWidth = self.width - SX(68);
    nameLabel.frame = CGRectMake(SX(82.5), (self.height - SX(25))/2 ,  labelMaxWidth, SX(25));
    
}

- (int)convertToInt:(NSString*)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

- (void)setModel:(RBDeviceModel *)model {
    _model = model;

    nameLabel.text = model.name;
    NSNumber *online = model.online;
    if ([online integerValue] == 0) {
        headImage.image = [UIImage imageNamed:@"setting_pudding_grey_png"];
    } else {
        headImage.image = [UIImage imageNamed:@"setting_pudding_png"];
    }
}

- (void)setSelected:(BOOL)selected{

}


@end
