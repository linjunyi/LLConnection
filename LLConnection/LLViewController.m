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

@end

@implementation LLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    LLDownloaderManager *manager = [[LLDownloaderManager alloc] initWithURL:[NSURL URLWithString:@"http://www.microfotos.com/pic/0/6/629/62954preview4.jpg"] fileName:@"image01.jpg" delegate:self];
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
