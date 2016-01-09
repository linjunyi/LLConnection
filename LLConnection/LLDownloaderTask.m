//
//  LLDownloaderTask.m
//  LLConnection
//
//  Created by lin on 16/1/9.
//  Copyright (c) 2016年 lin. All rights reserved.
//

#import "LLDownloaderTask.h"

@implementation LLDownloaderTask

- (instancetype)initWithURL:(NSURL *)url fileName:(NSString *)fileName delegate:(id)delegate {
    if (self = [super init]) {
        self.url = url;
        self.fileName = fileName;
        self.delegate = delegate;
    }
    return self;
}

@end
