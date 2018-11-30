//
//  PDRegistNameViewController.m
//  Pudding
//
//  Created by william on 16/3/3.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDRegistNameViewController.h"
#import "PDTextFieldView.h"
#import "PDRightImageBtn.h"
#import "PDRegisterUpHeadImageController.h"
#import "RBSelectPuddingTypeViewController.h"
#import "AppDelegate.h"

@interface RBNickNameCollectionViewCell: UICollectionViewCell
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) UILabel * nameLabel;

@end

@implementation RBNickNameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.layer.cornerRadius = 12;
        self.imageView.layer.masksToBounds = YES;
        [self addSubview:self.imageView];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:18];
        self.nameLabel.textColor = UIColorHex(0x4a4a4a);
        self.nameLabel.frame = CGRectMake(self.width-60, self.height/2-10, 60, 20);
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
}

@end


@interface RBNickNameFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (assign,nonatomic) CGFloat contentHeight;
@end

@implementation RBNickNameFlowLayout

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];
    
    NSInteger itemCount = [[self collectionView] numberOfItemsInSection:0];
    self.itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];

    CGSize itemSize = CGSizeMake((SC_WIDTH-48)/2, SX(88));
    float itemHorBetween = 8;
    float itemVerBetween = SX(8);
    
    float defaltTopSpace = 0;
    float defaltBottomSpace = 100;
    _contentHeight = defaltTopSpace;

    float firItemXvalue = 20;//SC_WIDTH/2 - itemHorBetween/2 - itemSize.width;
    float secItemXvalue = SC_WIDTH/2 + itemHorBetween/2;
    
    for (NSInteger idx = 0; idx < itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        
        UICollectionViewLayoutAttributes *layoutAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        float XValue = (idx%2) == 0 ? firItemXvalue : secItemXvalue;
        
        layoutAttributes.frame = CGRectMake(XValue, _contentHeight, itemSize.width, itemSize.height);
        [_itemAttributes addObject:layoutAttributes];
        if((idx%2) == 1)
        _contentHeight = MAX(_contentHeight, CGRectGetMaxY(layoutAttributes.frame)) + itemVerBetween;
    }
    _contentHeight += defaltBottomSpace;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (CGSize)collectionViewContentSize {
    //重新计算布局
    [self prepareLayout];
    CGSize contentSize  = CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}


@end



@interface PDRegistNameViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

/** 直接跳过按钮 */
@property (nonatomic, weak) PDRightImageBtn * skipBtn;

@property (nonatomic, weak) UICollectionView * collectionView;

@property (nonatomic, weak) UILabel         * tipLable;
@property (nonatomic, weak) UILabel         * titleLabel;

@property (nonatomic, strong) NSArray       * dataSource;
/** 键盘动画 */
@property (nonatomic, assign) BOOL isKeyboardAnimate;
@end

@implementation PDRegistNameViewController
#pragma mark ------------------- lifeCycle ------------------------
#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化导航栏
    [self initlaNav];
    /** 直接跳过按钮 */
    self.skipBtn.hidden = NO;
    self.collectionView.hidden = NO;
    self.titleLabel.hidden = NO;
    self.tipLable.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - dealloc

-(void)dealloc{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];

}

#pragma mark - make datasouce

- (NSArray *)dataSource{
    if(!_dataSource){
        _dataSource = @[
                        @{@"image":@"ic_family_baba",@"info":NSLocalizedString( @"father", nil)},
                        @{@"image":@"ic_family_mama",@"info":NSLocalizedString( @"mother", nil)},
                        @{@"image":@"ic_family_yeye",@"info":NSLocalizedString( @"grandfather", nil)},
                        @{@"image":@"ic_family_nainai",@"info":NSLocalizedString( @"grandmother", nil)},
                        @{@"image":@"ic_family_waigong",@"info":NSLocalizedString( @"grandpa", nil)},
                        @{@"image":@"ic_family_waipo",@"info":NSLocalizedString( @"grandma", nil)},
                        @{@"image":@"ic_family_qita",@"info":NSLocalizedString( @"other", nil)},
                        ];
    }
    return _dataSource;
}

#pragma mark - 初始化导航栏
- (void)initlaNav{
    self.title = NSLocalizedString( @"fast_registration", nil);
    self.navView.backgroundColor = [UIColor whiteColor];
    self.navStyle = PDNavStyleLogin;
    [self.navView hideRightBtn];

}

#pragma mark - 创建 tipLable

- (UILabel *)tipLable{
    if(!_tipLable){
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.titleLabel.bottom + 8, self.view.width - 20, 20)];
        [self.view addSubview:lab];
        lab.text = NSLocalizedString( @"The baby said to pudding: I miss dad ,pudding will call you.", nil);
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = mRGBToColor(0x787878);
        _tipLable = lab;
    }
    return _tipLable;
}
- (UILabel *)titleLabel{
    if(!_titleLabel){
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.navView.bottom + SX(25), self.view.width - 20, 30)];
        [self.view addSubview:lab];
        lab.text = NSLocalizedString( @"Your family identity", nil);
        lab.font = [UIFont systemFontOfSize:26];
        lab.textColor = mRGBToColor(0x4a4a4a);
        _titleLabel = lab;
    }
    return _titleLabel;
}
#pragma mark - 创建 collectView

- (UICollectionView *)collectionView{
    if(!_collectionView){
        RBNickNameFlowLayout *flowLayout = [[RBNickNameFlowLayout alloc] init];

        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.tipLable.bottom + 22, self.view.width, self.skipBtn.top - (self.tipLable.bottom + 66)) collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[RBNickNameCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([RBNickNameCollectionViewCell class])];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self.view addSubview:collectionView];
        self.collectionView = collectionView;
        
        
    }
    return _collectionView;
}

#pragma mark - 创建 -> 直接跳过按钮
-(PDRightImageBtn *)skipBtn{
    if (!_skipBtn) {
        PDRightImageBtn *btn = [PDRightImageBtn buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(20, self.view.height-SX(45)-60, self.view.width-40, SX(45));
        [btn setTitle:NSLocalizedString( @"next step", nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = PDMainColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.layer.cornerRadius = SX(45)/2;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(skipClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _skipBtn = btn;
    }
    return _skipBtn;
}


#pragma mark - action: 直接跳过按钮点击
- (void)skipClick{
    [self toSelectPudding];
}

#pragma mark - action: 发送修改用户昵称的请求
- (void)sendModifyNameRequest:(NSString *)nickName{
    
    NSString *userName  = [nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    
    if(!userName || [userName isEqualToString:RBDataHandle.loginData.name])
        return;
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_editing", nil)];
    __weak typeof(self) weakself = self;
    [RBNetworkHandle updateUserName:userName :^(id res) {
        if(res && [[res mObjectForKey:@"result"] intValue] == 0){
            RBDataHandle.loginData.name = userName;
            [MitLoadingView dismiss];
            if(RBDataHandle.loginData){
                [weakself pushToUpdateHead];
            }
        }else{

            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}

#pragma mark - 跳过

- (void)toSelectPudding{
    if(RBDataHandle.loginData.mcids.count > 0){
        [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];

    }else{
        RBSelectPuddingTypeViewController * vc = [RBSelectPuddingTypeViewController new];
        vc.configType = PDAddPuddingTypeFirstAdd;
        [self.navigationController pushViewController:vc animated:YES];
    }
    

}

#pragma mark - action: 去我的布丁界面


- (void)pushToUpdateHead{
    PDRegisterUpHeadImageController *vc = [[PDRegisterUpHeadImageController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBNickNameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RBNickNameCollectionViewCell" forIndexPath:indexPath];
    NSString * imageName = self.dataSource[indexPath.row][@"image"];
    [cell setImage:[UIImage imageNamed:imageName]];
    NSString *name = self.dataSource[indexPath.row][@"info"];
    cell.nameLabel.text = name;
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (RBNickNameCollectionViewCell *cell in collectionView.visibleCells) {
        cell.imageView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.imageView.layer.borderWidth = 0;
    }
    RBNickNameCollectionViewCell *cell = (RBNickNameCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.imageView.layer.borderColor = PDMainColor.CGColor;
    cell.imageView.layer.borderWidth = 3;
    if(indexPath.row +1 == self.dataSource.count){
        RBNickNameCollectionViewCell *cell = (RBNickNameCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.imageView.layer.borderColor = PDMainColor.CGColor;
        cell.imageView.layer.borderWidth = 3;
        @weakify(self)
        [self showUpdateNickName:@"" title:NSLocalizedString( @"customize_your_nickname", nil) isPhone:NO EndAlter:^(NSString *selectedName) {
            @strongify(self)
            NSLog(@"%@",selectedName);
            if([selectedName length] > 0){
                [self sendModifyNameRequest:selectedName];
            }
        }];
    
    }else{
        NSString * selectedName = self.dataSource[indexPath.row][@"info"];

        [self sendModifyNameRequest:selectedName];

    }
}

@end
