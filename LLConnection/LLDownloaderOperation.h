//
//  LLDownloaderDelegate.h
//  LLConnection
//
//  Created by lin on 15/12/30.
//  Copyright © 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LLDownloaderBlock)(NSURLResponse *response, NSData *data, NSError *error);
typedef void(^LLProgressBlock)(float progress);

@interface LLDownloaderOperation : NSOperation

- (instancetype)initWithURL:(NSURL *)url fileName:(NSString *)fileName completionBlock:(LLDownloaderBlock)completionBlock pregressBlock:(LLProgressBlock)pregressBlock;

@end
