//
//  ViewController.m
//  LLConnection
//
//  Created by lin on 15/12/30.
//  Copyright © 2015年 lin. All rights reserved.
//

#import "LLViewController.h"
#import "LLDownloaderManager.h"
#import "UIView+Property.h"

@interface LLViewController ()<LLDownloadDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton    *startBtn;

@end

@implementation LLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    LLDownloaderManager *manager = [[LLDownloaderManager alloc] initWithURL:[NSURL URLWithString:@"http://60.220.196.206/ws.cdn.baidupcs.com/file/1fcf3c475e9efdbca9ed6375e7a1065a?bkt=p2-nj-981&xcode=9998799de88d2fd620076c6c6d18826f1a2d5db9287d18fdea3971ac1f4f1a6a&fid=840488649-250528-458720856398431&time=1451823244&sign=FDTAXGERLBH-DCb740ccc5511e5e8fedcff06b081203-DnJvUW%2BpUYlrcEAbgFH7U9%2BUbfg%3D&to=lc&fm=Nin,B,U,nc&sta_dx=1214&sta_cs=9729&sta_ft=ISO&sta_ct=7&fm2=Ningbo,B,U,nc&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=14001fcf3c475e9efdbca9ed6375e7a1065a1a06fc2800004bda0000&sl=74711118&expires=8h&rt=pr&r=943210795&mlogid=65939787696508539&vuk=840488649&vbdid=3880713435&fin=MicroSoft%20Office%202011%20Mac.ISO&fn=MicroSoft%20Office%202011%20Mac.ISO&slt=pm&uta=0&rtype=1&iv=0&isw=0&dp-logid=65939787696508539&dp-callid=0.1.1&wshc_tag=0&wsts_tag=5689108d&wsid_tag=72f0fd3f&wsiphost=ipdbm"] fileName:@"02.ISO" delegate:self];
    [manager download];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)downloadFinish:(NSData *)data {
    if (data != nil) {
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image;
    }
}

#pragma mark --property

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _imageView.center = CGPointMake(self.view.width / 2, self.view.frame.size.height / 2);
    }
    return _imageView;
}

@end
