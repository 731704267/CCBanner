//
//  CCBanner.m
//  test
//
//  Created by cassidy on 2018/4/2.
//  Copyright © 2018年 cassidy. All rights reserved.
//

#import "CCBanner.h"

#define DEFAULTTIME 3.0
#define PAGEUINDICATORTINTCOLOR [UIColor whiteColor]
#define CURRENTPAGEUINDICATORTINTCOLOR [UIColor blackColor]
@interface CCBanner()<UIScrollViewDelegate>
{
    CGFloat preOffsetX;
}
@property (nonatomic, strong) UIScrollView *ccScrollView;
@property (nonatomic, strong) UIPageControl *ccPageController;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CCBanner
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        self.frame = frame;
        self.ccScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.ccScrollView.pagingEnabled = YES;
        self.ccScrollView.showsHorizontalScrollIndicator = NO;
        self.ccScrollView.showsVerticalScrollIndicator = NO;
        self.ccScrollView.delegate = self;
        [self addSubview:self.ccScrollView];
        
    }
    return self;
}

- (void)setCurrentPageColor:(UIColor *)currentPageColor{
    _currentPageColor = currentPageColor;
    _ccPageController.currentPageIndicatorTintColor = _currentPageColor;
}
- (void)setPageColor:(UIColor *)pageColor{
    _pageColor = pageColor;
    _ccPageController.pageIndicatorTintColor = _pageColor;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    if (imageArray) {
        self.ccScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * (imageArray.count+2), CGRectGetHeight(self.frame));
        
        //最左侧添加一张最后的图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [imageView setImage:[imageArray objectAtIndex:(imageArray.count-1)]];
        imageView.backgroundColor = [UIColor redColor];
        imageView.tag = 1001;
        [self setImageTouch:imageView];
         [self.ccScrollView addSubview:imageView];
        //第二章开始按顺序添加图片
        for (unsigned int i = 0; i < imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) * (i + 1), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            [imageView setImage:[imageArray objectAtIndex:i]];
            imageView.tag = i + 1001;
            switch (i) {
                case 0:
                     imageView.backgroundColor = [UIColor yellowColor];
                    break;
                case 1:
                    imageView.backgroundColor = [UIColor blueColor];
                    break;
                case 2:
                    imageView.backgroundColor = [UIColor greenColor];
                    break;
                case 3:
                    imageView.backgroundColor = [UIColor redColor];
                    break;
                default:
                    break;
            }
            [self setImageTouch:imageView];
            [self.ccScrollView addSubview:imageView];
            [self.ccScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
        }
        
        //最右侧侧添加一张第一张的图片
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) * (self.imageArray.count + 1), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [rightImageView setImage:[imageArray objectAtIndex:0]];
        rightImageView.backgroundColor = [UIColor yellowColor];
        rightImageView.tag = 1000 +  imageArray.count;
        [self setImageTouch:rightImageView];
        [self.ccScrollView addSubview:rightImageView];
        [self addSubview:self.ccPageController];
        

        
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:DEFAULTTIME target:self selector:@selector(changePageToRight) userInfo:nil repeats:YES];
}
-(void)setImageTouch:(UIImageView *)imageview{
    imageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [imageview addGestureRecognizer:singleTap];
}

-(void)handleSingleTap:(id)sender{
    //用tag传值判断
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIImageView *imageView = (UIImageView *)tap.view;
    [self.delegate BannerViewTouch:(imageView.tag - 1001)];
    
}
-(void)changePageToRight{
    //设置将要滑动到的偏移量
    CGFloat offsetX = self.ccScrollView.contentOffset.x + CGRectGetWidth(self.frame);
    //获取当前页面最大可偏移量
    CGFloat edgeOffsetX = CGRectGetWidth(self.frame) * (self.imageArray.count +1) ;
    
    //比较要偏移的偏移量与最大可偏移的偏移量
    if (offsetX >= edgeOffsetX) {
        //如果要偏移的量大于最大偏移量说明要滑动到第一个图片，返回到第一个图片（偏移量为一个左视图）
        [self.ccScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        //
        offsetX = CGRectGetWidth(self.frame);
    }
    
    [self.ccScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    NSLog(@"%f", offsetX);
    if (offsetX < CGRectGetWidth(self.frame)) {
        self.ccPageController.currentPage = self.imageArray.count;
    }else if ( offsetX <= CGRectGetWidth(self.frame)*(self.imageArray.count + 1)){
        self.ccPageController.currentPage = offsetX / CGRectGetWidth(self.frame) - 1;
    }else if ( offsetX > CGRectGetWidth(self.frame)*(self.imageArray.count + 1)){
        self.ccPageController.currentPage = 0;
    }
    
    
}

#pragma UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //记录当前偏移量，用于在之后结束滑动函数中判断是左滑还是右滑
    preOffsetX = scrollView.contentOffset.x;
    
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat leftOffset = 0;
    CGFloat rightOffset = CGRectGetWidth(self.frame) * (self.imageArray.count + 1);
    
//    NSLog(@"%f",rightOffset);
//    NSLog(@"原始量%f",preOffsetX);
//    NSLog(@"滑动偏移量%f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x <= preOffsetX && preOffsetX < CGRectGetWidth(self.frame) * (self.imageArray.count + 1)) {
        //向左滑动
        if (scrollView.contentOffset.x <= leftOffset ) {
            //等于最左时显示最后一张图片
            [self.ccScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame) * self.imageArray.count, 0) animated:NO];
        }
    }else{
        if (scrollView.contentOffset.x >= rightOffset ) {
            //大于最右时显示第一张图片也就是第二的位置
            [self.ccScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame) , 0) animated:NO];
        }
    }
    
    if (scrollView.contentOffset.x < CGRectGetWidth(self.frame)) {
        self.ccPageController.currentPage = self.imageArray.count;
    } else if (scrollView.contentOffset.x <= CGRectGetWidth(self.frame) * (self.imageArray.count+1) ){
        self.ccPageController.currentPage = scrollView.contentOffset.x / CGRectGetWidth(self.frame) -1;
    }else if ( scrollView.contentOffset.x > CGRectGetWidth(self.frame) * (self.imageArray.count+1)){
        self.ccPageController.currentPage = 0;
    }
    
    [self.timer setFireDate:[NSDate dateWithTimeInterval:DEFAULTTIME sinceDate:[NSDate date]]];
    
}

//懒加载pageControl
- (UIPageControl *)ccPageController{
    
    if (!_ccPageController) {
        //初始化小圆点
        _ccPageController = [[UIPageControl alloc]initWithFrame:CGRectMake(40, self.ccScrollView.frame.size.height-40, self.frame.size.width-100, 40)];
        //设置页数
        _ccPageController.numberOfPages = self.imageArray.count;
        //设置圆点指示器的小圆点颜色
        
        _ccPageController.pageIndicatorTintColor = self.pageColor == nil?PAGEUINDICATORTINTCOLOR:self.pageColor;
        //设置当前小圆点的颜色
        _ccPageController.currentPageIndicatorTintColor = self.currentPageColor==nil?CURRENTPAGEUINDICATORTINTCOLOR:self.currentPageColor;
    }
    return _ccPageController;
}



@end
