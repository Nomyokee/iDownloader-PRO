//
//  EnterPasscodeViewController.h
//  iDownloadAllPro
//
//  Created by Mac on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReEnterPasscodeViewController_iPhone : UIViewController
{
    
}

@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (nonatomic) BOOL isComingFromSettingsTab;

- (IBAction)onBackButtonTap;

- (IBAction)onDigitButtonTap:(id)sender;
- (IBAction)onDeleteButtonTap;
- (IBAction)onOkButtonTap;

@end
