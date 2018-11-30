//
//  RBVideoMessageView.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/9/24.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import "RBVideoMessageView.h"
#import "UIImageView+YYWebImage.h"
#import "SandboxFile.h"
#import "PDTTSChildMenuView.h"
#import "PDTTSDataHandle.h"
#import "NSObject+YYAdd.h"

@implementation RBVideoMessageCell

#pragma mark - 设置数据源
- (void)setDataSource:(PDFunnyResouseModle *)dataSource{

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _dataSource =dataSource;
    
    NSString * text = _dataSource.name;
    NSNumber * type = _dataSource.type;
    NSString * icon = _dataSource.icon;
    
    
    if(![text mIsStr]){
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
        
        if ([icon mStrLength] > 0) {
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

@interface RBVideoMessageView (){
    UIView * contentView;
    PDTTSChildMenuView * menuView;
    NSInteger selectRowIndex;
    UIView * selectView;


}
/** 换一换的索引 */
//@property (nonatomic, assign) NSInteger changeIndex;


@end



@implementation RBVideoMessageView

- (id)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - SX(50))];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        
        
        menuView = [[PDTTSChildMenuView alloc] initWithFrame:CGRectMake(0, contentView.bottom, self.width, SX(50))];
        @weakify(self);
        [menuView setMenuActionBlock:^(TTSMenuActionStyle menuType) {
            @strongify(self);
            [self menuClickAction:menuType];
        }];
        [menuView setAddButtonTitle:NSLocalizedString( @"change_change", nil)];
        menuView.normailStyle = TSMenuNormalAdd;
        
        [self addSubview:menuView];
        
        self.messageArray = [NSMutableArray new];
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadLocalMessage];

    }
    
    return self;

}

#pragma mark - PDTTSChildMenuView Button action

- (void)menuClickAction:(TTSMenuActionStyle)type{
    switch (type) {
        case TTSMenuActionStyleBack: {
            LogWarm(@"TTSMenuActionStyleBack");
            if(self.CloseViewBlock){
                self.CloseViewBlock();
            }
            break;
        }
        case TTSMenuActionStyleCancle: {
            LogWarm(@"TTSMenuActionStyleCancle");
            selectRowIndex = -1;
            menuView.isSelected = NO;
            [self reloadSelectView];
            break;
        }
        case TTSMenuActionStyleSend: {
            LogWarm(@"TTSMenuActionStyleSend");
            PDFunnyResouseModle * modle = [self.messageArray objectAtIndex:selectRowIndex] ;
            if([modle.type intValue] == 1){
                [[PDTTSDataHandle getInstanse] sendTTSQuickData:modle.content WithView:nil];
            }else{
                [[PDTTSDataHandle getInstanse] sendTTSTextData:modle.name WithView:nil];

            }
            break;
        }
        case TTSMenuActionStyleAdd: {
            LogWarm(@"TTSMenuActionStyleAdd");
            [self refreshAction:nil];
            break;
        }
        default:{
            break;
        }
        
       
    }
}


#pragma mark - 读取新的数据
- (void)loadLocalMessage{
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * array = [NSArray arrayWithContentsOfFile:[[SandboxFile GetDocumentPath] stringByAppendingString:@"/funnyResouse.plist"]];
        @strongify(self);
        if([array mIsArray] && [array count] > 0){
            [self updateResource:array];
            [self loadNewMessage:NO];

        }else{
            NSError * error = nil;
            
            [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"funnyResouse" ofType:@"plist"] toPath:[[SandboxFile GetDocumentPath] stringByAppendingString:@"/funnyResouse.plist"] error:&error];
            if(error){
                [self loadNewMessage:YES];
            }else{
                [self loadLocalMessage];
            }
        }
        
    });
}


- (void)updateResource:(NSArray *)array{
   dispatch_async(dispatch_get_main_queue(), ^{
       
       if([array mIsArray] && [array mCount] > 0){
           [self.messageArray removeAllObjects];
           for(NSDictionary * dic in array){
               PDFunnyResouseModle * modle = [PDFunnyResouseModle modelWithDictionary:dic];
               [self.messageArray addObject:modle];
           }
           [self resetSubviews];
       }
   });

}

- (void)loadNewMessage:(BOOL) shouldUpdate{
    @weakify(self);
    [RBNetworkHandle changeCtrlRespose:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0 ){
           dispatch_async(dispatch_get_global_queue(0, 0), ^{
               __block NSArray * array = [res objectForKey:@"data"];
               [array writeToFile:[[SandboxFile GetDocumentPath] stringByAppendingString:@"/funnyResouse.plist"] atomically:YES];
               @strongify(self);
               if(shouldUpdate)
                   [self updateResource:array];
           });
            
        }
    }];

}

- (void)resetSubviews{
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float xValue = SX(20);
    float yValue = SX(16);
    float xBetween = SX(10);
    float maxWidth = contentView.width -  xValue ;
    
    for(int i = 0 ; i < [self.messageArray count] ; i ++){
        PDFunnyResouseModle * modle = [self.messageArray objectAtIndex:i] ;
        
        RBVideoMessageCell * cell = [[RBVideoMessageCell alloc] initWithFrame:CGRectZero];
        [cell setDataSource:modle] ;
        cell.tag = i + 1000;
        [cell addTarget:self action:@selector(messageCellAction:) forControlEvents:UIControlEventTouchUpInside] ;
        if(xValue + cell.width - xBetween > maxWidth){
            xValue = SX(20);
            yValue += cell.height + SX(10);
        }
        if(yValue >= self.height - SX(42) - 10 - cell.height)
            break;
        
        cell.frame = CGRectMake(xValue, yValue, cell.width, cell.height) ;
        [contentView addSubview:cell];
        xValue = cell.right + xBetween;
    }

    
}

- (void)messageCellAction:(RBVideoMessageCell *) sender{
    if([sender isKindOfClass:[RBVideoMessageCell class]]){
        LogError(@"%@",sender.dataSource.content);
        if([sender.dataSource.type intValue] == 0){
            [[PDTTSDataHandle getInstanse] shouldSendTTS:sender.dataSource.name];
        }else{
            [[PDTTSDataHandle getInstanse] sendTTSQuickData:sender.dataSource.content WithView:nil];
            
        }
    }
}

#pragma mark ------------------- 换一换点击 ------------------------
- (void)refreshAction:(RBVideoMessageCell *)sender{
    [self loadNewMessage:YES];

}


- (void)reloadSelectView{

    for(UIView * cont in contentView.subviews){
        
        if(cont.tag == selectRowIndex + 1000){
            cont.layer.borderColor = mRGBToColor(0xffdfb8).CGColor;
            cont.backgroundColor = mRGBToColor(0xffffff);
        }else{
            cont.layer.borderColor = [UIColor clearColor].CGColor;
            cont.backgroundColor = mRGBToColor(0xf5f5f5);
        }
    }
}

- (void)dealloc{
    LogWarm(@"%@",self.class);
}
@end
