//
//  PDAlbumPickerController.m
//  Pudding
//
//  Created by baxiang on 16/4/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDAlbumPickerController.h"
#import "PDPhotoPickerController.h"
#import "PDImagePickerController.h"
#import "PDImageManager.h"
#import "PDAlbumCell.h"
@interface PDAlbumPickerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *albumArr;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation PDAlbumPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.view.backgroundColor = mRGBToColor(0xf7f7f7);
    self.navigationItem.title = NSLocalizedString( @"photo", nil);
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // PDImagePickerController *imagePickerVc = (PDImagePickerController *)self.navigationController;
    //[imagePickerVc hideProgressHUD];
    if (_albumArr) return;
    //[self configTableView];
}

- (void)configTableView {
    PDImagePickerController *imagePickerVc = (PDImagePickerController *)self.navigationController;
    [[PDImageManager manager] getAllAlbums:imagePickerVc.allowPickingVideo completion:^(NSArray<PDAlbumModel *> *models) {
        _albumArr = [NSMutableArray arrayWithArray:models];
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 70;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setSeparatorColor:mRGBToColor(0xd9d9d9)];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[PDAlbumCell class] forCellReuseIdentifier:NSStringFromClass([PDAlbumCell class])];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }];
}

#pragma mark - Click Event

- (void)cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    PDImagePickerController *imagePickerVc = (PDImagePickerController *)self.navigationController;
    if ([imagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [imagePickerVc.pickerDelegate imagePickerControllerDidCancel:imagePickerVc];
    }
    if (imagePickerVc.imagePickerControllerDidCancelHandle) {
        imagePickerVc.imagePickerControllerDidCancelHandle();
    }
}

#pragma mark - UITableViewDataSource && Delegate

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [UIView new];
    headView.frame = CGRectMake(0, 0, self.view.width, 15);
    UIView *seperLine = [[UIView alloc] initWithFrame:CGRectMake(0, 15- 1.0/[[UIScreen mainScreen] scale],  self.view.width,  1.0/[[UIScreen mainScreen] scale])];
    seperLine.backgroundColor = mRGBToColor(0xd9d9d9);
    [headView addSubview:seperLine];
    return headView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PDAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDAlbumCell class])];
    cell.model = _albumArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PDPhotoPickerController *photoPickerVc = [[PDPhotoPickerController alloc] init];
    photoPickerVc.model = _albumArr[indexPath.row];
    [self.navigationController pushViewController:photoPickerVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
