//
//  EnterPasscodeViewController.m
//  iDownloadAllPro
//
//  Created by Mac on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnterPasscodeViewController_iPhone.h"
#import "ReEnterPasscodeViewController_iPhone.h"

@interface EnterPasscodeViewController_iPhone()

@property (nonatomic, retain) NSString *passcode;

@end



@implementation EnterPasscodeViewController_iPhone

@synthesize passcode = _passcode;
@synthesize passcodeTextField = _passcodeTextField;
@synthesize isComingFromSettingsTab = _isComingFromSettingsTab;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    if (!self.isComingFromSettingsTab)
    {
        [self.view viewWithTag:100].hidden = YES;
    }
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.passcode = @"";
    self.passcodeTextField.userInteractionEnabled = NO;
}

- (void)viewDidUnload
{
    [self setPasscodeTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onBackButtonTap 
{
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"self.passcode = %@", self.passcode);
    
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)onDigitButtonTap:(UIButton *)sender 
{
    NSLog(@"%s", __FUNCTION__);
    
    if (self.passcodeTextField.text.length < 10)
    {
        self.passcode = [self.passcode stringByAppendingString:[NSString stringWithFormat:@"%c", '0' + sender.tag]];
//        self.passcodeTextField.text = [self.passcodeTextField.text stringByAppendingString:@"*"];        
        self.passcodeTextField.text = [self.passcodeTextField.text stringByAppendingString:@"•"];        
    }
}

- (IBAction)onDeleteButtonTap
{
    NSLog(@"%s", __FUNCTION__);

    NSUInteger passcodeLenth = self.passcodeTextField.text.length;
    
    if (passcodeLenth > 0)
    {
        self.passcode = [self.passcode substringToIndex:passcodeLenth - 1];
        self.passcodeTextField.text = [self.passcodeTextField.text substringToIndex:passcodeLenth - 1];
    }

}

- (IBAction)onOkButtonTap
{
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"self.passcode = %@", self.passcode);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!self.isComingFromSettingsTab)
    {
        NSString *passcode = [defaults stringForKey:@"Passcode"];
        
        if ([self.passcode isEqualToString:passcode])
        {
            [self.presentingViewController dismissModalViewControllerAnimated:YES];
        }
        else if ([self.passcode isEqualToString:@""])
        {
            self.passcode = @"";
            self.passcodeTextField.text = @"";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!"
                                                            message:@"You have to type in a non empty PASSCODE"
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            self.passcode = @"";
            self.passcodeTextField.text = @"";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!"
                                                            message:@"Seems like you mistyped or forgot you PASSCODE! Please try again"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if (![self.passcode isEqualToString:@""])
    {
        NSLog(@"[defaults stringForKey:Passcode] = %@", [defaults stringForKey:@"Passcode"]);

        NSString *passcode = [defaults stringForKey:@"Passcode"];
        
        if (passcode == nil)
        {
            // There is no PASSCODE
            
            [defaults setObject:self.passcode forKey:@"FirstPasscode"];
            [defaults synchronize];
            
            ReEnterPasscodeViewController_iPhone *repvc = [[ReEnterPasscodeViewController_iPhone alloc] initWithNibName:@"ReEnterPasscodeViewController_iPhone" bundle:nil];
            
            [self.navigationController pushViewController:repvc animated:YES];
        }
        else
        {            
            if ([self.passcode isEqualToString:passcode])
            {
                [defaults setObject:nil forKey:@"Passcode"];
                [defaults setBool:NO forKey:@"PasscodeLock"];
                [defaults synchronize];
                
                [[NSNotificationCenter defaultCenter] 
                     postNotificationName:@"PasswordWasSetOrReset"                                                                                                                                    
                                   object:nil];
            }
            else if (![self.passcode isEqualToString:passcode])
            {
                self.passcode = @"";
                self.passcodeTextField.text = @"";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!"
                                                                message:@"Seems like you mistyped or forgot your PASSCODE! Please try again!"
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else if ([self.passcode isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!"
                                                        message:@"You have to type in a non empty PASSCODE"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
