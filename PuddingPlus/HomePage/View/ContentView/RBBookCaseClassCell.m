//
// Created by kieran on 2018/2/26.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import "RBBookCaseClassCell.h"
#import "RBBookcaseCellButton.h"
#import "RBBookSourceModle.h"


@interface RBBookCaseClassCell ()
@property (nonatomic,weak) RBBookcaseCellButton *bookImageView;
@property (nonatomic,weak) UILabel *bookTitle;
@end


@implementation RBBookCaseClassCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.bookImageView.hidden = NO;
        self.bookTitle.hidden = NO;
    }
    return self;
}

#pragma mark - bookTitle

- (UILabel *)bookTitle{
    if(!_bookTitle){
        UILabel *bookTitle = [UILabel new];
        bookTitle.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:bookTitle];
        [bookTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bookImageView.mas_bottom).offset(SX(15));
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.height.mas_equalTo(SX(24));
            make.width.equalTo(self.mas_width);
        }];
        bookTitle.text = NSLocalizedString( @"book_name", nil);
        bookTitle.font = [UIFont systemFontOfSize:SX(13)];
        bookTitle.textColor = UIColorHex(0x9b9b9b);
        _bookTitle = bookTitle;
    }
    return _bookTitle;
}


#pragma mark - bookImage create

- (RBBookcaseCellButton *)bookImageView{
    if(!_bookImageView){
        RBBookcaseCellButton *bookImageView = [RBBookcaseCellButton new];
        [self.contentView addSubview:bookImageView];
        [bookImageView setImageSize:CGSizeMake(SX(93), SX(93))];
        [bookImageView setImage:@"story_bng_fox" ImageURL:nil];
        [bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(SX(93));
        }];
        _bookImageView = bookImageView;
    }
    return _bookImageView;
}

#pragma mark - Set DataSource

- (void)setBookModle:(RBBookSourceModle *)bookModle{
    _bookModle = bookModle;
    [self.bookImageView setImage:@"ic_picturebooks_lack" ImageURL:bookModle.pictureSmall];
    self.bookTitle.text = bookModle.name;
}

- (void)setCategoty:(PDCategory *)categoty{
    _categoty = categoty;
    self.bookTitle.text = categoty.title;
    [self.bookImageView setImage:@"ic_picturebooks_lack" ImageURL:categoty.thumb];
}


@end
