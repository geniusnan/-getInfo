//
//  LocationController.m
//  RapidLoan
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LocationController.h"
#import <CoreLocation/CoreLocation.h>
@interface LocationController ()<CLLocationManagerDelegate>{//添加代理协议 CLLocationManagerDelegate
    CLLocationManager *_locationManager;//定位服务管理类
    CLGeocoder * _geocoder;//初始化地理编码器
}
@property (nonatomic ,strong)UILabel *textLabel;
@end

@implementation LocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title =@"获取定位";
    _textLabel =[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-100, 100, 200, 60)];
    _textLabel.textColor =[UIColor blackColor];
    _textLabel.numberOfLines =2;
    [self.view addSubview:_textLabel];
    [self initializeLocationService];
}
-(void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    //[_locationManager requestAlwaysAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];//开始定位之后会不断的执行代理方法更新位置会比较费电所以建议获取完位置即时关闭更新位置服务
    //初始化地理编码器
    _geocoder = [[CLGeocoder alloc] init];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    NSLog(@"%lu",(unsigned long)locations.count);
    CLLocation * location = locations.lastObject;
    // 纬度
    CLLocationDegrees latitude = location.coordinate.latitude;
    // 经度
    CLLocationDegrees longitude = location.coordinate.longitude;
    NSLog(@"%@",[NSString stringWithFormat:@"%lf    %lf",latitude, longitude]);
    // NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f", location.coordinate.longitude, location.coordinate.latitude,location.altitude,location.course,location.speed);
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            // 位置名
            NSLog(@"name,%@",placemark.name);
            // 街道
            NSLog(@"thoroughfare,%@",placemark.thoroughfare);
            // 子街道
            NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            // 市
            NSLog(@"locality,%@",placemark.locality);
            // 区
            NSLog(@"subLocality,%@",placemark.subLocality);
            // 国家
            NSLog(@"country,%@",placemark.country);
            _textLabel.text =[NSString stringWithFormat:@"%@%@%@\n%@%@%@",placemark.country,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare,placemark.name];
        }else if (error == nil && [placemarks count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
//     [manager stopUpdatingLocation];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
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
