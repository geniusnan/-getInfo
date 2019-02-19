//
//  FaceStreamDetectorViewController.m
//  IFlyFaceDemo
//
//  Created by 付正 on 16/3/1.
//  Copyright (c) 2016年 fuzheng. All rights reserved.
//

#import "FaceStreamDetectorViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

@interface FaceStreamDetectorViewController ()
{
    UILabel *alignLabel;
    NSTimer *timer;
    NSInteger timeCount;
    UIImageView *imgView;//动画图片展示
    
    UIView *backView;//照片背景
    UIImageView *imageView;//照片展示
    UIImageView *kuangView;//框
    BOOL uploadSuccess;
}
@property (nonatomic, retain ) UIView         *previewView;
@property (nonatomic, retain ) UIView         *bottomView;
@property (nonatomic, strong ) UILabel        *textLabel;
@property (nonatomic, strong ) UIButton       *startButton;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *videoDevice;
@property (nonatomic, strong) AVCaptureDevice *audioDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong ) UITapGestureRecognizer     *tapGesture;

@end

@implementation FaceStreamDetectorViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackButton:NO];
    [self.backButton setImage:[UIImage imageNamed:@"backWhite"] forState:UIControlStateNormal];
    //创建界面
    [self makeUI];
    [self setupCaptureSession];
    [self startSession];
    [self.view bringSubviewToFront:self.backView];
        
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //停止摄像
    [self.previewLayer.session stopRunning];
}


#pragma mark --- 创建UI界面
-(void)makeUI
{
    self.previewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:self.previewView];
    
    //图片放置View
    

    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:imageView];

    kuangView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [kuangView setImage:[UIImage imageNamed:@"kuang"]];
    [self.view addSubview:kuangView];
    
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-200)/2, self.previewView.bottom- FSFloat(160), 200, 20)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.layer.cornerRadius = 15;
    self.textLabel.text = @"请将人脸移入框内并开始";
    self.textLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.textLabel];
    
    //提示框
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-ScreenWidth/5)/2, self.textLabel.bottom+15, ScreenWidth/5, ScreenWidth/5)];
    [self.view addSubview:imgView];

    _startButton =[WidgetObjc WidgetButton:CGRectMake((ScreenWidth-FSFloat(77))/2, self.view.bottom-FSFloat(124), FSFloat(77), FSFloat(77)) font:[UIFont systemFontOfSize:18] title:@"开始" textColor: [UIColor whiteColor] superViews:self.view];
    [_startButton setBackgroundColor:[UIColor colorWithHex:0x019DFF ]];
    _startButton.layer.masksToBounds =YES;
    _startButton.layer.cornerRadius =_startButton.width/2;
    WS(weakSelf)
    [_startButton addUpInside:^(UIButton *button) {
        [weakSelf timeBegin];
        [weakSelf startRecord];
        weakSelf.startButton.hidden =YES;
    }];
    [self createBottomView];
}

-(void)createBottomView{
    _bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-45, ScreenWidth, 45)];
    _bottomView.hidden =YES;
    [self.view addSubview:_bottomView];
    for (int i=0; i<4; i++) {
        UILabel *bottomLabel =[WidgetObjc WidgetLabel:CGRectMake(ScreenWidth/2-65+i*35, 0, 25, 25) font:[UIFont systemFontOfSize:17] Alignment:NSTextAlignmentCenter textColor:[UIColor whiteColor]];
        [_bottomView addSubview:bottomLabel];
        bottomLabel.tag =10+i;
        bottomLabel.text =[NSString stringWithFormat:@"%d",i+1];
        bottomLabel.layer.masksToBounds =YES;
        bottomLabel.layer.cornerRadius =12.5;
        bottomLabel.textColor =[UIColor whiteColor];
        bottomLabel.layer.borderColor =[UIColor whiteColor].CGColor;
        bottomLabel.layer.borderWidth =1;
        if (i==0) {
            bottomLabel.backgroundColor =[UIColor whiteColor];
            bottomLabel.textColor =[UIColor blackColor];
        }
    }
}

-(void)refreshBottom:(NSInteger )number{
    _bottomView.hidden =NO;
    for (UILabel *label in _bottomView.subviews) {
        if (label.tag -10 ==number) {
            label.backgroundColor =[UIColor whiteColor];
            label.textColor =[UIColor blackColor];
        }else{
            label.backgroundColor =[UIColor clearColor];
            label.textColor =[UIColor whiteColor];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopSession];
    if (!uploadSuccess) {
        NSDictionary *dic =@{@"uploadSuccess":@"0"};
        NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:dic userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];
    }
}

-(void)viewWillLayoutSubviews {
    self.previewLayer.frame = self.previewView.bounds;
}

#pragma mark - Setup

- (void)setupCaptureSession {
    // 1.获取视频设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionFront) {
            self.videoDevice = device;
            break;
        }
    }
    // 2.获取音频设备
    self.audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    // 3.创建视频输入
    NSError *error = nil;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:&error];
    if (error) {
        return;
    }
    // 4.创建音频输入
    self.audioInput = [AVCaptureDeviceInput deviceInputWithDevice:self.audioDevice error:&error];
    if (error) {
        return;
    }
    // 5.创建视频输出
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    // 6.建立会话
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    if ([self.captureSession canAddInput:self.videoInput]) {
        [self.captureSession addInput:self.videoInput];
    }
    if ([self.captureSession canAddInput:self.audioInput]) {
        [self.captureSession addInput:self.audioInput];
    }
    if ([self.captureSession canAddOutput:self.movieFileOutput]) {
        [self.captureSession addOutput:self.movieFileOutput];
    }
    // 7.预览画面
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    [self.previewView.layer addSublayer:self.previewLayer];
}

#pragma mark - Tool

- (NSString *)videoPath {
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *moviePath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.mp4",[NSDate date].timeIntervalSince1970]];
    DLog(@"moviePath=%@",moviePath)
    return moviePath;
}

- (AVCaptureDevice *)deviceWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark - Session

- (void)startSession {
    if(![self.captureSession isRunning]) {
        [self.captureSession startRunning];
    }
}

- (void)stopSession {
    if([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}

#pragma mark - Record

- (void)startRecord {
    if (self.videoDevice.isSmoothAutoFocusSupported) {
        NSError *error = nil;
        if ([self.videoDevice lockForConfiguration:&error]) {
            self.videoDevice.smoothAutoFocusEnabled = YES;
            [self.videoDevice unlockForConfiguration];
        }
    }
    [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:[self videoPath]] recordingDelegate:self];
}

- (void)stopRecord {
    if ([self.movieFileOutput isRecording]) {
        [self.movieFileOutput stopRecording];
    }
}

#pragma mark - Delegate

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"record start");
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"record finish");

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"·活体认证完成是否上传"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"重新认证" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              _startButton.hidden =NO;
                                                              self.textLabel.text = @"请将人脸移入框内并开始";
                                                              _bottomView.hidden =YES;
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"上传" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             UISaveVideoAtPathToSavedPhotosAlbum([outputFileURL path], nil, nil, nil);

                                                             NSFileManager* fm=[NSFileManager defaultManager];
                                                             if([fm fileExistsAtPath:[outputFileURL path]]){
                                                                 CGFloat size =[self getFileSize:[outputFileURL path]];
                                                                 NSURL *compressionUrl =[self condenseVideoNewUrl:outputFileURL];
                                                             }
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    


}


-(void)uploadImagesWithData:(NSData *)video{
    uploadSuccess =YES;
    NSDictionary *dic =@{@"uploadSuccess":@"1"};
    NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:dic userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];

    
    
}
// 获取视频的大小
- (CGFloat) getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init] ;
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize;
}

- (NSURL *)condenseVideoNewUrl: (NSURL *)url{
    // 沙盒目录
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *destFilePath = [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"lyh%@.mp4",[self getCurrentTime]]];
    NSURL *destUrl = [NSURL fileURLWithPath:destFilePath];
    //将视频文件copy到沙盒目录中
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    [manager copyItemAtURL:url toURL:destUrl error:&error];
    NSLog(@"压缩前--%.2fk",[self getFileSize:destFilePath]);
    // 播放视频
    /*
     NSURL *videoURL = [NSURL fileURLWithPath:destFilePath];
     AVPlayer *player = [AVPlayer playerWithURL:videoURL];
     AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
     playerLayer.frame = self.view.bounds;
     [self.view.layer addSublayer:playerLayer];
     [player play];
     */
    // 进行压缩
    AVAsset *asset = [AVAsset assetWithURL:destUrl];
    //创建视频资源导出会话
    /**
     NSString *const AVAssetExportPresetLowQuality; // 低质量
     NSString *const AVAssetExportPresetMediumQuality;
     NSString *const AVAssetExportPresetHighestQuality; //高质量
     */
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    // 创建导出的url
    NSString *resultPath = [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"lyhg%@.mp4",[self getCurrentTime]]];
    session.outputURL = [NSURL fileURLWithPath:resultPath];
    // 必须配置输出属性
    session.outputFileType = @"com.apple.quicktime-movie";
    // 导出视频
    [session exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"压缩后---%.2f  k",[self getFileSize:resultPath]);
        NSLog(@"视频导出完成");
        NSData *data = [NSData dataWithContentsOfFile:resultPath];
        DLog(@"record finish =%@",resultPath)
        [self uploadImagesWithData:data];
    }];
    
    return session.outputURL;
}



#pragma mark - 获取当前时间
- (NSString *)getCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
    
}

#pragma mark --- 计时开始
-(void)timeBegin
{
    timeCount = 12;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
}

#pragma mark --- 时间变为0，拍照
- (void)timerFireMethod:(NSTimer *)theTimer
{
    timeCount --;
    if(timeCount >= 1)
    {
        if (timeCount ==11) {
            self.textLabel.text = @"请眨眼";
            [self refreshBottom:0];
            [self tomAnimationWithName:@"请眨眼" count:2];
        }else if (timeCount ==8) {
            self.textLabel.text = @"请摇头";
            [self refreshBottom:1];
            [self tomAnimationWithName:@"请摇头" count:2];
        }else if (timeCount ==5) {
            self.textLabel.text = @"请张嘴";
            [self refreshBottom:2];
            [self tomAnimationWithName:@"请张嘴" count:2];
        }else if (timeCount ==2) {
            self.textLabel.text = @"请点头";
            [self refreshBottom:3];
            [self tomAnimationWithName:@"请点头" count:2];
        }
    }
    else
    {
        [self stopRecord];
        self.textLabel.text = @"";
        [theTimer invalidate];
        theTimer=nil;
        
    }
}

#pragma mark --- 创建button公共方法
/**使用示例:[self buttonWithTitle:@"点 击" frame:CGRectMake((self.view.frame.size.width - 150)/2, (self.view.frame.size.height - 40)/3, 150, 40) action:@selector(didClickButton) AddView:self.view];*/
-(UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action AddView:(id)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    [view addSubview:button];
    return button;
}

#pragma mark --- UIImageView显示gif动画
- (void)tomAnimationWithName:(NSString *)name count:(NSInteger)count
{

    // 动画图片的数组
    NSMutableArray *arrayM = [NSMutableArray array];
    
    // 添加动画播放的图片
    for (int i = 0; i < count; i++) {
        // 图像名称
        NSString *imageName = [NSString stringWithFormat:@"%@%d", name, i];
        //        UIImage *image = [UIImage imageNamed:imageName];
        // ContentsOfFile需要全路径
       
        UIImage *image = [UIImage imageNamed:imageName];
        
        [arrayM addObject:image];
    }
    
    // 设置动画数组
    imgView.animationImages = arrayM;
    // 重复1次
    imgView.animationRepeatCount = 2;
    // 动画时长
    imgView.animationDuration = imgView.animationImages.count * 0.7;
    
    // 开始动画
    [imgView startAnimating];
}


@end
