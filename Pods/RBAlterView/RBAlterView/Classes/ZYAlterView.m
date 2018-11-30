//
//  ZYAlterView.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/6/30.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "ZYAlterView.h"
#import "BlockButton.h"
#import "RBAPublic.h"

@implementation ZYAlterView
- (void)clearCacheData{
    _imageView = nil;
    _titleLable = nil;
    _describeLable = nil;
    _buttonItems = nil;
    _buttonLable = nil;
    _describeBg = nil;
}

- (void)reset{
    
    int heightType = 0;
    
    
    if(_buttonItems && _describeLable && _imageView){
        heightType = 6; //所有类型包含
    }else if(_buttonItems && _imageView){
        heightType = 5; //按钮 图片
    }else if(_buttonItems && _describeLable){
        heightType = 4; //按钮描述
    }else if(_imageView && _describeLable){
        heightType = 3; //图片描述
    }else if(_imageView){
        heightType = 2;  //图片提示
    }else if(_buttonItems){
        heightType = 7;  //按钮 标题
    }else {
        heightType = 1;  //只有标题
    }
    
    
    [self resetSubViewWithType:heightType];
}



- (void)resetSubViewWithType:(int) heightType{
    CGPoint center = self.center;
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)] ;
    
    self.layer.cornerRadius = ASX(16) ;
    self.clipsToBounds      = YES;
    self.backgroundColor = [UIColor whiteColor];
    _titleLable.frame = CGRectMake(ASX(20), ASX(17), self.frame.size.width - ASX(40), ASX(18));
    [self addSubview:_titleLable];
    
    float height = CGRectGetMaxY(_titleLable.frame);
    
    
    switch (heightType) {
        case 1:{
            CGSize titleSize = [self stringSize:17 :CGSizeMake(ASX(180) - ASX(40), ASX(100)) :_titleLable.text];
            self.layer.borderColor = [UIColor colorWithWhite:0.606 alpha:1.000].CGColor;
            self.layer.borderWidth = .3;
            _titleLable.frame = CGRectMake(ASX(20), ASX(20), ASX(180) - ASX(40), titleSize.height);
            float height = titleSize.height + ASX(17) * 2;
            self.frame = CGRectMake(center.x - ASX(180)/2, center.y - height/2, ASX(180), height);
            
        }
            break;
        case 2:{
            CGSize size = CGSizeMake(ASX(180), ASX(142));
            if(_loadAnimilType == ZYAlterExprossion){
                size.width = ASX(225);
            }
            CGSize titleSize = [self stringSize:17 :CGSizeMake(ASX(180) - ASX(40), ASX(100)) :_titleLable.attributedText];
            
            _titleLable.frame = CGRectMake(ASX(20), ASX(17), size.width - ASX(40), titleSize.height);
            _titleLable.backgroundColor = [UIColor clearColor];
            CGSize imagesize = _imageView.frame.size;
            
            
            _imageView.frame = CGRectMake((size.width - imagesize.width)/2.f, MAX(CGRectGetMaxY(_titleLable.frame) + ASX(20), size.height - imagesize.height - ASX(22)), imagesize.width, imagesize.height) ;
            [self addSubview:_imageView];
            
            self.frame = CGRectMake(0, 0, size.width, MAX(CGRectGetMaxY(_imageView.frame) + ASX(22), size.height));
            
        }
            break;
        case 3:{
            
            CGSize titleSize = [self stringSize:17 :CGSizeMake(ASX(180) - ASX(40), ASX(100)) :_titleLable.text];
            
            _titleLable.frame = CGRectMake(ASX(20), ASX(17), self.frame.size.width - ASX(40), titleSize.height);
            
            _titleLable.backgroundColor = [UIColor clearColor];
            CGSize imagesize = _imageView.frame.size;
            
            _imageView.frame = CGRectMake((self.frame.size.width - imagesize.width)/2.f, CGRectGetMaxY(_titleLable.frame) + ASX(20), imagesize.width, imagesize.height) ;
            [self addSubview:_imageView];
            
            
            CGSize desSize = [self stringSize:15 :CGSizeMake(self.frame.size.width - ASX(40), MAXFLOAT) :_describeLable.attributedText];
            [self setDescribeFrame:CGRectMake(ASX(20), CGRectGetMaxY(_imageView.frame) + ASX(17), self.frame.size.width - ASX(40), desSize.height) MinHeight:230];
            self.frame = CGRectMake(0, 0, self.frame.size.width, CGRectGetMaxY(_describeBg.frame) + ASX(25));
            
        }
            break;
        case 4:{
            
            CGSize desSize = [self stringSize:15 :CGSizeMake(self.frame.size.width - ASX(40), MAXFLOAT) :_describeLable.attributedText != nil ? _describeLable.attributedText : _describeLable.text];

            [self setDescribeFrame:CGRectMake(ASX(20), height - _titleLable.frame.size.height/2 + ASX(30.5), self.frame.size.width - ASX(40), desSize.height) MinHeight:230];
            
            if (desSize.width == 0) {
                desSize.height = 0;
                [self setDescribeFrame:CGRectMake(ASX(20), height - _titleLable.frame.size.height/2 + ASX(30.5), 0, 0) MinHeight:230];
            }
            
            [self addSubview:_describeBg];
            float bottom = CGRectGetMaxY(_describeBg.frame) + ASX(15);
            
            if(_buttonItems.count == 2){
                UIButton * bt1 = [_buttonItems objectAtIndex:0];
                UIButton * bt2 = [_buttonItems objectAtIndex:1];
                
                bt1.frame = CGRectMake(0, CGRectGetMaxY(_describeBg.frame)  + ASX(25) ,self.frame.size.width*0.5,ASX(45));
                bt2.frame = CGRectMake(self.frame.size.width*0.5,CGRectGetMaxY(_describeBg.frame)  + ASX(25) , self.frame.size.width*0.5, ASX(45));
                bt1.layer.borderColor = [UIColor lightGrayColor].CGColor;
                bt1.layer.borderWidth = 0.2;
                [self addSubview:bt1];
                [self addSubview:bt2];
                bottom = CGRectGetMaxY(bt1.frame);
            }else if(_buttonItems.count == 1){
                UIButton * bt1 = [_buttonItems objectAtIndex:0];
                
                bt1.frame = CGRectMake(0 , CGRectGetMaxY(_describeBg.frame)  + ASX(25),self.frame.size.width , ASX(45));
                [self addSubview:bt1];
                bottom = CGRectGetMaxY(bt1.frame);
                
            }
            self.frame = CGRectMake(0, 0, self.frame.size.width, bottom);
            
        }
            break;
        case 5:{
            
            CGSize size = self.frame.size;
            CGSize imagesize = _imageView.frame.size;
            
            CGSize titleSize = [self stringSize:17 :CGSizeMake(ASX(180) - ASX(40), ASX(100)) :_titleLable.text];
            
            _titleLable.frame = CGRectMake(ASX(20), ASX(17), self.frame.size.width - ASX(40), titleSize.height);
            float height = CGRectGetMaxY(_titleLable.frame);
            
            _imageView.frame = CGRectMake((self.frame.size.width - imagesize.width)/2.f, height  + ASX(20.5), imagesize.width, imagesize.height) ;
            [self addSubview:_imageView];
            
            UIView * menuBg = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame) + ASX(19), self.frame.size.width, ASX(67))];
            menuBg.backgroundColor = [UIColor colorWithRed:0.937 green:0.945 blue:0.953 alpha:1.000];
            [self addSubview:menuBg];
            
            if(_buttonItems.count == 2){
                UIButton * bt1 = [_buttonItems objectAtIndex:0];
                UIButton * bt2 = [_buttonItems objectAtIndex:1];
                
                bt1.frame = CGRectMake(ASX(15), CGRectGetMaxY(_imageView.frame) + ASX(25), ASX(108), ASX(37));
                bt2.frame = CGRectMake(self.frame.size.width - ASX(108) - ASX(15), CGRectGetMaxY(_imageView.frame) + ASX(35), ASX(108), ASX(37));
                [self addSubview:bt1];
                [self addSubview:bt2];
            }else if(_buttonItems.count == 1){
                UIButton * bt1 = [_buttonItems objectAtIndex:0];
                
                float width = self.frame.size.width;
                
                bt1.frame = CGRectMake((self.frame.size.width - width)/2 , CGRectGetMaxY(_imageView.frame) + ASX(25),width , ASX(37));
                [self addSubview:bt1];
                
            }
            
            
            self.frame = CGRectMake(0, 0, size.width, CGRectGetMaxY(menuBg.frame));
            
            break;
        }
        case 6:{
            
            CGSize size = self.frame.size;
            CGSize imagesize = _imageView.frame.size;
            
            _imageView.frame = CGRectMake((self.frame.size.width - imagesize.width)/2.f, height - _titleLable.frame.size.height/2 + ASX(20.5), imagesize.width, imagesize.height) ;
            [self addSubview:_imageView];
            
            
            NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            CGRect rect = [_describeLable.text boundingRectWithSize:CGSizeMake(self.frame.size.width - ASX(40), MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            [self setDescribeFrame: CGRectMake(ASX(20), CGRectGetMaxY(_imageView.frame) + ASX(20.5), self.frame.size.width - ASX(40), rect.size.height) MinHeight:200];
            [self addSubview:_describeBg];
            
            UIView * menuBg = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_describeBg.frame) + ASX(19), self.frame.size.width,ASX(67))];
            menuBg.backgroundColor = [UIColor colorWithRed:0.937 green:0.945 blue:0.953 alpha:1.000];
            [self addSubview:menuBg];
            
            if(_buttonItems.count == 2){
                UIButton * bt1 = [_buttonItems objectAtIndex:0];
                UIButton * bt2 = [_buttonItems objectAtIndex:1];
                
                bt1.frame = CGRectMake(ASX(15), CGRectGetMaxY(_describeBg.frame) + ASX(25), ASX(108), ASX(37));
                bt2.frame = CGRectMake(self.frame.size.width - ASX(108) - ASX(15), CGRectGetMaxY(_describeBg.frame) + ASX(25), ASX(108), ASX(37));
                [self addSubview:bt1];
                [self addSubview:bt2];
            }else if(_buttonItems.count == 1){
                UIButton * bt1 = [_buttonItems objectAtIndex:0];
                CGSize titleSize = [self stringSize:17 :CGSizeMake(ASX(200), ASX(37)) :[bt1 titleForState:0]];
                
                float width = MAX(ASX(108), titleSize.width) + ASX(30);
                
                bt1.frame = CGRectMake((self.frame.size.width - width)/2 , CGRectGetMaxY(_describeBg.frame) + ASX(25),width , ASX(37));
                [self addSubview:bt1];
                
            }
            
            
            self.frame = CGRectMake(0, 0, size.width, CGRectGetMaxY(menuBg.frame));
            break;
        }
        case 7: {
            
            float bottom = 0;
            
            if(_buttonItems.count == 2){
                UIButton * bt1 = [_buttonItems objectAtIndex:0];
                UIButton * bt2 = [_buttonItems objectAtIndex:1];
                
                bt1.frame = CGRectMake(0, CGRectGetMaxY(_titleLable.frame)  + ASX(25) ,self.frame.size.width*0.5,ASX(45));
                bt2.frame = CGRectMake(self.frame.size.width*0.5,CGRectGetMaxY(_titleLable.frame)  + ASX(25) , self.frame.size.width*0.5, ASX(45));
                bt1.layer.borderColor = [UIColor lightGrayColor].CGColor;
                bt1.layer.borderWidth = 0.5;
                [self addSubview:bt1];
                [self addSubview:bt2];
                bottom = CGRectGetMaxY(bt1.frame);
            }else if(_buttonItems.count == 1){
                UIButton * bt1 = [_buttonItems objectAtIndex:0];
                
                bt1.frame = CGRectMake(0 , CGRectGetMaxY(_titleLable.frame)  + ASX(25),self.frame.size.width , ASX(45));
                [self addSubview:bt1];
                bottom = CGRectGetMaxY(bt1.frame);
                
            }
            self.frame = CGRectMake(0, 0, self.frame.size.width, bottom);
            break;
        }
            
            
        default:
            break;
    }
    
    self.center = center;
    
    
    
}

- (CGSize)stringSize:(float)fontSize :(CGSize)maxSize :(NSObject *)string{
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    if([string isKindOfClass:[NSAttributedString class]]){
        rect = [(NSAttributedString *)string boundingRectWithSize:maxSize options:options context:nil];
    }else{
        rect = [(NSString *)string boundingRectWithSize:maxSize options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName : style} context:nil];
    }
    
    rect.size.height = ceilf(rect.size.height + 2);
    return rect.size;
}
- (void)setDescribeAttributeString:(NSAttributedString *)describeAttributeString {
    _describeAttributeString = [describeAttributeString copy];
    if(!_describeLable){
        _describeBg = [[UIScrollView alloc] initWithFrame:CGRectMake(ASX(20), ASX(17), self.frame.size.width - ASX(40), ASX(1))];
        _describeBg.showsVerticalScrollIndicator = NO;
        _describeBg.showsHorizontalScrollIndicator = NO;
        
        _describeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _describeBg.frame.size.width - ASX(40), ASX(1))];
        _describeLable.font = [UIFont systemFontOfSize:15];
        _describeLable.numberOfLines = 0;
        _describeLable.textColor = aRGBToColor(0x505a66);
        _describeLable.textAlignment = NSTextAlignmentRight ;
        if(describeAttributeString)
            _describeLable.attributedText = describeAttributeString;
        [_describeBg addSubview:_describeLable];
        [self addSubview:_describeBg];
    }
}

- (void)setDescribeFrame:(CGRect)frame MinHeight:(float)minHeight{
    _describeBg.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, MIN(minHeight, frame.size.height));
    _describeLable.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    _describeBg.contentSize = frame.size;
}

- (void)setDescribeString:(NSString *)describeString{
    
    _describeString = [describeString copy];
    if([describeString length] == 0){
        _describeLable.attributedText = nil;
        return;
    }
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:describeString];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:describeString.length < 15 ? NSTextAlignmentCenter : NSTextAlignmentLeft];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [describeString length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [describeString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:aRGBToColor(0x505a66) range:NSMakeRange(0, [describeString length])];
    self.describeAttributeString = attributedString;
    
}

- (float)desMaxHeight{
    return [self stringSize:15 :CGSizeMake(self.frame.size.width - ASX(40), 100) :_describeLable.attributedText].height;
    
}

- (void)setAnimailImagesNamed:(NSArray *)AnimailImagesNamed{
    [_imageView stopAnimating];
    _AnimailImagesNamed = [AnimailImagesNamed copy];
    NSMutableArray * imageArray = [NSMutableArray new];
    for (int i = 0; i < AnimailImagesNamed.count; i++) {
        NSString * imageName = [AnimailImagesNamed objectAtIndex:i];
        UIImage * image = [UIImage imageNamed:imageName];
        if(!image){
            continue;
        }
        [imageArray addObject:image];
        
        
    }
    if(imageArray.count == 0)
        return;
    UIImage * lastImage = [imageArray lastObject];
    
    if(!_imageView){
        CGSize size = lastImage.size;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ASX(size.width), ASX(size.height))];
        [self addSubview:_imageView];
    }
    
    _imageView.image = lastImage;
    _imageView.animationImages = imageArray;
    _imageView.animationDuration = (1.0/18.0f) * (float)imageArray.count;
    //    _imageView.animationRepeatCount = 1;
    [_imageView performSelector:@selector(startAnimating) withObject:nil afterDelay:.2];
}

- (void)setImageName:(NSString *)imageName{
    if(imageName == nil)
        return;
    
    _imageName = [imageName copy] ;
    UIImage * image = [UIImage imageNamed:imageName];
    if(!_imageView && image){
        CGSize size = image.size;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ASX(size.width), ASX(size.height))];
        [self addSubview:_imageView];
    }
    _imageView.image = image;
}

- (void)deallocBlockData{
    
    BlockButton * bt1 ;
    if(_buttonItems.count > 0){
        bt1 = [_buttonItems objectAtIndex:0];
    }
    
    BlockButton * bt2 ;
    if(_buttonItems.count > 1){
        bt2 = [_buttonItems objectAtIndex:1];
    }
    if([bt1 isKindOfClass:[BlockButton class]]){
        [bt1 setButtonAction:nil];
    }
    if([bt2 isKindOfClass:[BlockButton class]]){
        [bt2 setButtonAction:nil];
    }
    _ClickActionBlock = nil;
}


- (void)setTitleString:(NSString *)titleString{
    _titleString = [titleString copy];
    if(!_titleLable && titleString){
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(ASX(20), ASX(20), self.frame.size.width - ASX(40), ASX(23))];
        //        _titleLable.font = [self GetFontSize:2];
        [_titleLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textColor = aRGBToColor(0x505a66);
        _titleLable.textAlignment = NSTextAlignmentCenter ;
        _titleLable.numberOfLines = 0;
        _titleLable.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_titleLable];
        
    }
    _titleLable.text = titleString;
}

- (void)setBtnitems:(NSArray *)btnitems{
    if(!_buttonItems && [btnitems count] > 0){
        NSMutableArray * array = [NSMutableArray array] ;
        if(btnitems.count == 2){
            BlockButton * cancleBtn = [BlockButton buttonWithType:UIButtonTypeCustom];
            //            cancleBtn.layer.cornerRadius = SX(37)/2.f;
            //            cancleBtn.clipsToBounds = YES;
            [cancleBtn setTitle:[btnitems objectAtIndex:0] forState:UIControlStateNormal];
            cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [cancleBtn setTitleColor:aRGBToColor(0x6a7680) forState:UIControlStateNormal];
            [cancleBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
            [cancleBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [cancleBtn setButtonAction:^(UIButton * btn) {
                if(_ClickActionBlock){
                    _ClickActionBlock(0);
                }
            }];
            [self addSubview:cancleBtn];
            
            
            BlockButton * contineBtn = [BlockButton buttonWithType:UIButtonTypeCustom];
            //            contineBtn.layer.cornerRadius = SX(37)/2.f;
            //            contineBtn.clipsToBounds = YES;
            [contineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [contineBtn setTitle:[btnitems objectAtIndex:1] forState:UIControlStateNormal];
            contineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            //            [contineBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor colorWithRed:0.247 green:0.612 blue:1.000 alpha:1.000]] forState:UIControlStateNormal];
            [contineBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:RBContentColor] forState:UIControlStateNormal];
            [contineBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor colorWithRed:0.220 green:0.533 blue:0.878 alpha:1.000]] forState:UIControlStateHighlighted];
            [contineBtn setButtonAction:^(UIButton * btn) {
                if(_ClickActionBlock){
                    _ClickActionBlock(1);
                }
            }];
            [self addSubview:contineBtn];
            
            
            
            [array addObject:cancleBtn];
            [array addObject:contineBtn];
            
        }else if(btnitems.count == 1){
            
            BlockButton * contineBtn = [BlockButton buttonWithType:UIButtonTypeCustom];
            //            contineBtn.layer.cornerRadius = SX(37)/2.f;
            //            contineBtn.clipsToBounds = YES;
            
            [contineBtn setTitle:[btnitems objectAtIndex:0] forState:UIControlStateNormal];
            contineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [contineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self addSubview:contineBtn];
            //            [contineBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor colorWithRed:0.247 green:0.612 blue:1.000 alpha:1.000]] forState:UIControlStateNormal];
            [contineBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:RBContentColor] forState:UIControlStateNormal];
            [contineBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor colorWithRed:0.220 green:0.533 blue:0.878 alpha:1.000]] forState:UIControlStateHighlighted];
            [contineBtn setButtonAction:^(UIButton * btn) {
                if(_ClickActionBlock){
                    _ClickActionBlock(0);
                }
                
            }];
            [array addObject:contineBtn];
        }
        
        _buttonItems = [array copy];
    }
}

- (void)loadAnimil:(ZYAlterType)key{
    NSMutableArray * array = [NSMutableArray new] ;
    
    _loadAnimilType = key;
    
    switch (key) {
        case ZYAlterLoading: {
            for(int i = 0 ; i < 24 ;i ++){
                if(i < 10){
                    [array addObject:[NSString stringWithFormat:@"donghua_dialog_loading_00%d.png",i]];
                }else{
                    [array addObject:[NSString stringWithFormat:@"donghua_dialog_loading_0%d.png",i]];
                }
            }
            break;
        }
        case ZYAlterFail: {
            for(int i = 0 ; i < 24 ;i ++){
                if(i < 10){
                    [array addObject:[NSString stringWithFormat:@"donghua_dialog_fail_00%d.png",i]];
                }else{
                    [array addObject:[NSString stringWithFormat:@"donghua_dialog_fail_0%d.png",i]];
                }
            }
            break;
        }
        case ZYAlterScuess: {
            for(int i = 0 ; i < 24 ;i ++){
                if(i < 10){
                    [array addObject:[NSString stringWithFormat:@"donghua_dialog_success_00%d.png",i]];
                }else{
                    [array addObject:[NSString stringWithFormat:@"ddonghua_dialog_success_0%d.png",i]];
                }
            }
            break;
        }
        case ZYAlterExprossion: {
            for(int i = 1 ; i < 5 ;i ++){
                [array addObject:[NSString stringWithFormat:@"img_dialog_emoji_0%d.png",i]];
                
            }
            break;
        }
        default: {
            break;
        }
    }
    
    self.AnimailImagesNamed = array;
    
}


- (void)dealloc{
    
}

@end
