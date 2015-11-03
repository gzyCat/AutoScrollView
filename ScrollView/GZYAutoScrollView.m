//
//  GZYAutoScrollView.m
//  MyScrollView
//
//  Created by 高子英 on 15/8/27.
//  Copyright (c) 2015年 gaozy. All rights reserved.
//

#import "GZYAutoScrollView.h"

#define ViewWidth self.bounds.size.width
#define ViewHeight self.bounds.size.height

#define Interal 5
#define TimeScroll 3

@interface GZYAutoScrollView () <UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    NSTimer *_timer;
}
@end


@implementation GZYAutoScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        [self updateUI];
    }
    return self;
}


#pragma mark - 更新UI
- (void)updateUI
{
    //移除所有原来自视图
//    [[_scrollView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [obj removeFromSuperview];
//    }];
    
    _scrollView.contentSize =CGSizeMake(_images.count * ViewWidth, 0) ;
    
    CGSize size = _scrollView.frame.size;
    for (int i = 0;  i < _images.count ; i++) {
        
        UIImageView *imgeView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width*i, 0, size.width, size.height)];
        UIImage *image = [UIImage imageNamed:_images[i]];
        imgeView.image = image;
        [_scrollView addSubview:imgeView];
        
    }
    _pageControl.numberOfPages = _images.count;
    [self bringSubviewToFront:_pageControl];
}

#pragma mark - 创建ScrollView,pageControl
- (void)createUI
{
    //设置背景初始化数组
    self.backgroundColor = [UIColor blackColor];
    _images = [[NSMutableArray array] init];
    

    //设置scrollView属性
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Interal, ViewWidth , ViewHeight - 2*Interal)];
    [self addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor redColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    
    //设置pageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _pageControl.center = CGPointMake(ViewWidth/2, ViewHeight -10);
    [_pageControl addTarget:self action:@selector(dealPage:) forControlEvents:UIControlEventValueChanged];
    [_pageControl setTintColor:[UIColor redColor]];;
    [self addSubview:_pageControl];
    
    //创建循环滚动timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimeScroll target:self selector:@selector(dealTimer:) userInfo:_pageControl repeats:YES];
    
}

#pragma mark - 处理时间、page事件
- (void)dealTimer:(NSTimer *) timer
{
    if (_isRevolve) {
        NSInteger index = _pageControl.currentPage +1;
        index ==_images.count ? index=0:index;
        _scrollView.contentOffset = CGPointMake(index*_scrollView.bounds.size.width,0);
    }
    
}

- (void)dealPage:(UIPageControl *)page
{
    CGSize size = _scrollView.bounds.size;
    NSInteger index = page.currentPage;
    NSLog(@"index=%ld",index);
    _scrollView.contentOffset = CGPointMake(index*size.width,0);
}

#pragma mark - 自动滚动视图代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGSize size = _scrollView.bounds.size;
    CGPoint point =  scrollView.contentOffset;
    
    //NSLog(@"point:%@",NSStringFromCGPoint(point));
    
   int index = point.x/size.width;
    
    _pageControl.currentPage = index;
}


#pragma mark - 属性设置
- (void)setIsRevolve:(BOOL)isRevolve
{
    if (isRevolve) {
        _isRevolve = YES;
        [_timer setFireDate:[NSDate distantPast]];
    }else
    {
        _isRevolve = NO;
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)setImages:(NSMutableArray *)images
{
    _images = images;
    [self updateUI];
}

- (void)dealloc
{
    [_timer invalidate];
}

@end
