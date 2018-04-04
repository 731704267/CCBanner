//
//  CCBanner.h
//  test
//
//  Created by cassidy on 2018/4/2.
//  Copyright © 2018年 cassidy. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义一个协议
@protocol CCBannerDelegate <NSObject>

@required //必须实现的方法
@optional //可选实现的方法
-(void)BannerViewTouch:(NSInteger)number;


@end

@interface CCBanner : UIView
@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, weak) id<CCBannerDelegate> delegate;
@property (nonatomic, strong) UIColor *currentPageColor;
@property (nonatomic, strong) UIColor *pageColor;
@end
