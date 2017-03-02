//
//  ViewController.m
//  CatchPacket
//
//  Created by anyongxue on 2017/2/21.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ViewController.h"
#import "CatchRedPacketViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)catchRedPackrtAction:(UIButton *)sender {
    
    CatchRedPacketViewController *catchVC = [[CatchRedPacketViewController alloc] init];
    
    [self presentViewController:catchVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
