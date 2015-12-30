//
//  LLDownloaderManager.h
//  LLConnection
//
//  Created by lin on 15/12/30.
//  Copyright © 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LLDownloadDelegate <NSObject>

- (void)downloadFinish:(NSData *)data;

@end

@interface LLDownloaderManager : NSObject

- (instancetype)initWithURL:(NSURL *)url fileName:(NSString *)fileName delegate:(id<LLDownloadDelegate>)delegate;
- (void)download;

@end
