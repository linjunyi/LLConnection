//
//  LLDownloaderDelegate.m
//  LLConnection
//
//  Created by lin on 15/12/30.
//  Copyright © 2015年 lin. All rights reserved.
//

#import "LLDownloaderOperation.h"

@interface  LLDownloaderOperation()

@property (nonatomic, copy)   NSURL                 *url;
@property (nonatomic, copy)   LLDownloaderBlock     completionBlock;
@property (nonatomic, copy)   LLProgressBlock       progressBlock;
@property (nonatomic, strong) NSURLConnection       *connection;
@property (nonatomic, strong) NSNumber              *totalLength;
@property (nonatomic, strong) NSMutableData         *downloadData;
@property (nonatomic, copy)   NSString              *downloadPath;
@property (nonatomic, strong) NSFileHandle          *writeHandle;
@property (nonatomic, copy)   NSString              *fileName;
@property (nonatomic, assign) BOOL                  finish;

@end

@implementation LLDownloaderOperation

@dynamic completionBlock;

- (instancetype)initWithURL:(NSURL *)url fileName:(NSString *)fileName completionBlock:(LLDownloaderBlock)completionBlock pregressBlock:(LLProgressBlock)pregressBlock {
    if (self = [super init]) {
        self.url = url;
        self.fileName = fileName;
        self.completionBlock = completionBlock;
        self.progressBlock   = pregressBlock;
        self.finish = NO;
    }
    return self;
}

- (void)start {
    self.downloadData = [[NSMutableData alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.connection start];
    CFRunLoopRun(); //启动线程的runloop，使线程不离开start方法，否则connection的delegate方法不会被调用，因为start方法结束，对象的生命周期即终止
    if (!self.finish) {
        [self connection:self.connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:@{NSURLErrorFailingURLErrorKey : self.url}]];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSLog(@"Download Fail");
            [self.connection cancel];
            CFRunLoopStop(CFRunLoopGetCurrent());
        }else {
            if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                NSDictionary *allHeader = [httpResponse allHeaderFields];
                self.totalLength = [allHeader objectForKey:@"Content-Length"];
            }
            NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            self.downloadPath  = [NSString stringWithFormat:@"%@/%@", cacheDir, self.fileName];
            [[NSFileManager defaultManager] createFileAtPath:self.downloadPath contents:nil attributes:nil];
            self.writeHandle   = [NSFileHandle fileHandleForWritingAtPath:self.downloadPath];
            
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.totalLength) {
        [self.downloadData appendData:data];
        [self.writeHandle seekToEndOfFile];
        [self.writeHandle writeData:data];
        float progress = ((float)(self.downloadData.length) / self.totalLength.floatValue * 100.0);
        self.progressBlock(progress);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"存储位置: %@", self.downloadPath);
    self.finish = YES;
    [self.connection cancel];
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.completionBlock(nil, self.downloadData, nil);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(nonnull NSError *)error {
    self.completionBlock(nil, nil, error);
}

@end
