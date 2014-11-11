//
//  FileViewerOrPlayerController_iPad.m
//  iDownloadAllPro
//
//  Created by Mac on 8/15/12.
//
//

#import "FileViewerOrPlayerController_iPad.h"


@interface FileViewerOrPlayerController_iPad ()

- (NSString *)saveFilePath;

@end


@implementation FileViewerOrPlayerController_iPad

@synthesize fileLoadingWebView = _fileLoadingWebView;

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

- (void)viewDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", [self saveFilePath], [defaults stringForKey:@"FileName"]];
    
    NSLog(@"fileName =  %@", fileName);
    
    [self.fileLoadingWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:fileName]]];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setFileLoadingWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (IBAction)onBackButtonTap
{
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"self.fileLoadingWebView.frame.size.width = %f", self.fileLoadingWebView.frame.size.width);
    NSLog(@"self.fileLoadingWebView.frame.size.height = %f", self.fileLoadingWebView.frame.size.height);
    
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

@end
