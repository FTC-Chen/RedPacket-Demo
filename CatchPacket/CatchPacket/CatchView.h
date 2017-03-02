//
//  CatchView.h
//  CatchPacket
//
//  Created by anyongxue on 2017/2/21.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLGIFImage.h"

@protocol MCCatchViewDelegate <NSObject>

- (void)catchRedPacket;

@end

@interface CatchView : UIView

//显示的图片
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIView *myImageView;
//飞行区域
@property (nonatomic, strong) UIView *flightView;
//捕捉区
@property (nonatomic, strong) UIImageView *catchView;
//捕捉button
@property (nonatomic, strong) UIButton *catchBtn;

@property (nonatomic, weak) id<MCCatchViewDelegate> delegate;

- (void)prepareData:(NSArray *)array;

@property (nonatomic, strong) NSTimer *timer;

//开始重力感应
- (void)startAnimate;
//停止重力感应
- (void)stopAnimate;
@end
