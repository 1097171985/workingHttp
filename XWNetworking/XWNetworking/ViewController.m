//
//  ViewController.m
//  XWNetworking
//
//  Created by xinwang2 on 2017/12/19.
//  Copyright © 2017年 xinwang2. All rights reserved.
//

#import "ViewController.h"
#import "XWNetworkingManager.h"
#import "XWAfnGlobeConst.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btu = [UIButton buttonWithType:UIButtonTypeCustom];
    btu.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:btu];
    btu.backgroundColor = [UIColor redColor];
    [btu addTarget:self action:@selector(btu) forControlEvents:UIControlEventTouchUpInside];
  
    
    UIButton *btu1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btu1.frame = CGRectMake(100, 300, 100, 100);
    [self.view addSubview:btu1];
    btu1.backgroundColor = [UIColor redColor];
    [btu1 addTarget:self action:@selector(btu1) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)btu1{
    
    NSDictionary *dict = @{@"phone":@"13588767870",@"osType":@"01",@"city":@"杭州",@"token":@"123456"};

    [XWNetworkingManager xw_requestWithType:XWHttpRqquestTypePost withUrlString:@"https://renrenhongbao.com/xuanwu/account/GetPassWord" withParaments:dict progress:^(float progress) {
        NSLog(@"%f",progress);
    } successBlock:^(id resposeObject) {
        NSString *userAgent = [[[UIWebView alloc]init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSLog(@"前：%@",userAgent);
    } failureBlock:^(NSError *error) {
        
    }];
  
}

-(void)btu{
    
    
    NSDictionary *dict = @{@"phone":@"13588767870",@"osType":@"01",@"city":@"杭州",@"token":@"123456"};
    XWNetworkingHeaderUuid = @"beijing";
    XWNetworkingHeaderToken  = @"asdas";
    XWNetworkingHeaderUserAgent = @"gsgj";
    [XWNetworkingManager xw_requestWithType:XWHttpRqquestTypePost withUrlString:@"https://renrenhongbao.com/xuanwu/account/GetPassWord" withParaments:dict showHUDBlock:^(UIViewController *hudViewController) {
        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    } successBlock:^(id resposeObject) {
        
        
        UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0,50, 50)];
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.igeshui.com/share/taxOptimizationTest/index.html#/actuarialJob/jobResult?deviceId=ffffffff-bd53-2485-ffff-ffffe14ae335&token=aeceb1d3108049bbbdf5cea1258fadc0&recordId=dbb080d2bb9044dd9b0bde73aef5247b"]]];
        [self.view addSubview:web];
//        [MBProgressHUD dissmissShowView:self.view];
        NSString *userAgent = [[[UIWebView alloc]init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSLog(@"前：%@",userAgent);
        
    
        
    } failureBlock:^(NSError *error) {
        
//     [MBProgressHUD dissmissShowView:self.view];

    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
