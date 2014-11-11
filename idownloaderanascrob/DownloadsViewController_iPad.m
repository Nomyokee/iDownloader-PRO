//
//  DownloadsViewController_iPad.m
//  iDownloadAllPro
//
//  Created by Mac on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DownloadsViewController_iPad.h"
#import "EnterPasscodeViewController_iPad.h"
#import "FileDownloader.h"


@interface DownloadsViewController_iPad()

- (void)startNewDownload;
- (void)onCancelDownloadButtonTap:(UIButton *)sender;
- (void)refreshDownloadsInfo;

@end


@implementation DownloadsViewController_iPad

@synthesize downloadsTableView = _downloadsTableView;

- (void)startNewDownload
{
    NSLog(@"%s", __FUNCTION__);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    Byte maxSimultaneousDownloads = (Byte)[defaults integerForKey:@"SimultaneousDownloads"];
    
    NSString *adressForFileDownload = [defaults objectForKey:@"DownloadLink"];
    
    if (adressForFileDownload != nil)
    {
        //        if (downloadsArray.count >= maxSimultaneousDownloads)
        if ([FileDownloader numberOfFilesCurrentlyDownloading] >= maxSimultaneousDownloads)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" 
                                                            message:@"Please wait at least one file to finish downloading" 
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {        
            //            [self downloadLink:adressForFileDownload];
            NSLog(@"uuu");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *downloadLink = [defaults stringForKey:@"DownloadLink"];
            
            FileDownloader *downloader = [[FileDownloader alloc] init];
            
            [downloader downloadFile:downloadLink];
            [downloadsArray addObject:downloader];
            
            [self.downloadsTableView reloadData];
            
            [defaults removeObjectForKey:@"DownloadLink"];
            [defaults synchronize];
        }
    }
}

- (void)onCancelDownloadButtonTap:(UIButton *)sender
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"tag = %d", sender.tag);
    
    FileDownloader *fileDownloader = [downloadsArray objectAtIndex:sender.tag - 10];
    
    if (fileDownloader.isDownloadFinished)
    {
        [downloadsArray removeObjectAtIndex:sender.tag - 10];
        [self.downloadsTableView reloadData];
    }
    else
    {
        NSString *message = @"Are you sure you want me to CANCEL downloading this file";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS"
                                                        message:message
                                                       delegate:self 
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"Sure", nil];
        
        alert.tag = sender.tag - 10 + 100;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s", __FUNCTION__);
    
    if (buttonIndex == 1)
    {
        FileDownloader *fileDownloader = [downloadsArray objectAtIndex:alertView.tag - 100];
        
        [fileDownloader cancel]; 
        [downloadsArray removeObjectAtIndex:alertView.tag - 100];
        
        [self.downloadsTableView reloadData];
    }
}

- (void)refreshDownloadsInfo
{
    NSLog(@"%s", __FUNCTION__);
    
    [self.downloadsTableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) 
    {
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)openPasscodeViewIfNeeded
{
    NSLog(@"%s", __FUNCTION__);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"PasscodeLock"] == YES) 
    {
        if (self.view.window)
        {
            EnterPasscodeViewController_iPad *epvc = [[EnterPasscodeViewController_iPad alloc] initWithNibName:@"EnterPasscodeViewController_iPad" bundle:nil];
            
            [epvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            [self.navigationController presentModalViewController:epvc animated:YES];
        }
    }   
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(openPasscodeViewIfNeeded) 
                                                 name:@"OpenPasscodeViewIfNeeded" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(startNewDownload)
                                                 name:@"StartNewDownload" 
                                               object:nil];
    
    downloadsArray = [NSMutableArray array];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5f 
                                     target:self 
                                   selector:@selector(refreshDownloadsInfo) 
                                   userInfo:nil 
                                    repeats:YES];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startNewDownload];
}

- (void)viewDidUnload
{
    [self setDownloadsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma UITableView delegate methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    //    return 8;
    return downloadsArray.count;
}

- (CGFloat)     tableView:(UITableView *)tableView 
  heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
    return 100.0f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_background"]];
        UIButton *cancelDownloadButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 51, 52)];
        UILabel *downloadinfFileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, 550, 40)];
        UIProgressView *downloadsProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(75, 68, 550, 20)];
        UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(640, 25, 110, 24)];
        UILabel *downloadsSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(640, 62, 110, 20)];
        
        cancelDownloadButton.tag = 10 + indexPath.row;
        [cancelDownloadButton setImage:[UIImage imageNamed:@"cancel_download_button"] forState:UIControlStateNormal];
        [cancelDownloadButton addTarget:self 
                                 action:@selector(onCancelDownloadButtonTap:)
                       forControlEvents:UIControlEventTouchUpInside];
        
        downloadinfFileNameLabel.tag = 1;
        downloadinfFileNameLabel.font = [UIFont boldSystemFontOfSize:35.0f];
        downloadinfFileNameLabel.backgroundColor = [UIColor clearColor];
        downloadinfFileNameLabel.textColor = [UIColor brownColor];
        
        downloadsProgressView.tag = 2;
        
        progressLabel.tag = 3;
        progressLabel.font = [UIFont boldSystemFontOfSize:24.0f];
        progressLabel.backgroundColor = [UIColor clearColor];
        progressLabel.textColor = [UIColor redColor];
        
        downloadsSpeedLabel.tag = 4;
        downloadsSpeedLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        downloadsSpeedLabel.backgroundColor = [UIColor clearColor];
        downloadsSpeedLabel.textColor = [UIColor whiteColor];
        
        [cell addSubview:backgroundImage];
        [cell addSubview:cancelDownloadButton];
        [cell addSubview:downloadinfFileNameLabel];
        [cell addSubview:downloadsProgressView];
        [cell addSubview:progressLabel];
        [cell addSubview:downloadsSpeedLabel];
    }
    
    
    // Configure the cell.
    
    FileDownloader *tmpFileDownloader = (FileDownloader *) [downloadsArray objectAtIndex:indexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL clearFinishedDownloads = [defaults boolForKey:@"ClearFinishedDownloads"];
    
    if (tmpFileDownloader.isDownloadFinished) 
    {
        if (clearFinishedDownloads)
        {
            [downloadsArray removeObjectAtIndex:indexPath.row];
            [self.downloadsTableView reloadData];
        }
        else
        {
            ((UILabel *)[cell viewWithTag:1]).text = tmpFileDownloader.fileName;
            
            ((UIProgressView *)[cell viewWithTag:2]).progress = 0;
            
            long long sizeLong = tmpFileDownloader.fullSize;
            float size = (float)sizeLong / 1024;
            
            downloadedSize = [tmpFileDownloader downloadData].length / 1024;
            
            float difference = downloadedSize - tmpFileDownloader.alreadyDownloaded;
            
            //        if (difference != 0.0f) 
            //        {
            //             tmpFileDownloader.progress = tmpFileDownloader.progress + 1 / size * difference;
            //        }
            
            ((UIProgressView *)[cell viewWithTag:2]).progress = tmpFileDownloader.progress;
            
            NSString *downloaded = [NSString stringWithFormat:@"%.2f kb", downloadedSize];
            
            if (downloadedSize > 1023) 
            {
                downloaded = [NSString stringWithFormat:@"%.2f mb", downloadedSize / 1024];
            }
            
            NSString *sizeStr = [NSString stringWithFormat:@"%.2f kb", size];
            
            if (size > 1023) 
            {
                sizeStr = [NSString stringWithFormat:@"%.2f mb", size / 1024];
            }
            
            NSString *speed = [NSString stringWithFormat:@"%.2f kb/s", difference];
            
            if (difference > 1023) 
            {
                speed = [NSString stringWithFormat:@"%.2f mb/s", difference / 1024];
            }    
            
            ((UILabel *)[cell viewWithTag:4]).text = [NSString stringWithFormat:@"%@", speed];
            
            if (difference == 0.0f && [tmpFileDownloader downloadData].length > 0)
            {
                ((UILabel *)[cell viewWithTag:4]).text = @"0.00 kb/s";
            }
            
            if (tmpFileDownloader.isDownloadFinished)
            {
                ((UILabel *)[cell viewWithTag:4]).text = @"Ready";
            }
            
            ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%@", downloaded];
            
            tmpFileDownloader.alreadyDownloaded = downloadedSize;
        }              
    }
    else
    {
        ((UILabel *)[cell viewWithTag:1]).text = tmpFileDownloader.fileName;
        
        ((UIProgressView *)[cell viewWithTag:2]).progress = 0;
        
        long long sizeLong = tmpFileDownloader.fullSize;
        float size = (float)sizeLong / 1024;
        
        downloadedSize = [tmpFileDownloader downloadData].length / 1024;
        
        float difference = downloadedSize - tmpFileDownloader.alreadyDownloaded;
        
        //        if (difference != 0.0f) 
        //        {
        //             tmpFileDownloader.progress = tmpFileDownloader.progress + 1 / size * difference;
        //        }
        
        ((UIProgressView *)[cell viewWithTag:2]).progress = tmpFileDownloader.progress;
        
        NSString *downloaded = [NSString stringWithFormat:@"%.2f kb", downloadedSize];
        
        if (downloadedSize > 1023) 
        {
            downloaded = [NSString stringWithFormat:@"%.2f mb", downloadedSize / 1024];
        }
        
        NSString *sizeStr = [NSString stringWithFormat:@"%.2f kb", size];
        
        if (size > 1023) 
        {
            sizeStr = [NSString stringWithFormat:@"%.2f mb", size / 1024];
        }
        
        NSString *speed = [NSString stringWithFormat:@"%.2f kb/s", difference];
        
        if (difference > 1023) 
        {
            speed = [NSString stringWithFormat:@"%.2f mb/s", difference / 1024];
        }    
        
        ((UILabel *)[cell viewWithTag:4]).text = [NSString stringWithFormat:@"%@", speed];
        
        if (difference == 0.0f && [tmpFileDownloader downloadData].length > 0)
        {
            ((UILabel *)[cell viewWithTag:4]).text = @"0.00 kb/s";
        }
        
        if (tmpFileDownloader.isDownloadFinished)
        {
            ((UILabel *)[cell viewWithTag:4]).text = @"Ready";
        }
        
        ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%@", downloaded];
        
        tmpFileDownloader.alreadyDownloaded = downloadedSize;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (IBAction)onButtonClearTap:(UIButton *)sender 
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"tag = %d", sender.tag);
    
    BOOL thereIsAtLeastOneFileDownloading = NO;
    
    for (int i = 0; i < downloadsArray.count; i++)
    {
        if (!((FileDownloader *) [downloadsArray objectAtIndex:i]).isDownloadFinished)
        {
            thereIsAtLeastOneFileDownloading = YES;
            break;
        }
    }
    
    if (thereIsAtLeastOneFileDownloading)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!" 
                                                        message:@"Please wait for me to finish downloading files"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        downloadsArray = nil;
        downloadsArray = [NSMutableArray array];
        
        [self.downloadsTableView reloadData];
    }
}

@end