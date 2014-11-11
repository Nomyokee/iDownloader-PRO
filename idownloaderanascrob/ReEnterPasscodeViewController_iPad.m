//
//  EnterPasscodeViewController_iPad.m
//  iDownloadAllPro
//
//  Created by Mac on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReEnterPasscodeViewController_iPad.h"


@interface ReEnterPasscodeViewController_iPad()

@property (nonatomic, retain) NSString *passcode;

@end


@implementation ReEnterPasscodeViewController_iPad

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
    
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString *firstPasscode = [defaults stringForKey:@"FirstPasscode"];    
    
    if ([firstPasscode isEqualToString:self.passcode])
    {
        [defaults setObject:self.passcode forKey:@"Passcode"];
        [defaults setBool:YES forKey:@"PasscodeLock"];
        [defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"PasswordWasSetOrReset"                                                                                                                                    
         object:nil];
    }
    else if (![self.passcode isEqualToString:@""])
    {
        self.passcodeTextField.text = @"";
        self.passcode = @"";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!"
                                                        message:@"Seems like the two PASSCODES do not match! Please try again!" 
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
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