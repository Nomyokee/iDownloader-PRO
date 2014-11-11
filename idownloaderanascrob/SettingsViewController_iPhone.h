//
//  SettingsViewController_iPhone.h
//  iDownloadAllPro
//
//  Created by Mac on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController_iPhone : UIViewController <UIAlertViewDelegate>
{
    BOOL passcodeLock;
    BOOL saveLastVisitedPage;
    BOOL clearFinishedDownloads;
}

@property (weak, nonatomic) IBOutlet UIButton *passcodeLockSwitch;
@property (weak, nonatomic) IBOutlet UIButton *saveLastVisitedPageSwitch;
@property (weak, nonatomic) IBOutlet UIButton *clearFinishedDownloadsSwitch;

- (IBAction)onPasscodeLockSwitchTap:(id)sender;
- (IBAction)onSaveLastVisitedPageSwitchTap:(id)sender;
- (IBAction)onClearFinishedDownloadsSwitchTap:(id)sender;


- (IBAction)onClearCookiesButtonTap:(id)sender;
- (IBAction)onResetHomePageTap:(id)sender;

- (IBAction)onDownloadsNumberTap:(UIButton *)sender;

@end
