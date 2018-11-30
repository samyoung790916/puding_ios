//
//  RBSleepHelpCollectionReusableView.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/13.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBSleepHelpCollectionReusableView.h"

@implementation RBSleepHelpCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"RBSleepHelpCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([RBSleepHelpCollectionViewCell class])];
}
-(void)setModule:(PDModule *)module{
    _module = module;
    [self.titleIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",module.icon]] placeholder:[UIImage imageNamed:@"hp_icon_default_small"]];
    self.titleLable.text = module.title;
    [self.collectionView reloadData];
}
- (IBAction)moreBtnAction:(id)sender {
    if (_moreContentBlock) {
        _moreContentBlock();
    }
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PDCategory *category = [self.module.categories objectAtIndexOrNil:indexPath.row];
    if(_selectClassCategory){
        _selectClassCategory(category);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.module.categories count];
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBSleepHelpCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBSleepHelpCollectionViewCell class]) forIndexPath:indexPath];
    PDCategory *category = [self.module.categories objectAtIndexOrNil:indexPath.row];
    [cell setCategoty:category];
    return cell;
}
@end
