//
//  BrowserViewController_iPhone.h
//  iDownloadAllPro
//
//  Created by Mac on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController_iPhone : UIViewController <UITextFieldDelegate, UIWebViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, NSURLConnectionDelegate>
{
    BOOL mymeTypeWasChecked;
    BOOL isFile;
    NSString *downloadLink;
}

@property (weak, nonatomic) IBOutlet UIView *browserView;
@property (weak, nonatomic) IBOutlet UILabel *pageNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *webAddressTextFieldBackgroundImage;
@property (weak, nonatomic) IBOutlet UITextField *webAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchStopButton;
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (weak, nonatomic) IBOutlet UIToolbar *browserActionsToolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bookmarksButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeButton;

- (IBAction)onGoBackButtonTap:(id)sender;
- (IBAction)onGoForwardButtonTap:(id)sender;
- (IBAction)onActionButtonTap:(id)sender;
- (IBAction)onBookmarksButtonTap:(id)sender;
- (IBAction)onHomeButtonTap:(id)sender;

- (IBAction)urlFieldDidBeginEditing:(id)sender;
- (IBAction)onSearchStopButtonTap:(id)sender;

@end
