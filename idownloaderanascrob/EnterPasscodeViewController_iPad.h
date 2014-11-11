//
//  EnterPasscodeViewController_iPad.h
//  iDownloadAllPro
//
//  Created by Mac on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterPasscodeViewController_iPad : UIViewController
{
    
}

@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (nonatomic) BOOL isComingFromSettingsTab;

- (IBAction)onBackButtonTap;

- (IBAction)onDigitButtonTap:(id)sender;
- (IBAction)onDeleteButtonTap;
- (IBAction)onOkButtonTap;

@end
