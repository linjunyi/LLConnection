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
    [[LLDownloaderManager shareManager] addTaskWithURL:[NSURL URLWithString:@"http://pic.818today.com/imgsy/image/201511/17_091720lc.jpg"] fileName:@"131.jpg" delegate:self];
    [[LLDownloaderManager shareManager] addTaskWithURL:[NSURL URLWithString:@"http://60.220.196.206/ws.cdn.baidupcs.com/file/1fcf3c475e9efdbca9ed6375e7a1065a?bkt=p2-nj-981&xcode=4a3cb1e4d91ece4649f0bc31110d714a2492d417c829d2ffed03e924080ece4b&fid=840488649-250528-458720856398431&time=1452323586&sign=FDTAXGERLBH-DCb740ccc5511e5e8fedcff06b081203-sHwelGbmiuBG8H15ajG2l%2F6RtJM%3D&to=hc&fm=Nin,B,U,nc&sta_dx=1214&sta_cs=9788&sta_ft=ISO&sta_ct=7&fm2=Ningbo,B,U,nc&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=14001fcf3c475e9efdbca9ed6375e7a1065a1a06fc2800004bda0000&sl=75759694&expires=8h&rt=pr&r=638563452&mlogid=200249136137310740&vuk=840488649&vbdid=146600018&fin=MicroSoft%20Office%202011%20Mac.ISO&fn=MicroSoft%20Office%202011%20Mac.ISO&slt=pm&uta=0&rtype=1&iv=0&isw=0&dp-logid=200249136137310740&dp-callid=0.1.1&wshc_tag=0&wsts_tag=5690b302&wsid_tag=dddaad1a&wsiphost=ipdbm"] fileName:@"03.ISO" delegate:self];
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
