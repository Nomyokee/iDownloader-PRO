//
//  BrowserViewController_iPad.m
//  iDownloadAllPro
//
//  Created by Mac on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrowserViewController_iPad.h"
#import <MediaPlayer/MediaPlayer.h>

#import "EnterPasscodeViewController_iPad.h"
#import "BookmarksViewController_iPad.h"
#import "CustomTabBarController.h"

#define ALERT_VIEW_ENTER_BOOKMARK_TAG 1

@interface BrowserViewController_iPad()

@property (nonatomic) BOOL browserIsFullScreen;

- (NSString *)urlWith3wPrefix:(NSString *)url;
- (void)showServerNotFoundAlert;
- (void)showInternetConnectionOfflineAlert;
- (void)showUknownErrorAlert;
- (void)openHomePage;
- (void)disableOrEnableToolbarActions;
- (void)keyboardWasHidden:(NSNotification*)notification;
- (void)doubleTapOnBrowser;
- (void)addBrowserFullScreenFunction;
- (void)clearCookies;

@end

@implementation BrowserViewController_iPad

@synthesize browserIsFullScreen = _browserIsFullScreen;

@synthesize browserView = _browserView;
@synthesize pageNameLabel = _pageNameLabel;
@synthesize webAddressTextFieldBackgroundImage = _webAddressTextFieldBackgroundImage;
@synthesize webAddressTextField = _webAddressTextField;
@synthesize goBackButton = _goBackButton;
@synthesize goForwardButton = _goForwardButton;
@synthesize actionButton = _actionButton;
@synthesize homeButton = _homeButton;
@synthesize bookmarksButton = _bookmarksButton;
@synthesize searchStopButton = _searchStopButton;
@synthesize browser = _browser;

#pragma mark - Private methods

- (NSString *)urlWith3wPrefix:(NSString *)url;
{
    BOOL webAddressAlreadyContainsWWW = [url hasPrefix:@"www."];
    
    if (!webAddressAlreadyContainsWWW)
    {
        url = [NSString stringWithFormat:@"www.%@", url];
    }
    
    return [NSString stringWithFormat:@"http://%@/", url];;
}

- (void)showServerNotFoundAlert
{
    NSString *message = @"I'm sorry, but I cannot open the page because I cannot find the server";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!"
                                                    message:message 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)showInternetConnectionOfflineAlert
{
    if (self.view.window)
    {
        NSString *message = @"I'm sorry, but I cannot open the page because I'm not able to find   an Internet connection";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!"
                                                        message:message 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];    
    }
}

- (void)showUknownErrorAlert
{
    NSString *message = @"I'm sorry, but I encountered some trouble. Please make sure you have an Internet connection and/or enter a valid URL";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!"
                                                    message:message 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)openHomePage
{
    NSLog(@"%s", __FUNCTION__);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *stringURL = @"http://www.google.com/";
    
    if ([defaults boolForKey:@"HomePageIsModified"])
    {
        stringURL = [defaults stringForKey:@"HomePageName"];
    }
    
    [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]]];
}

- (void)disableOrEnableToolbarActions
{    
    self.goBackButton.enabled = [self.browser canGoBack] ? YES : NO;
    self.goForwardButton.enabled = [self.browser canGoForward] ? YES : NO;
    
}

- (void)keyboardWasHidden:(NSNotification*)notification
{
    NSLog(@"%s", __FUNCTION__);
    
    if (self.view.window)
    {
        self.webAddressTextFieldBackgroundImage.image = [UIImage imageNamed:@"urlField_normal"];
    }
}

- (void)doubleTapOnBrowser
{
    NSLog(@"%s", __FUNCTION__);
    
    if (self.browserIsFullScreen)
    {
        self.browserIsFullScreen = NO;
        self.browserView.hidden = NO;
        
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.browser.frame = CGRectMake(0, 60, 768, 918);
                             self.browserView.alpha = 1.0f;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else
    {
        self.browserIsFullScreen = YES;
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut 
                         animations:^{ 
                             self.browser.frame = CGRectMake(0, 0, 768, 978);
                             self.browserView.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             self.browserView.hidden = YES;
                         }];
    }
}

- (void)addBrowserFullScreenFunction
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapOnBrowser)];
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    tapGestureRecognizer.numberOfTapsRequired = 2;
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)clearCookies
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [cookieJar cookies]) 
    {
        NSLog(@"%@", cookie);
        [cookieJar deleteCookie:cookie];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) 
    {
        //        self.title = NSLocalizedString(@"Browser", @"Browser");
    }
    
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (BOOL)                            gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer 
   shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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

- (void)openURL
{
    NSLog(@"%s", __FUNCTION__);
    
    NSString *stringURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"RequestedURL"];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.browser loadRequest:urlRequest];
}

- (void)viewDidLoad
{
    //    self.browser.allowsInlineMediaPlayback = NO;
    //    self.browser.mediaPlaybackRequiresUserAction = YES;
    
    NSLog(@"self.browser.frame.size.width = %f", self.browser.frame.size.width);
    NSLog(@"self.browser.frame.size.height = %f", self.browser.frame.size.height);
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(openPasscodeViewIfNeeded) 
                                                 name:@"OpenPasscodeViewIfNeeded" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(openURL) 
                                                 name:@"URLWasRequested" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(clearCookies) 
                                                 name:@"ShouldClearCookies" 
                                               object:nil];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    [self addBrowserFullScreenFunction];
    
    //    [self.browserActionsToolBar setBackgroundImage:[UIImage imageNamed:@"tool_bar"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    self.browser.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"SaveLastVisitedPage"] == YES)
    {
        NSString *stringURL = [defaults stringForKey:@"LastVisitedPage"];
        
        [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]]];
    }
    else
    {
        [self openHomePage];
    }
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setBrowser:nil];
    [self setWebAddressTextField:nil];
    [self setGoBackButton:nil];
    [self setGoForwardButton:nil];
    [self setActionButton:nil];
    [self setPageNameLabel:nil];
    [self setWebAddressTextFieldBackgroundImage:nil];
    [self setSearchStopButton:nil];
    [self setBrowserView:nil];
    [self setHomeButton:nil];
    [self setBookmarksButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //    if ([self.browser isLoading]) 
    //    {
    //        [self.browser stopLoading];
    //    }
    //    
    //    self.browser.delegate = nil;
    //    
    //    // Disconnect the delegate as the webview is hidden
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.webAddressTextField)
    {
        [self.webAddressTextField resignFirstResponder];
        
        // Go to the specified site ...
        
        NSString *urlString = [self.webAddressTextField.text lowercaseString];
        BOOL webAddressAlreadyContainsHTTPScheme = [[urlString lowercaseString] hasPrefix:@"http://"];
        
        if (webAddressAlreadyContainsHTTPScheme) 
        {
            urlString = [urlString substringFromIndex:7];
        }
        
        urlString = [self urlWith3wPrefix:urlString];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                             timeoutInterval:10.0];
        [self.browser loadRequest:request];
    }
    
    
    // http://www.google.com/search?q=muscles
    // http://www.bing.com/search?q=muscles - not correct, not working
    // http://search.yahoo.com/search?p=muscles
    
    
    //{
    //    NSString *txt = [searchField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    //    txt = [txt stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSString *query = [[NSString alloc ]initWithFormat:@"http://www.google.com/m/search?q=-inurl√3A√28htm√7Chtml√7Cphp√29+intitle√3A√22Zippyshare.com√22√2B√28mp3√7Cwav√29+√22%@√22&pbx=1&ltoken=541b2bcf",txt];
    //    //-inurl:(htm|html|php) intitle:"Zippyshare"+(mp3) "eminem lose yourself"
    //    query = [query stringByReplacingOccurrencesOfString:@"√" withString:@"%"];
    //    //NSLog(@"%@",query);
    //    //NSString *query = [NSString stringWithFormat:@"http://www.usemeplz.com/?x=1&s=%@&x=1",txt];
    
    
    return YES;
}

#pragma mark - WebViewDelegate methods

- (BOOL)            webView:(UIWebView *)webView 
 shouldStartLoadWithRequest:(NSURLRequest *)request 
             navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%s", __FUNCTION__);
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"OpenInBrowser"] == YES)
    {
        [defaults setBool:NO forKey:@"OpenInBrowser"];
        [defaults synchronize];
        
        return YES;
    }
    //    switch (navigationType)
    //    {
    //        case UIWebViewNavigationTypeLinkClicked:
    //            NSLog(@"UIWebViewNavigationTypeLinkClicked");
    //            break;
    //
    //        case UIWebViewNavigationTypeOther:
    //            NSLog(@"UIWebViewNavigationTypeOther");
    //            break;
    //    }
    
    
    [self.browser setDataDetectorTypes:UIDataDetectorTypeLink];
    
    BOOL result = YES;
    NSURL *requestedUrl = [request URL];
    
    if ([[requestedUrl scheme] isEqualToString:@"http"]) 
    {
        NSArray *supportedFormats = [[NSArray alloc] initWithObjects: 
                                     
                                     // Audio formats
                                     @"aac",
                                     @"aif",
                                     @"aiff",
                                     @"caf",
                                     @"mp3",
                                     @"m4a",
                                     @"m4r", // ? not sure
                                     @"wav", 
                                     
                                     // Video formats
                                     @"mp4",
                                     @"mov",
                                     @"m4v",
                                     @"mpv",
                                     @"3gp",
                                     
                                     // Image formats
                                     // http://developer.apple.com/library/ios/#documentation/2ddrawing/conceptual/drawingprintingios/HandlingImages/Images.html
                                     @"gif",
                                     @"jpeg",
                                     @"jpg",
                                     @"tif",
                                     @"tiff",
                                     @"ico",
                                     @"bmp",
                                     
                                     // Archive formats
                                     @"rar",
                                     @"zip",
                                     
                                     // Text and other file formats
                                     @"pdf",
                                     @"doc",
                                     @"xls",
                                     @"ppt",
                                     @"txt",
                                     //                                                    @"html",
                                     @"rtf",
                                     @"webarchive",
                                     nil];
        
        NSString *format = [[requestedUrl absoluteString] pathExtension];
        
        //        http://storage-new.newjamendo.com/download/track/310389/mp32/Birds_of_Tokyo_-_Birds_of_Tokyo_-_Wild_Eyed_Boy.mp3
        
        //        NSLog(@"format = %@", format);
        //        
        //        if ([format isEqualToString:@""])
        //        {
        //            NSString *downloadLink = [requestedUrl absoluteString];
        //            NSLog(@"downloadLink = %@", downloadLink);
        //            
        //            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadLink] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
        //            NSHTTPURLResponse* response = nil;
        //            NSError* error = nil;
        //            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        //            NSLog(@"statusCode = %d", [response statusCode]);
        //            NSLog(@"response = %@", [response allHeaderFields]);
        //
        //            
        //            return YES;
        //        }
        
        if ([supportedFormats containsObject:format]) 
        {
            result = NO;
            
            NSString *downloadLink = [requestedUrl absoluteString];
            NSLog(@"downloadLink = %@", downloadLink);
            
            [[NSUserDefaults standardUserDefaults] setObject:downloadLink forKey:@"DownloadLink"];
            
            NSString *msg = [NSString stringWithFormat:@"What do you want to do with %@ file ?", [[[requestedUrl absoluteString] lastPathComponent] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!" 
                                                            message:msg 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Open in browser" 
                                                  otherButtonTitles:@"Download", nil];
            [alert show];
        }
    }
    
    return result; 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s", __FUNCTION__);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (alertView.tag == ALERT_VIEW_ENTER_BOOKMARK_TAG)
    {
        if (buttonIndex == 1)
        {
            NSMutableDictionary *bookmarkNames = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:@"BookmarkNames"]];
            
            //    if (bookmarkNames == nil) {
            //        bookmarkNames = [NSMutableDictionary dictionary];
            //    }
            
            NSLog(@"[alertView textFieldAtIndex:0].text = %@", [alertView textFieldAtIndex:0].text);
            
            NSString *bookmarkURL = (![self.webAddressTextField.text isEqualToString:@""]) ? self.webAddressTextField.text : self.browser.request.URL.absoluteURL.absoluteString;
            NSString *bookmarkName = [alertView textFieldAtIndex:0].text;
            
            if ([bookmarkName isEqualToString:@""])
            {
                bookmarkName = bookmarkURL;
                [alertView textFieldAtIndex:0].text = bookmarkName;
            }
            
            [bookmarkNames setObject:bookmarkURL
                              forKey:bookmarkName];
            
            [defaults setObject:bookmarkNames forKey:@"BookmarkNames"];
            [defaults synchronize];
        }
    }
    else
    {
        NSString *downloadLink = [defaults stringForKey:@"DownloadLink"];
        
        if (buttonIndex == 0)
        {
            // Open in browser
            [defaults setBool:YES forKey:@"OpenInBrowser"];
            [defaults synchronize];
            
            [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:downloadLink]]];
            //        NSString *urlStr = [NSURL URLWithString:downloadLink];
            //        NSURL *url = [NSURL URLWithString:urlStr];
            //        MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
            //        moviePlayer.view.frame = CGRectMake(0, 0, 300, 400);  
            //        [self.view addSubview:moviePlayer.view];
            //        [moviePlayer play];
        }
        else
        {
            // Download

            [[NSNotificationCenter defaultCenter] postNotificationName:@"StartNewDownload" object:nil];
            self.tabBarController.selectedIndex = 1;
            ((CustomTabBarController *)self.tabBarController).tabbarBackgrowndImage.image = [UIImage imageNamed:@"downloads_selected"];
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"self.browser.request.URL.absoluteURL.absoluteString = %@", self.browser.request.URL.absoluteURL.absoluteString);
    
    // Starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.searchStopButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"SaveLastVisitedPage"] == YES)
    {
        [defaults setObject:self.browser.request.URL.absoluteURL.absoluteString
                     forKey:@"LastVisitedPage"];
        [defaults synchronize];
    }
    
    // Finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.searchStopButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self disableOrEnableToolbarActions];
    
    self.pageNameLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.webAddressTextField.text = self.browser.request.URL.absoluteURL.absoluteString;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    
    // Load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.searchStopButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self disableOrEnableToolbarActions];
    
    switch (error.code)
    {
        case -1003:
            [self showServerNotFoundAlert];
            break;
            
        case 101:
        case -1009:
            [self showInternetConnectionOfflineAlert];
            break;
            
            //        default:
            //            [self showUknownErrorAlert];
            break;
    }
}

- (IBAction)onGoBackButtonTap:(id)sender 
{
    NSLog(@"%s", __FUNCTION__);
    
    if ([self.browser canGoBack])
    {
        [self.browser goBack];
    }
}

- (IBAction)onGoForwardButtonTap:(id)sender 
{
    NSLog(@"%s", __FUNCTION__);
    
    if ([self.browser canGoForward])
    {
        [self.browser goForward];
    }
}

- (IBAction)onActionButtonTap:(id)sender 
{
    NSLog(@"%s", __FUNCTION__);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Bookmark", @"Set As Home page", @"Reload Page", nil];
    
    //    [actionSheet showFromToolbar:self.browserActionsToolBar];
    //    [actionSheet showInView:self.view];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s", __FUNCTION__);
    
    NSString *pageName = (![self.webAddressTextField.text isEqualToString:@""]) ? self.webAddressTextField.text : self.browser.request.URL.absoluteURL.absoluteString;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    switch (buttonIndex)
    {
        case 0:
            // Add to Bookmarks
            if ([self.webAddressTextField.text isEqualToString:@""] &&
                self.browser.request.URL.absoluteString == nil)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!"
                                                                message:@"Seems like I am not able to find any url address for the current page"
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
            else 
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!\n Please enter below a suggestive short name for bookmark"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Add", nil];
                
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                //                [alert textFieldAtIndex:0].text = (![self.webAddressTextField.text isEqualToString:@""]) ? self.webAddressTextField.text : self.browser.request.URL.absoluteURL.absoluteString;
                [alert textFieldAtIndex:0].placeholder = pageName;
                
                alert.tag = ALERT_VIEW_ENTER_BOOKMARK_TAG;
                [alert show];
            }
            
            break;
            
        case 1:
            // Set as Home Page
            
            [defaults setBool:YES forKey:@"HomePageIsModified"];
            [defaults setObject:pageName forKey:@"HomePageName"];
            [defaults synchronize];
            
            break;
            
        case 2:
            // Reload Page
            
            if ([self.browser isLoading])
            {
                [self.browser stopLoading];
            }
            
            NSLog(@"index = %d", buttonIndex);
            
            [self.browser reload];
            
            break;
            
        default:
            break;
    }
}

- (IBAction)onBookmarksButtonTap:(id)sender 
{
    NSLog(@"%s", __FUNCTION__);
        
    BookmarksViewController_iPad *bookmarksViewController_iPad = [[BookmarksViewController_iPad alloc] initWithNibName:@"BookmarksViewController_iPad" bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:bookmarksViewController_iPad];
    
    [self.navigationController presentModalViewController:nc animated:YES];
}

- (IBAction)onHomeButtonTap:(id)sender 
{
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"self.browser = %@", self.browser);
    
    if (!self.browser)
    {
        NSLog(@"browser is nill");
    }
    
    [self openHomePage];    
}

- (IBAction)urlFieldDidBeginEditing:(id)sender 
{
    NSLog(@"%s", __FUNCTION__);
    
    self.webAddressTextFieldBackgroundImage.image = [UIImage imageNamed:@"urlField_selected"];
}

- (IBAction)onSearchStopButtonTap:(id)sender 
{
    NSLog(@"%s", __FUNCTION__);
    
    if ([self.browser isLoading])
    {
        [self.browser stopLoading];
        [self.searchStopButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    }
    else
    {
        NSString *encodedString = [[NSString stringWithFormat:@"http://www.google.com/search?q=%@", self.webAddressTextField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:encodedString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                             timeoutInterval:10.0];
        [self.browser loadRequest:request]; 
        
        [self.webAddressTextField resignFirstResponder];
    }
}

//NSString *tegos = @"http://tegos.ru/";
//NSString *play = @"http://play.md";
//NSString *redtube = @"http://redtube.com";
//NSString *pornhub = @"http://pornhub.com";
//NSString *metacafe = @"http://metacafe.com";
//NSString *roxwel = @"http://roxwel.com/";
//NSString *voeh = @"http://www.veoh.com/";
//NSString *dailymotion = @"http://www.dailymotion.com/ru";
//NSString *vimeo = @"http://vimeo.com/";
//NSString *rutube = @"http://rutube.ru/";
//NSString *com56 = @"http://www.56.com";
//NSString *youku = @"http://3g.youku.com/";
//NSString *blastro = @"http://www.blastro.com/";
//NSString *yallwire = @"http://www.yallwire.com/";
//NSString *worldstarhiphop = @"http://www.worldstarhiphop.com/";
//NSString *breakSite = @"http://www.break.com/";
//NSString *trutv = @"http://www.trutv.com/index.html";
//NSString *videobash = @"http://www.videobash.com/";
//NSString *collegehumor = @"http://www.collegehumor.com/";
//NSString *funnyyordie = @"http://www.funnyordie.com/";
//NSString *funnycrazyclips = @"http://www.funnycrazyclips.com/";
//NSString *viduu = @"http://www.viduu.com/";
//NSString *chronictv = @"http://chronictv.org/";
//NSString *bollywoodmp4 = @"http://www.bollywoodmp4.com/";
//NSString *anime4iphone = @"http://anime4iphone.com/";
//NSString *realitylapse = @"http://m.realitylapse.com/#/";
//NSString *iphoneanime = @"http://iphoneanime.net/";
//[webView loadHTMLString:[NSString stringWithFormat:@"<html><body bgcolor=white><div><a href='%@'>Tegos</a></div><div><a href='%@'>Play</a></div><div><a href='%@'>RedTube</a></div><div><a href='%@'>PornHub</a></div><div><a href='%@'>MetaCafe</a></div><div><a href='%@'>Roxwel</a></div><div><a href='%@'> Voeh </a></div><div><a href='%@'> Dailymotion </a></div><div><a href='%@'> Vimeo </a></div><div><a href='%@'> Rutube </a></div><div><a href='%@'> 56 </a></div><div><a href='%@'> Youku </a></div><div><a href='%@'> Blastro </a></div><div><a href='%@'> Yallwire </a></div><div><a href='%@'> Worldstarhiphop </a></div><div><a href='%@'> Break </a></div><div><a href='%@'> TruTV </a></div><div><a href='%@'> VideoBash </a></div><div><a href='%@'> College Humor </a></div><div><a href='%@'> Funny Yordie </a></div><div><a href='%@'> Funny Crazy Clips </a></div><div><a href='%@'> Viduu </a></div><div><a href='%@'> ChronicTV </a></div><div><a href='%@'> Bollywood MP4 </a></div><div><a href='%@'> Anime4iPhone </a></div><div><a href='%@'> Reality Kapse </a></div><div><a href='%@'> iPhone Anime </a></div></body></html>",tegos,play,redtube,pornhub,metacafe,roxwel,voeh,dailymotion,vimeo,rutube,com56,youku,blastro,yallwire,worldstarhiphop,breakSite,trutv,videobash,collegehumor,funnyyordie,funnycrazyclips,viduu,chronictv,bollywoodmp4,anime4iphone,realitylapse,iphoneanime] baseURL:nil];


@end
