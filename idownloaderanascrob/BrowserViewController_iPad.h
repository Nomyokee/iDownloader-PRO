//
//  BrowserViewController_iPad.h
//  iDownloadAllPro
//
//  Created by Mac on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController_iPad : UIViewController <UITextFieldDelegate, UIWebViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIView *browserView;
@property (weak, nonatomic) IBOutlet UILabel *pageNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *webAddressTextFieldBackgroundImage;
@property (weak, nonatomic) IBOutlet UITextField *webAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *goBackButton;
@property (weak, nonatomic) IBOutlet UIButton *goForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *bookmarksButton;


@property (weak, nonatomic) IBOutlet UIButton *searchStopButton;
@property (weak, nonatomic) IBOutlet UIWebView *browser;


- (IBAction)onGoBackButtonTap:(id)sender;
- (IBAction)onGoForwardButtonTap:(id)sender;
- (IBAction)onActionButtonTap:(id)sender;
- (IBAction)onHomeButtonTap:(id)sender;
- (IBAction)onBookmarksButtonTap:(id)sender;


- (IBAction)urlFieldDidBeginEditing:(id)sender;
- (IBAction)onSearchStopButtonTap:(id)sender;


@end
