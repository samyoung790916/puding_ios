//
//  RBInputFunnyKeysCell.m
//  RBInputView
//
//  Created by kieran on 2017/2/9.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBInputFunnyKeysCell.h"
#import "UIImageView+YYWebImage.h"


@implementation RBInputFunnyKeysCell

#pragma mark - 设置数据源
- (void)setDataSource:(PDFunnyResouseModle *)dataSource{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _dataSource =dataSource;
    
    NSString * text = _dataSource.name;
    NSNumber * type = _dataSource.type;
    NSString * icon = _dataSource.icon;
    if(![text length]){
        text = @"";
    }
    
    UIImage * image = nil;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SX(13)]}];
    if([type intValue] == 1){ // 声音
        image = mImageByName(@"icon_tts_voice.png");
    }else if([type intValue] == -1){ //刷新
        image = mImageByName(@"icon_tts_refresh.png");
    }
    
    if (icon.length>0) {
        image = mImageByName(@"icon_tts_voice.png");
    }
    
    float width = 0;
    float height = SX(30);
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, (height - SX(15))/2, size.width, SX(15))] ;
    lable.text = text;
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = mRGBToColor(0x505a66) ;
    lable.font = [UIFont systemFontOfSize:SX(13)];
    [self addSubview:lable];
    
    if(image){
        CGSize imageSize = image.size;
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SX(11), (height - imageSize.height)/2, imageSize.width, imageSize.height)];
        imageView.image = image;
        [self addSubview:imageView] ;
        width = size.width + image.size.width + SX(26);
        lable.left = imageView.right + SX(1);
        
        if ([icon length] > 0) {
            [imageView setImageWithURL:[NSURL URLWithString:icon] placeholder:nil];
        }
        
        
    }else{
        lable.left = SX(14);
        width = size.width + SX(26);
    }
    if(dataSource == nil)
        return;
    
    self.frame = CGRectMake(0, 0, width, height);
    
    self.layer.cornerRadius = height/2.f;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.backgroundColor = mRGBToColor(0xf5f5f5);
}
@end
