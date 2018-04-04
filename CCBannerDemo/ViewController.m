//
//  ViewController.m
//  CCBannerDemo
//
//  Created by cassidy on 2018/4/4.
//  Copyright © 2018年 cassidy. All rights reserved.
//

#import "ViewController.h"
#import "CCBanner.h"
@interface ViewController ()<CCBannerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CCBanner *banner = [[CCBanner alloc]initWithFrame:CGRectMake(100, 100, 300, 110)];
    UIImage * a = [[UIImage alloc]init];
    UIImage * b = [[UIImage alloc]init];
    
    banner.imageArray = @[a,b,a,b];
    banner.delegate = self;
    [self.view addSubview:banner];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BannerViewTouch:(NSInteger)number{
    NSLog(@"第几个%d", (int)number);
}
@end
