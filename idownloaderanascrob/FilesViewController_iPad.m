//
//  FilesViewController_iPad.m
//  iDownloadAllPro
//
//  Created by Mac on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilesViewController_iPad.h"
#import "EnterPasscodeViewController_iPad.h"
#import "FileViewerOrPlayerController_iPad.h"

@interface FilesViewController_iPad()

@property (nonatomic, strong) NSMutableArray *audioFileExtensionsArray;
@property (nonatomic, strong) NSMutableArray *videoFileExtensionsArray;
@property (nonatomic, strong) NSMutableArray *textFileExtensionsArray;
@property (nonatomic, strong) NSMutableArray *pdfFileExtensionsArray;
@property (nonatomic, strong) NSMutableArray *imageFileExtensionsArray;
@property (nonatomic, strong) NSMutableArray *archiveFileExtensionsArray;
@property (nonatomic, strong) NSMutableArray *wordFileExtensionsArray;
@property (nonatomic, strong) NSMutableArray *excelFileExtensionsArray;
@property (nonatomic, strong) NSMutableArray *powerPointFileExtensionsArray;

- (NSString *)saveFilePath;

@end


@implementation FilesViewController_iPad

@synthesize filesTableView = _filesTableView;
@synthesize filesNamesArray = _filesNamesArray;
@synthesize audioFileExtensionsArray = _audioFileExtensionsArray;
@synthesize videoFileExtensionsArray = _videoFileExtensionsArray;
@synthesize textFileExtensionsArray = _textFileExtensionsArray;
@synthesize pdfFileExtensionsArray = _pdfFileExtensionsArray;
@synthesize imageFileExtensionsArray = _imageFileExtensionsArray;
@synthesize archiveFileExtensionsArray = _archiveFileExtensionsArray;
@synthesize wordFileExtensionsArray = _wordFileExtensionsArray;
@synthesize excelFileExtensionsArray = _excelFileExtensionsArray;
@synthesize powerPointFileExtensionsArray = _powerPointFileExtensionsArray;

- (NSString *)saveFilePath
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [pathArray objectAtIndex:0];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.audioFileExtensionsArray = [[NSMutableArray alloc] initWithObjects:
                                     @"aac",
                                     @"aif",
                                     @"aiff",
                                     @"caf",
                                     @"mp3",
                                     @"m4a",
                                     @"m4r", // ? not sure
                                     @"wav", nil];
    
    self.videoFileExtensionsArray = [[NSMutableArray alloc] initWithObjects:
                                     @"mp4",
                                     @"mov",
                                     @"m4v",
                                     @"mpv",
                                     @"3gp",
                                     @"avi", nil];
    
    self.imageFileExtensionsArray = [[NSMutableArray alloc] initWithObjects:
                                     @"gif",
                                     @"jpeg",
                                     @"jpg",
                                     @"tif",
                                     @"tiff",
                                     @"ico",
                                     @"bmp",
                                     @"JPG",
                                     @"PNG", nil];
    
    self.textFileExtensionsArray = [[NSMutableArray alloc] initWithObjects:
                                    @"txt",
                                    @"rtf", nil];
    
    self.pdfFileExtensionsArray = [[NSMutableArray alloc] initWithObjects:@"pdf", nil];
    
    self.wordFileExtensionsArray = [[NSMutableArray alloc] initWithObjects:@"doc", @"docx", nil];
    
    self.excelFileExtensionsArray = [[NSMutableArray alloc] initWithObjects:@"xls", @"xlsx", nil];
    
    self.powerPointFileExtensionsArray = [[NSMutableArray alloc] initWithObjects:@"ppt", nil];
    
    self.archiveFileExtensionsArray = [[NSMutableArray alloc] initWithObjects:
                                       @"rar",
                                       @"zip",
                                       @"webarchive", nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openPasscodeViewIfNeeded)
                                                 name:@"OpenPasscodeViewIfNeeded"
                                               object:nil];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.filesNamesArray = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *filesNames = [fileManager contentsOfDirectoryAtPath:[self saveFilePath] error:nil];
    
    for (NSString *fileName in filesNames)
    {
        if ([fileName rangeOfString:@".DS_Store"].location == NSNotFound)
        {
            [self.filesNamesArray addObject:fileName];
        }
    }
    
    NSLog(@"self.filesNamesArray: %@", self.filesNamesArray);
    
    [self.filesTableView reloadData];
}

- (void)viewDidUnload
{
    [self setFilesTableView:nil];
    [self setFilesNamesArray:nil];
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
    return self.filesNamesArray.count;
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
        
        UIImageView *fileTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 18, 64, 64)];
        UILabel *fileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 600, 40)];
        UILabel *fileSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 55, 600, 24)];
        UIImageView *openFileImage = [[UIImageView alloc] initWithFrame:CGRectMake(700, 24, 51, 52)];
        
        fileTypeImage.tag = 1;
        
        fileNameLabel.tag = 2;
        fileNameLabel.font = [UIFont boldSystemFontOfSize:30.0f];
        fileNameLabel.backgroundColor = [UIColor clearColor];
        fileNameLabel.textColor = [UIColor darkGrayColor];
        
        fileSizeLabel.tag = 3;
        fileSizeLabel.font = [UIFont boldSystemFontOfSize:24.0f];
        fileSizeLabel.backgroundColor = [UIColor clearColor];
        fileSizeLabel.textColor = [UIColor whiteColor];
        
        openFileImage.image = [UIImage imageNamed:@"open_file"];
        
        [cell addSubview:backgroundImage];
        [cell addSubview:fileTypeImage];
        [cell addSubview:fileNameLabel];
        [cell addSubview:fileSizeLabel];
        [cell addSubview:openFileImage];
    }
    
    
    // Configure the cell.
    
    if ([self.audioFileExtensionsArray containsObject:[[self.filesNamesArray objectAtIndex:indexPath.row] pathExtension]])
    {
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"icon_audio"];
    }
    else if ([self.videoFileExtensionsArray containsObject:[[self.filesNamesArray objectAtIndex:indexPath.row] pathExtension]])
    {
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"icon_video"];
    }
    else if ([self.textFileExtensionsArray containsObject:[[self.filesNamesArray objectAtIndex:indexPath.row] pathExtension]])
    {
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"icon_text"];
    }
    else if ([self.pdfFileExtensionsArray containsObject:[[self.filesNamesArray objectAtIndex:indexPath.row] pathExtension]])
    {
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"icon_pdf"];
    }
    else if ([self.imageFileExtensionsArray containsObject:[[self.filesNamesArray objectAtIndex:indexPath.row] pathExtension]])
    {
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"icon_image"];
    }
    else if ([self.archiveFileExtensionsArray containsObject:[[self.filesNamesArray objectAtIndex:indexPath.row] pathExtension]])
    {
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"icon_archive"];
    }
    else if ([self.wordFileExtensionsArray containsObject:[[self.filesNamesArray objectAtIndex:indexPath.row] pathExtension]])
    {
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"icon_word"];
    }
    else if ([self.excelFileExtensionsArray containsObject:[[self.filesNamesArray objectAtIndex:indexPath.row] pathExtension]])
    {
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"icon_excel"];
    }
    else if ([self.powerPointFileExtensionsArray containsObject:[[self.filesNamesArray objectAtIndex:indexPath.row] pathExtension]])
    {
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"icon_ppt"];
    }
    
    ((UILabel *)[cell viewWithTag:2]).text = [self.filesNamesArray objectAtIndex:indexPath.row];
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@", [self saveFilePath], [self.filesNamesArray objectAtIndex:indexPath.row]] error:nil];
    
    UInt32 size = [fileAttributes fileSize];
    
    NSString *fileSize = (size < 1024 * 1024) ? [NSString stringWithFormat:@"%.2f kb", (CGFloat)size / 1024] : [NSString stringWithFormat:@"%.2f mb", (CGFloat)size / (1024 * 1024)];
    
    ((UILabel *)[cell viewWithTag:3]).text = fileSize;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    
    NSString *fileName = [self.filesNamesArray objectAtIndex:indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:fileName forKey:@"FileName"];
    [defaults synchronize];
    
    FileViewerOrPlayerController_iPad *vc = [[FileViewerOrPlayerController_iPad alloc] initWithNibName:@"FileViewerOrPlayerController_iPad" bundle:nil];
    
    //    [vc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    //    [self.navigationController presentModalViewController:vc animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)     tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!"
                                                        message:@"Are you sure you want me to delete this file?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Sure", nil];
        alert.tag = indexPath.row;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *fileName = [NSString stringWithFormat:@"%@/%@", [self saveFilePath], [self.filesNamesArray objectAtIndex:alertView.tag]];
        
        [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
        
        [self.filesNamesArray removeObject:[self.filesNamesArray objectAtIndex:alertView.tag]];
        [self.filesTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        //        [self.filesTableView reloadData];
    }
}

@end