//
//  LLDownloaderManager.m
//  LLConnection
//
//  Created by lin on 15/12/30.
//  Copyright © 2015年 lin. All rights reserved.
//

#import "LLDownloaderManager.h"
#import "LLDownloaderOperation.h"

@interface LLDownloaderManager ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy)   NSString *fileName;
@property (nonatomic, assign) id<LLDownloadDelegate> delegate;

@end

@implementation LLDownloaderManager

- (instancetype)initWithURL:(NSURL *)url fileName:(NSString *)fileName delegate:(id<LLDownloadDelegate>)delegate {
    if (self = [super init]) {
        self.url = url;
        self.fileName = fileName;
        self.delegate = delegate;
    }
    return self;
}

- (void)download {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
    [thread start];
}

- (void)start {
    __weak typeof (self) weakSelf = self;
    LLDownloaderBlock completionBlock = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        if ([weakSelf.delegate respondsToSelector:@selector(downloadFinish:)]) {
            [weakSelf.delegate downloadFinish:data];
        }
    };
    LLProgressBlock progressBlock = ^(float progress){
        NSLog(@"已下载 %.2f%%", progress);
    };
    
    LLDownloaderOperation *operation = [[LLDownloaderOperation alloc] initWithURL:self.url fileName:self.fileName completionBlock:completionBlock pregressBlock:progressBlock];
    [operation start];
    
}


@end
