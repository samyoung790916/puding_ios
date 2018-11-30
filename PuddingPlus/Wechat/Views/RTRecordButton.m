//
//  RTRecordButton.m
//  StoryToy
//
//  Created by baxiang on 2017/11/3.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTRecordButton.h"

#define MAX_RECORD_TIME 30
#define COUNT_DOWN_TIME 5

typedef enum : NSUInteger {
    RTRecordMoveIdel,
    RTRecordMoveMoveIn,
    RTRecordMoveMoveOut,
} RTRecordMoveType;

@interface RTRecordButton () <UIGestureRecognizerDelegate>{
    RTRecordMoveType _moveType;
    NSTimer * cutDownTimer ;
    NSInteger recordTimer;
    NSSet<UITouch *> * _touchs;
}
@property(nonatomic, weak)      UIView      *bgView;
@property(nonatomic, weak)      UIView      *infoView;
@property(nonatomic, strong)    UILabel     *titleLabel;
@property(nonatomic, weak)      UIImageView *imageView;

@property(nonatomic, strong) void (^beginInputBlock)(void);
@property(nonatomic, strong) void (^touchMoveBlock)(BOOL cancel);
@property(nonatomic, strong) void (^touchCancelBlock)(void);
@property(nonatomic, strong) void (^endInputBlock)(void);
@property(nonatomic, strong) void (^inputCountDown)(int);

@end

@implementation RTRecordButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _moveType = RTRecordMoveIdel;

        [self setNormalTitle:NSLocalizedString(@"press_speak", @"按住说话")];
        [self setCancelTitle:NSLocalizedString(@"undo_cancel", @"松开取消")];

        self.bgView.hidden = NO;
        self.titleLabel.hidden = NO;
        self.imageView.hidden = NO;
        [self normalViewStyle:NO];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        [self updateFrame:self.normalTitle];
    }
}

#pragma mark - # Public Methods

- (void)setBeginInputAction:(void (^)(void))beginInput
            MoveInputAction:(void (^)(BOOL))touchMove
             EndinputAction:(void (^)(void))endInput
        inputCancelAction:(void (^)(void))cancelInput
                  countDown:(void (^)(int))countDownTime
{
    self.beginInputBlock = beginInput;
    self.touchMoveBlock = touchMove;
    self.endInputBlock = endInput;
    self.touchCancelBlock = cancelInput;
    self.inputCountDown = countDownTime;
}

- (void)beginInput{
    if (cutDownTimer != NULL)
        return;
    
    _moveType = RTRecordMoveIdel;
    [self updateFrame:self.cancelTitle];
    [self inputViewStyle:YES];

    recordTimer = 0 ;
    cutDownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateRecordTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:cutDownTimer forMode:NSRunLoopCommonModes];

    if (self.beginInputBlock) {
        self.beginInputBlock();
    }
}

#pragma mark - # Event Response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"beginInput");
    [self beginInput];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (cutDownTimer == nil)
        return;
    if (self.touchMoveBlock) {
        CGPoint curPoint = [[touches anyObject] locationInView:self];
        BOOL moveIn = curPoint.x >= 0 && curPoint.x <= self.width && curPoint.y >= 0 && curPoint.y <= self.height;
        RTRecordMoveType toType = moveIn ? RTRecordMoveMoveIn : RTRecordMoveMoveOut;
        if (toType == _moveType)
            return;
        _moveType = toType;
        self.touchMoveBlock(!moveIn);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"endInput");
    if (cutDownTimer == nil)
        return;

    [self normalViewStyle:YES];
    [self updateFrame:self.normalTitle];
    if (cutDownTimer != nil){
        [cutDownTimer invalidate];
        cutDownTimer = nil;
    }
    CGPoint curPoint = [[touches anyObject] locationInView:self];
    BOOL moveIn = curPoint.x >= 0 && curPoint.x <= self.width && curPoint.y >= 0 && curPoint.y <= self.height;
    if (moveIn && self.endInputBlock) {
        self.endInputBlock();
    } else if (!moveIn && self.touchCancelBlock) {
        self.touchCancelBlock();
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (cutDownTimer == nil)
        return;
    [self setBackgroundColor:[UIColor clearColor]];
    [self normalViewStyle:YES];
    [self.titleLabel setText:self.normalTitle];
    if (cutDownTimer != nil){
        [cutDownTimer invalidate];
        cutDownTimer = nil;
    }
    if (self.touchCancelBlock) {
        self.touchCancelBlock();
    }
}


#pragma mark

- (void)updateRecordTimer:(NSTimer *)timer{
    recordTimer ++;
    int c = MAX_RECORD_TIME - recordTimer ;
    if (MAX_RECORD_TIME < recordTimer){
        [self touchesEnded:nil withEvent:nil];
        [cutDownTimer invalidate];
        cutDownTimer = nil;
    }else if (c >= 0 && c <= COUNT_DOWN_TIME) {
        NSLog(@"----%d",c);
        if (self.inputCountDown){
            self.inputCountDown(c);
        }
    }

}

- (void)updateFrame:(NSString *)titleString {

    CGSize textSize = [_titleLabel sizeThatFits:CGSizeMake(1000, 25)];
    if (CGSizeEqualToSize(textSize, _titleLabel.frame.size)) {
        return;
    }

    CGSize imageSize = _imageView.image.size;
    float infoWidth = textSize.width + imageSize.width + SX(8);
    _titleLabel.text = titleString;

    self.bgView.frame = self.bounds;
    self.bgView.layer.cornerRadius = self.height / 2;
    self.bgView.clipsToBounds = YES;


    self.infoView.frame = CGRectMake((self.width - infoWidth) / 2, 0, infoWidth, self.height);
    self.imageView.frame = CGRectMake(0, (self.height - imageSize.height) / 2, imageSize.width, imageSize.height);
    self.titleLabel.frame = CGRectMake(self.imageView.right + SX(8), 0, textSize.width, self.height);
}

- (void)updateConstraintsIfNeeded {
    [super updateConstraintsIfNeeded];

}

#pragma mark - # Getter
#pragma mark 懒加载 imageView

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.userInteractionEnabled = NO;
        view.image = [UIImage imageNamed:@"ic_chat_voice"];
        [self.infoView addSubview:view];

        _imageView = view;
    }
    return _imageView;
}


- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:SX(16.0f)]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        _titleLabel.userInteractionEnabled = NO;
        [_titleLabel setText:self.normalTitle];
        [self.infoView addSubview:_titleLabel];

    }
    return _titleLabel;
}

#pragma mark 懒加载 bgView

- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = mRGBToColor(0x00cd62);
        view.frame = self.bounds;
        view.userInteractionEnabled = NO;
        [self addSubview:view];

        _bgView = view;
    }
    return _bgView;
}

#pragma mark 懒加载 infoView

- (UIView *)infoView {
    if (!_infoView) {
        UIView *view = [[UIView alloc] init];
        view.userInteractionEnabled = NO;
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];

        _infoView = view;
    }
    return _infoView;
}


#pragma mark view 样式

- (void)inputViewStyle:(BOOL)isAnimal {
    _moveType = RTRecordMoveIdel;
    [UIView animateWithDuration:isAnimal ? 0.25 : 0 animations:^{
        self.bgView.frame = CGRectInset(self.bounds, SX(50), 0);
        self.imageView.alpha = 0;
        self.titleLabel.left = SX(12);
    }];
}

- (void)normalViewStyle:(BOOL)isAnimal {
    _moveType = RTRecordMoveIdel;
    [UIView animateWithDuration:isAnimal ? 0.25 : 0 animations:^{
        self.bgView.frame = self.bounds;
        self.imageView.alpha = 1;
        self.titleLabel.left = self.imageView.width + SX(8);

    }];
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        [self beginInput];//fix 左侧长按延迟的问题
        return hitView;
    } else {
        return nil;
    }
}

@end
