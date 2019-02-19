//
//  PhoneController.m
//  RapidLoan
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "PhotoController.h"
#import <Photos/Photos.h>
#import "ImageCell.h"
@interface PhotoController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *assets;//用于存储所有的照片。
@property (nonatomic, strong) UIButton *showImgBnt;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title =@"获取照片";
    _assets =[NSMutableArray arrayWithCapacity:0];
    _dataArray =[NSMutableArray arrayWithCapacity:0];
    [self requestPermissons];

    [self initCollectionView];
}

#pragma mark  设置CollectionView的的参数
- (void) initCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //设置CollectionView的属性
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    [self.view addSubview:self.collectionView];
    //注册Cell
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)requestPermissons
{
    //获取当前状态：PHAuthorizationStatusNotDetermined--未知
    //            PHAuthorizationStatusRestricted--受限制的(用户不能更改某个app的此状态，或许某些活动限制设置能改变如：家长模式）
    //            PHAuthorizationStatusDenied--拒绝访问
    //            PHAuthorizationStatusAuthorized--可以访问
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    __weak PhotoController *weakSelf = self;

    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                //获取手机照片库
                [weakSelf showImage];
            }else{
                //弹出提示信息
            }
        }];
    }else if(status == PHAuthorizationStatusAuthorized){
        //获取手机照片库
        [weakSelf showImage];
    }else{
        //弹出提示信息
    }
}
- (void)showImage
{
    self.showImgBnt.hidden = YES;
    self.imgView.hidden = NO;
    //获取相册里所有的照片
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    self.assets = [[NSMutableArray alloc] init];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]]) {
            [self.assets addObject:obj];
        }
    }];
    //最后一张图为最新
    if (self.assets.count !=0) {
        if (self.assets.count<20) {
            for (int i=0; i<self.assets.count; i++) {
                PHAsset *asset = self.assets [self.assets.count-i-1];
                PHImageManager *manager = [PHImageManager defaultManager];
                
                [manager requestImageForAsset:asset
                                   targetSize:PHImageManagerMaximumSize
                                  contentMode:PHImageContentModeAspectFill
                                      options:nil
                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                    [_dataArray addObject: [PhotoController imageByScalingAndCroppingForSize:CGSizeMake(375, 460) WithImage:result]];
                                    if (i==self.assets.count-1) {
                                        [self.collectionView reloadData];
                                    }
                                    
                                }];
            }
        }else{
            for (int i=0; i<20; i++) {
                PHAsset *asset = self.assets [self.assets.count-i-1];
                PHImageManager *manager = [PHImageManager defaultManager];
                
                [manager requestImageForAsset:asset
                                   targetSize:PHImageManagerMaximumSize
                                  contentMode:PHImageContentModeAspectFill
                                      options:nil
                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                    [_dataArray addObject: [PhotoController imageByScalingAndCroppingForSize:CGSizeMake(300, 450) WithImage:result]];
                                    if (i==19) {
                                        [self.collectionView reloadData];
                                    }
                                    
                                }];
            }
        }
    }
   
}



+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize WithImage:(UIImage*)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
        
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    NSData * imageData = UIImageJPEGRepresentation(newImage,1);
    CGFloat length = [imageData length]/1000;
    NSLog(@"newlength==%lf",length);
    return newImage;
}


#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    UIImage *image =_dataArray[indexPath.row];
    [cell.imageView setImage:image];
    return cell;
}



#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(ScreenWidth /3,ScreenHeight / 3);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"---------------------");
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
