//
//  ClassifyTableViewCell.m
//  FWRootChartUI
//
//  Created by 张志微 on 16/11/1.
//  Copyright © 2016年 张志微. All rights reserved.
//

#import "RBClassifyTableViewCell.h"
#import "PDChildDevepTagCell.h"
@interface RBClassifyTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,weak)UICollectionView *collectionView;
@end
@implementation RBClassifyTableViewCell{
    UIImageView *actImageView;
    UILabel *contentLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;


        //图片view
        actImageView = UIImageView.new;
        actImageView.layer.cornerRadius = SX(16);
        actImageView.clipsToBounds = YES;
        [self.contentView addSubview:actImageView];

        //内容
        contentLabel = UILabel.new;
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.textColor = RGB(122, 122, 122);
        contentLabel.userInteractionEnabled = NO;

        [self.contentView addSubview:contentLabel];
        [self subViewMasonry];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.alwaysBounceHorizontal = NO;
        collectionView.userInteractionEnabled = NO;
        [self.contentView  addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(actImageView.mas_bottom).offset(-SX(5));
            make.left.mas_equalTo(contentLabel.mas_left);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        [collectionView registerClass:[PDChildDevepTagCell class] forCellWithReuseIdentifier:NSStringFromClass([PDChildDevepTagCell class])];
        self.collectionView = collectionView;
    }
    return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.resours.tags.count;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PDChildDevepTagCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDChildDevepTagCell class]) forIndexPath:indexPath];
    cell.tagName = [self.resours.tags objectAtIndexOrNil:indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = [self.resours.tags objectAtIndexOrNil:indexPath.row];
    CGRect rect = [string boundingRectWithSize:(CGSize){CGFLOAT_MAX, 20} options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:SX(12)] } context:nil];
    return CGSizeMake(rect.size.width+15, 20);
}
- (void)subViewMasonry{

    [actImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(@(SX(15)));
        make.width.height.equalTo(@(SX(60)));
    }];
    

    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(actImageView.mas_top).offset(SX(5));
        make.left.equalTo(actImageView.mas_right).offset(SX(15));
        make.right.equalTo(self.contentView.mas_right).offset(-SX(20));
    }];
}

- (void)setResours:(PDBabyPlanResources *)resours{
    _resours = resours;
    int index = arc4random() % 5 + 1;
    UIImage *placeholder = [UIImage imageNamed:[NSString stringWithFormat:@"icon_home_default_%02d",index]];
    [actImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",resours.thumb]] placeholder:placeholder];
    
    NSString * desc = resours.nickname;
    if([desc mStrLength] == 0){
        desc = @"";
    }
    
    if([desc hasPrefix:NSLocalizedString( @"this_week_topic_", nil)]){
        desc = [desc stringByReplacingOccurrencesOfString:NSLocalizedString( @"this_week_topic_", nil) withString:@""];
    }
    if(self.indexPath.row == 0){
        contentLabel.text = [NSString stringWithFormat:NSLocalizedString( @"the_week_development_topic", nil),desc];
    }else if([resours.weekage length] > 0){
        contentLabel.text = [NSString stringWithFormat:@"%@：%@",resours.weekage,desc];
    }else{
        contentLabel.text = desc;
    }

    dispatch_async_on_main_queue(^{
         [self.collectionView reloadData];
    });
   
}


@end
