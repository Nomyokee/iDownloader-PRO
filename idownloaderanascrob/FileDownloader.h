//
//  FileDownloader.h
//  FreeMusicDownloader
//
//  Created by Pavel Pavlusha on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSUInteger numberOfFilesCurrentlyDownloading = 0;

@interface FileDownloader : NSObject <NSURLConnectionDelegate>
{
}

@property (nonatomic, retain) NSMutableData     *downloadData;
@property (nonatomic, retain) NSString          *fileName;
@property (nonatomic, retain) NSURLConnection   *connection;
@property (getter = isDownloadFinished) BOOL    downloadFinished;

@property (nonatomic) float alreadyDownloaded;
@property (nonatomic) float progress;
@property (nonatomic) long long fullSize;

- (void)downloadFile:(NSString *)URLString;
- (void)cancel;

+ (NSUInteger)numberOfFilesCurrentlyDownloading;

@end
