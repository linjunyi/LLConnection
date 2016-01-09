//
//  LLDownloaderTask.h
//  LLConnection
//
//  Created by lin on 16/1/9.
//  Copyright (c) 2016年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLDownloaderTask : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy)   NSString *fileName;
@property (nonatomic, assign) id delegate;

- (instancetype)initWithURL:(NSURL *)url fileName:(NSString *)fileName delegate:(id)delegate;

@end
