//
//  CatchRedPacketViewController.m
//  CatchPacket
//
//  Created by anyongxue on 2017/2/21.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CatchRedPacketViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMotion/CoreMotion.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SceneKit/SceneKit.h>
#import "CatchView.h"

@interface CatchRedPacketViewController ()<SCNSceneRendererDelegate, MCCatchViewDelegate>
{
    SCNVector3 forwardDirectionVector;
    UIView *_bgview;
    SCNView *_scnView;
    CatchView *catchImgView;
}

//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession *session;
//提供来自设备的数据
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
//用于捕捉静态图片
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
//用于自动显示相机产生的实时图像,它拥有 session (outputs 被 session 所拥有)
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation CatchRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAVCaptureSession];
    [self.session startRunning];
    
    [self intView];
}

- (void)intView {
    _bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bgview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgview];
    
    [self addImgview];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40 - 10, 30, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"btn_close_normal"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(actionBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:backBtn];
}

- (void)addImgview {
    catchImgView = [[CatchView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    catchImgView.delegate = self;
    [catchImgView prepareData:nil];
    
    [_bgview addSubview:catchImgView];
    
    [catchImgView startAnimate];
}

- (void)initAVCaptureSession {
    
    self.session = [[AVCaptureSession alloc] init];
    NSError *error;

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    //    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }

    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    self.previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:self.previewLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MCCatchViewDelegate
- (void)catchRedPacket {
    
    [self actionBackBtn];
}

- (void)actionBackBtn {
    [self.session stopRunning];
    
    [catchImgView.timer invalidate];
    
    catchImgView.timer = nil;
    [catchImgView stopAnimate];
    
    [catchImgView.myImageView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
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
