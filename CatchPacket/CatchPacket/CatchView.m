//
//  CatchView.m
//  CatchPacket
//
//  Created by anyongxue on 2017/2/21.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CatchView.h"
#import "RedPacketView.h"

#define KRedPacket_w 90
#define KRedPacket_h ((90 * 515) / 607)

@interface CatchView ()
{
    NSMutableArray *imgViewArray;
    NSInteger index;
    CGRect catchRect;
}
@end

@implementation CatchView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        imgViewArray = [NSMutableArray array];
        index = 100;
        [self configUI];
    }
    return self;
}

- (void)drawRect2:(CGRect)rect {
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    CGFloat w = self.frame.size.width - 170;
    
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(85, (self.frame.size.height - w) / 2 - 100, w, w)];
    
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd; //中间镂空的关键点 填充规则
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.layer addSublayer:fillLayer];
}


- (void)configUI {
    
    _myImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 3, self.frame.size.height * 2)];
    _myImageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
//    _myImageView.backgroundColor = [UIColor blueColor];
    [self addSubview:_myImageView];

    //飞行区域
    _flightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 3, self.frame.size.height)];
//    _flightView.backgroundColor = [UIColor redColor];
    
    //显示为屏幕的一半?不理解? 因为_myImageView改变了中心
    
    _flightView.backgroundColor = [UIColor clearColor];
    [_myImageView addSubview:_flightView];
    
    //调用方法 画镂空形状
    [self drawRect2:self.frame];
    
    //捕捉区
    CGFloat x = 50;
    CGFloat w = self.frame.size.width - 100;
    CGFloat h = w;
    CGFloat y = (self.frame.size.height - h) / 2 - 100;
    
    _catchView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _catchView.image = [UIImage imageNamed:@"ic_circle_normal"];
    //[self addGestureRecognizer:tap];
    _catchView.userInteractionEnabled = YES;
    
    [self addSubview:_catchView];

    //捕捉button
    y += h + 100;
    w = 70;
    h = 70;
    x = (self.frame.size.width - w) / 2;
    
    _catchBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [_catchBtn setImage:[UIImage imageNamed:@"btn_catch_normal"] forState:UIControlStateNormal];
    [_catchBtn setImage:[UIImage imageNamed:@"btn_catch"] forState:UIControlStateSelected];
    [_catchBtn addTarget:self action:@selector(actionCatchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_catchBtn];

    
    UIImageView *ic_arrowImgVie = [[UIImageView alloc] initWithFrame:CGRectMake(_catchView.frame.origin.x - 10 / 2, _catchView.frame.origin.y - 10 / 2, _catchView.frame.size.width + 10, _catchView.frame.size.height + 10)];
    
    ic_arrowImgVie.image = [UIImage imageNamed:@"ic_arrow"];
    ic_arrowImgVie.userInteractionEnabled = YES;
    [self addSubview:ic_arrowImgVie];

    //点击圆圈进行捕捉
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionRedPacket_catchViewTap:)];
//    
//    [ic_arrowImgVie addGestureRecognizer:tap];
}

- (void)prepareData:(NSArray *)array {
    
    //607*515
    CGFloat RedPacket_w = 100;
    CGFloat RedPacket_h = 100;
    RedPacket_w = 90 * 515 / 607;
    RedPacket_h = 90 * 515 / 607;

    CGFloat maxx = self.frame.size.width * 3 - RedPacket_w;
    CGFloat maxy = self.frame.size.height - RedPacket_h;
    
    for (NSInteger i = 0; i < 4; i++) {
    
        CGFloat randomx = arc4random() % ((NSInteger) maxx);
        CGFloat randomy = arc4random() % ((NSInteger) maxy);
        
        RedPacketView *RedPacket = [[RedPacketView alloc] initWithFrame:CGRectMake(randomx, randomy, KRedPacket_w, KRedPacket_h)];
        
        RedPacket.image = [YLGIFImage imageNamed:@"bird.gif"];
        RedPacket.tag = 900 + i;
        RedPacket.userInteractionEnabled = YES;
        [_flightView addSubview:RedPacket];
        [imgViewArray addObject:RedPacket];
        [self RedPacketFiy2:RedPacket];
    }
    
     _timer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(jianCe) userInfo:nil repeats:YES];
}

- (void)jianCe {
    
    for (NSInteger i = 0; i < 4; i++) {
        
        RedPacketView *view1 = [self viewWithTag:900 + i];
        CGRect rect = [[view1.layer presentationLayer] frame]; // view指你的动画中移动的view
        
        if (CGRectIntersectsRect(rect, catchRect)) {
            
            _catchBtn.selected = YES;
            _catchView.image = [UIImage imageNamed:@"ic_circle"];
            NSLog(@"进来了");
            
            [UIView animateWithDuration:.1 animations:^{
                _catchView.transform = CGAffineTransformScale(_catchView.transform, .98, .98);
            }completion:^(BOOL finished) {
                _catchView.transform = CGAffineTransformIdentity;
            }];
            
            break;
        
        }else {
            
            NSLog(@"出去了");
            _catchView.image = [UIImage imageNamed:@"ic_circle_normal"];
            _catchView.transform = CGAffineTransformIdentity;
            
            _catchBtn.selected = NO;
        }
        
    }

    
    /*
     判断给定的点是否被一个CGRect包含,可以用CGRectContainsPoint函数
     BOOL contains = CGRectContainsPoint(CGRect rect, CGPoint point);
     
     判断一个CGRect是否包含再另一个CGRect里面,常用与测试给定的对象之间是否又重叠
     BOOL contains = CGRectContainsRect(CGRect rect1, CGRect rect2);
     
     判断两个结构体是否有交错.可以用CGRectIntersectsRect
     BOOL contains = CGRectIntersectsRect(CGRect rect1, CGRect rect2);
     
     float float_ = CGRectGetMaxX(CGRect rect);返回矩形右边缘的坐标
     CGRectGetMaxY返回矩形顶部的坐标
     CGRectGetMidX返回矩形中心X的坐标
     CGRectGetMidY返回矩形中心Y的坐标
     CGRectGetMinX返回矩形左边缘的坐标
     CGRectGetMinY返回矩形底部的坐标
     CGRectContainsPoint 看参数说明，一个点是否包含在矩形中，所以参数为一个点一个矩形
     */
    
}

- (void)RedPacketFiy2:(RedPacketView *)RedPacket {
    
    CGFloat RedPacket_w = KRedPacket_w;
    CGFloat RedPacket_h = KRedPacket_h;

    CGFloat maxx = self.frame.size.width * 3 - RedPacket_w;
    CGFloat maxy = self.frame.size.height - RedPacket_h;

    CGFloat random_x = arc4random() % ((NSInteger) maxx);
    CGFloat random_y = arc4random() % ((NSInteger) maxy);
    
    CGFloat Scalenum = [self randomBetween:0.5 And:3];
    
    if (RedPacket.state_size == 1 || RedPacket.state_size == 2) {
        
        //需要还原
        [UIView animateWithDuration:3 animations:^{
            
            RedPacket.frame = CGRectMake(random_x, random_y, RedPacket.frame.size.width, RedPacket.frame.size.height);
            RedPacket.transform = CGAffineTransformIdentity;
            RedPacket.state_size = 0;
            
        }completion:^(BOOL finished) {
            if (_timer) {
            
                [self RedPacketFiy2:RedPacket];
            }
        }];
        
    }else {
        
        [UIView animateWithDuration:3 animations:^{
            
            RedPacket.frame = CGRectMake(random_x, random_y, RedPacket.frame.size.width, RedPacket.frame.size.height);
            RedPacket.transform = CGAffineTransformScale(RedPacket.transform, Scalenum, Scalenum);
            
            if (Scalenum > 1) {
                RedPacket.state_size = 2;
            } else if (Scalenum < 1) {
                RedPacket.state_size = 1;
            } else {
                RedPacket.state_size = 0;
            }
            
        }completion:^(BOOL finished) {
            
            if (_timer) {
            
                [self RedPacketFiy2:RedPacket];
            }
        }];
    
    }

}

- (void)actionCatchBtn {
    if (_catchBtn.selected) {
        if (_delegate) {
            [_delegate catchRedPacket];
        }
    }
}

- (void)startAnimate {}


//随机返回某个区间范围内的值
- (CGFloat)randomBetween:(CGFloat)smallerNumber And:(CGFloat)largerNumber {

    //设置精确的位数
    int precision = 100;
    //先取得他们之间的差值
    float subtraction = largerNumber - smallerNumber;
    //取绝对值
    subtraction = ABS(subtraction);
    //乘以精度的位数
    subtraction *= precision;
    //在差值间随机
    float randomNumber = arc4random() % ((int) subtraction + 1);
    //随机的结果除以精度的位数
    randomNumber /= precision;
    //将随机的值加到较小的值上
    float result = MIN(smallerNumber, largerNumber) + randomNumber;
    //返回结果
    return result;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
