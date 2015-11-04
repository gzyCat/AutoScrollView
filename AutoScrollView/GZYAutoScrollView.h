//
//  GZYAutoScrollView.h
//  MyScrollView
//
//  Created by 高子英 on 15/8/27.
//  Copyright (c) 2015年 gaozy. All rights reserved.
//

//未添加循环滚动的效果，后期添加此效果！！！


#import <UIKit/UIKit.h>

@interface GZYAutoScrollView : UIView

@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic) BOOL isRevolve;

- (void)setImages:(NSMutableArray *)images;
- (void)setIsRevolve:(BOOL)isRevolve;
@end
