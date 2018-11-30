//
//  PDTTSTagsView.m
//  Pudding
//
//  Created by baxiang on 2016/12/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSTagsView.h"
#import "PDTTSTagsFlowLayout.h"
#import "PDTTSTagsCell.h"

@interface PDTTSTagsView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) UICollectionView *collectionView;

@end
@implementation PDTTSTagsView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaulrConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupDefaulrConfig];
    }
    
    return self;
}

- (void)setupDefaulrConfig {
    self.backgroundColor = [UIColor clearColor];
    _tagInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _tagBorderWidth = 0;
    _tagBackgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    _tagSelectedBackgroundColor = [UIColor colorWithRed:1.0 green:0.38 blue:0.0 alpha:1.0];
    _tagFont = [UIFont systemFontOfSize:14];
    _tagSelectedFont = [UIFont systemFontOfSize:14];
    _tagTextColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    _tagSelectedTextColor = [UIColor whiteColor];
    
    _tagHeight = 30;
    _mininumTagWidth = 0;
    _maximumTagWidth = CGFLOAT_MAX;
    _lineSpacing = 10;
    _interitemSpacing = 5;
    
    PDTTSTagsFlowLayout *flowLayout = [[PDTTSTagsFlowLayout alloc] init];
    flowLayout.delegate = self;
   // UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[PDTTSTagsCell class] forCellWithReuseIdentifier:NSStringFromClass([PDTTSTagsCell class])];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.collectionView = collectionView;
}

-(void)setTagsArray:(NSArray<PDTTSListContent *> *)tagsArray{
    _tagsArray = [tagsArray copy];
    [self.collectionView reloadData];

}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PDTTSListContent *tagModel = self.tagsArray[indexPath.row];
    CGFloat width = tagModel.contentSize.width + self.tagInsets.left + self.tagInsets.right;
    if (width < self.mininumTagWidth) {
        width = self.mininumTagWidth;
    }
    if (width > self.maximumTagWidth) {
        width = self.maximumTagWidth;
    }
    return CGSizeMake(width,self.tagHeight);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.interitemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 10);;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PDTTSTagsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDTTSTagsCell class]) forIndexPath:indexPath];
    cell.tagModel = self.tagsArray[indexPath.row];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     PDTTSListContent*content  =  [self.tagsArray objectAtIndex:indexPath.row];
    if(content.type == 0){
        if(_SelectTextBlock){
            self.SelectTextBlock(content.name);
        }
    }else{
        if(self.SendPlayCmdBlock){
            self.SendPlayCmdBlock(content.content);
        }
    }
}




@end
