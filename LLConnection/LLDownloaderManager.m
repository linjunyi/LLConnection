//
//  LLDownloaderManager.m
//  LLConnection
//
//  Created by lin on 15/12/30.
//  Copyright © 2015年 lin. All rights reserved.
//

#import "LLDownloaderManager.h"
#import "LLDownloaderTask.h"
#import "LLDownloaderOperation.h"

@interface LLDownloaderManager ()

@property (nonatomic, strong) NSMutableDictionary *taskDic;
@property (nonatomic, strong) NSMutableDictionary *operationDic;

@end

@implementation LLDownloaderManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static LLDownloaderManager *shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[LLDownloaderManager alloc] init];
    });
    return shareInstance;
}

- (void)addTaskWithURL:(NSURL *)url fileName:(NSString *)fileName delegate:(id<LLDownloadDelegate>)delegate {
    LLDownloaderTask *task = [[LLDownloaderTask alloc] initWithURL:url fileName:fileName delegate:delegate];
    @synchronized(self) {
        if (_taskDic == nil) {
            _taskDic = [NSMutableDictionary dictionary];
        }
        if ([_taskDic objectForKey:fileName] == nil) {
            [_taskDic setObject:task forKey:fileName];
        }
    }
    [self download:fileName];
}

- (void)download:(NSString *)fileName {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
    thread.name = fileName;
    [thread start];
}

- (void)start {
    __weak typeof (self) weakSelf = self;
    LLDownloaderBlock completionBlock = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        NSString *fileName = [NSThread currentThread].name;
        LLDownloaderTask *task = weakSelf.taskDic[fileName];
        if ([task.delegate respondsToSelector:@selector(downloadFinish:)]) {
            if (task) {
                [task.delegate downloadFinish:data];
            }
        }
    };
    LLProgressBlock progressBlock = ^(float progress){
        NSLog(@"已下载 %.2f%%", progress);
    };
    
    NSString *fileName = [NSThread currentThread].name;
    LLDownloaderTask *task = self.taskDic[fileName];
    LLDownloaderOperation *operation = [[LLDownloaderOperation alloc] initWithURL:task.url fileName:task.fileName completionBlock:completionBlock pregressBlock:progressBlock];
    @synchronized(self) {
        if (self.operationDic == nil) {
            self.operationDic = [NSMutableDictionary dictionary];
        }
        [self.operationDic setObject:operation forKey:fileName];
    }
    [operation start];
}

- (void)cancelTaskWithFileName:(NSString *)fileName {
    @synchronized(self) {
        LLDownloaderOperation *operation = (LLDownloaderOperation *)(self.operationDic[fileName]);
        [self.operationDic removeObjectForKey:fileName];
        [operation cancel];
    }
}

- (void)cancelAllTask {
    @synchronized(self) {
        for (LLDownloaderOperation *operation in self.operationDic.allValues) {
            [operation cancel];
        }
    }
}

@end
