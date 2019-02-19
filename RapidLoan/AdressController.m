//
//  AdressController.m
//  RapidLoan
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AdressController.h"
#import <Contacts/Contacts.h>

@interface AdressController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_contactArr;
    NSString *_jsonString;
}
@property (nonatomic,retain)UITableView *myTableView;
@end

@implementation AdressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];

    self.title =@"用户通讯录";
    _myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _myTableView.delegate =self;
    _myTableView.dataSource =self;
    _myTableView.estimatedRowHeight = 0;
    _myTableView.estimatedSectionHeaderHeight = 0;
    _myTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_myTableView];
    [self requestAuthorizationForAddressBook];
    // Do any additional setup after loading the view.
}
- (void)requestAuthorizationForAddressBook {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if(authorizationStatus ==CNAuthorizationStatusNotDetermined) {
        
        CNContactStore*contactStore = [[CNContactStore alloc]init];
        
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted,NSError*_Nullable error) {
            
            if(granted) {
                
                NSLog(@"通讯录获取授权成功==");
                
                [self getContact]; //5.获取用户通讯录
                
            }else{
                
                NSLog(@"授权失败, error=%@", error);
                
            }
            
        }];
        
    }
    if(authorizationStatus ==CNAuthorizationStatusAuthorized) {
        [self getContact];
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
                
                NSDictionary*contact =@{@"phone":phoneNumber.stringValue,@"user":[NSString stringWithFormat: @"%@%@",familyName,givenName]};
                
                [contactArr addObject:contact];
                
                NSLog(@"label=%@, phone=%@", label, phoneNumber.stringValue);
                
            }
            
            //*stop = YES;// 停止循环，相当于break；
            
        }];
        
        _contactArr= contactArr;
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        //异步返回主线程，根据获取的数据，更新UI
        dispatch_async(mainQueue, ^{
            [self.myTableView reloadData];
        });
        
        NSError*error;
        
        NSData*jsonData = [NSJSONSerialization dataWithJSONObject:contactArr options:NSJSONWritingPrettyPrinted error:&error];//此处data参数是我上面提到的key为"data"的数组
        
        NSString*jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        _jsonString= jsonString;
        
        NSLog(@"jsonString====%@",jsonString);
        
        [self postContactTo]; //6.上传通讯录
        
    }else{
        
        NSLog(@"====通讯录没有授权====");
        
    }
    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _contactArr.count;
}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier =@"identifier";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSDictionary *dic =_contactArr[indexPath.row];
    cell.textLabel.text =dic[@"user"];
    cell.detailTextLabel.text =dic[@"phone"];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)postContactTo{
    
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
