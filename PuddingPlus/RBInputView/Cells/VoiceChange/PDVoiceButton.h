//
//  PDVoiceButton.h
//  RBInputView
//
//  Created by kieran on 2017/2/10.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDAudioPlayProgress.h"

@interface PDVoiceButton : UIButton
@property (strong,nonatomic) UIButton* imageContent;
@property (strong,nonatomic) UILabel *titleContent;
@property (strong,nonatomic) PDAudioPlayProgress *progressView;

-(void) updatePlayProgress:(CGFloat) progress andContent:(NSString*) text;
@end
