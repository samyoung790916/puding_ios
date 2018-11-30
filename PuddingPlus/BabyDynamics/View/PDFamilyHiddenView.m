//
//  PDFamilyHiddenView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/7/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyHiddenView.h"

@implementation PDFamilyHiddenView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width * 1)];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.clipsToBounds = YES;
        [self addSubview:img];
        pro = .75;
        self.clipsToBounds = YES;
    }
    
    
    return self;
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    float height =  frame.size.width * 1;
    
    img.frame = CGRectMake(0, (self.height - height)/2.f, frame.size.width, height);

    
    img.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin  |
    UIViewAutoresizingFlexibleBottomMargin;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    img.image = image;
    if(image.size.width > 0)
        pro = image.size.height/image.size.width;
    img.frame = CGRectMake(0, 0, self.width, self.width * 1);
}


- (void)start{

//    link = [CADisplayLink displayLinkWithTarget:self
//                                                   selector:@selector(handleDisplayLink:)];
//    [link addToRunLoop:[NSRunLoop currentRunLoop]
//                           forMode:NSRunLoopCommonModes];
}

- (void)handleDisplayLink:(CADisplayLink *)link{
//    CGRect centerRect = [[[self.layer presentationLayer] valueForKeyPath:@"bounds"]CGRectValue];
//    img.frame = CGRectMake(0, 0, centerRect.size.width, centerRect.size.width * .75);
    [self setNeedsLayout];
}


- (void)stop
{
//    [link invalidate];
//    link = nil;
}
@end
