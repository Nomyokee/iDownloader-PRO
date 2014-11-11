//
//  FileDownloader.m
//  FreeMusicDownloader
//
//  Created by Pavel Pavlusha on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileDownloader.h"


@interface FileDownloader()

- (void) saveIntoFile;

@end


@implementation FileDownloader

@synthesize downloadData = _downloadData;
@synthesize fileName = _fileName;
@synthesize connection = _connection;
@synthesize downloadFinished = _downloadingFinished;
@synthesize alreadyDownloaded = _alreadyDownloaded;
@synthesize progress = _progress;
@synthesize fullSize = _fullSize;

+ (NSUInteger)numberOfFilesCurrentlyDownloading
{
    return numberOfFilesCurrentlyDownloading;
}
// Private Methods start

- (void)saveIntoFile
{
//    NSString *str = [NSString stringWithFormat:@"'%@', '%i', '0'", self.fileName, self.downloadData.length];
//    [liolik inscrieInTabelul:@"dataBase" incepindCuDrumul:baseLink inCompartimentele:@"name,size,fileOrFolder" valoarea:str];
}

// Private Methods end


- (void)downloadFile:(NSString *)URLString
{
    ++numberOfFilesCurrentlyDownloading;
    
    self.downloadFinished = NO;
    
    NSURL           *url     = [NSURL URLWithString:URLString];    
    NSURLRequest    *request = [NSURLRequest requestWithURL:url
                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                               timeoutInterval:MAXFLOAT];
    
    NSURLConnection *con     = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.connection = con;    
    
    if (self.connection != nil)
    {
        self.downloadData = [[NSMutableData alloc] init];
    }
    else
    {
        NSLog(@"Cannnot retreive data");
    }
    
    self.fileName = [URLString lastPathComponent];
    
    self.fileName = [[URLString lastPathComponent] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    self.fileName = [self.fileName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"%2B" withString:@" "];
}

- (void)cancel
{
    NSLog(@"%s", __FUNCTION__);
    
    [self.connection cancel];
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:@"Connection failed!!!" 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.downloadData.length = 0;
    
    self.progress = 0.0f;
    self.alreadyDownloaded = 0.0f;
    self.fullSize = [response expectedContentLength];
    
    NSLog(@"fullSize = %lld", self.fullSize);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%s", __FUNCTION__);

    [self.downloadData appendData:data];
    
//    alreadyDownloaded += [data length];
//    
//    NSLog(@"progress = %f", progress);
    
    self.progress = ((float)[self.downloadData length]) / self.fullSize;
    
//    NSLog(@"fullSize = %lld", fullSize);
//    NSLog(@"[self.downloadData length] = %u", [self.downloadData length]);
//    NSLog(@"progress = %f", ((float) [self.downloadData length]) / fullSize);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    --numberOfFilesCurrentlyDownloading;
    
    self.downloadFinished = YES;
    
    NSArray  *paths              = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file_path          = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.fileName]];
    
    [self.downloadData writeToFile:file_path atomically:YES];
    [self performSelector:@selector(saveIntoFile)];
        
    self.connection = nil;
}

@end
