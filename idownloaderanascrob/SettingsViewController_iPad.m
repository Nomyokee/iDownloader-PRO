//
//  SettingsViewController_iPad.m
//  iDownloadAllPro
//
//  Created by Mac on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController_iPad.h"
#import "EnterPasscodeViewController_iPad.h"

@implementation SettingsViewController_iPad

@synthesize passcodeLockSwitch = _passcodeLockSwitch;
@synthesize saveLastVisitedPageSwitch = _saveLastVisitedPageSwitch;
@synthesize clearFinishedDownloadsSwitch = _clearFinishedDownloadsSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) 
    {
        self.title = NSLocalizedString(@"Settings", @"Settings");
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)removeModalNavigationController
{
    NSLog(@"%s", __FUNCTION__);
    
    passcodeLock = [[NSUserDefaults standardUserDefaults] boolForKey:@"PasscodeLock"];
    
    [self dismissModalViewControllerAnimated:YES];
    
    if (passcodeLock)
    {
        [self.passcodeLockSwitch setImage:[UIImage imageNamed:@"button_switch_on"] forState:UIControlStateNormal];
    }
    else
    {
        [self.passcodeLockSwitch setImage:[UIImage imageNamed:@"button_switch_off"] forState:UIControlStateNormal];
    }
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    passcodeLock = [defaults boolForKey:@"PasscodeLock"];
    saveLastVisitedPage = [defaults boolForKey:@"SaveLastVisitedPage"];
    clearFinishedDownloads = [defaults boolForKey:@"ClearFinishedDownloads"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(openPasscodeViewIfNeeded) 
                                                 name:@"OpenPasscodeViewIfNeeded" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeModalNavigationController) 
                                                 name:@"PasswordWasSetOrReset" 
                                               object:nil];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    NSInteger numberOfSimultaneousDownloads = [defaults integerForKey:@"SimultaneousDownloads"];
    
    ((UIImageView *)[self.view viewWithTag:10]).center = CGPointMake(128 + 64 * (numberOfSimultaneousDownloads - 1), 880);
    
    if (passcodeLock)
    {
        [self.passcodeLockSwitch setImage:[UIImage imageNamed:@"button_switch_on"] forState:UIControlStateNormal];
    }
    else
    {
        [self.passcodeLockSwitch setImage:[UIImage imageNamed:@"button_switch_off"] forState:UIControlStateNormal];
    }
    
    if (saveLastVisitedPage)
    {
        [self.saveLastVisitedPageSwitch setImage:[UIImage imageNamed:@"button_switch_on"] forState:UIControlStateNormal];
    }
    else
    {
        [self.saveLastVisitedPageSwitch setImage:[UIImage imageNamed:@"button_switch_off"] forState:UIControlStateNormal];
    }
    
    if (clearFinishedDownloads)
    {
        [self.clearFinishedDownloadsSwitch setImage:[UIImage imageNamed:@"button_switch_on"] forState:UIControlStateNormal];
    }
    else
    {
        [self.clearFinishedDownloadsSwitch setImage:[UIImage imageNamed:@"button_switch_off"] forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload
{
    [self setPasscodeLockSwitch:nil];
    [self setSaveLastVisitedPageSwitch:nil];
    [self setClearFinishedDownloadsSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onDownloadsNumberTap:(UIButton *)sender 
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"Button TAG = %d", sender.tag);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:sender.tag forKey:@"SimultaneousDownloads"];
    [defaults synchronize];
    
    ((UIImageView *)[self.view viewWithTag:10]).center = CGPointMake(128 + 64 * (sender.tag - 1), 880);
}

- (IBAction)onPasscodeLockSwitchTap:(id)sender 
{
    NSLog(@"%s", __FUNCTION__);
    
    EnterPasscodeViewController_iPad *epvc = [[EnterPasscodeViewController_iPad alloc] initWithNibName:@"EnterPasscodeViewController_iPad" bundle:nil];
    epvc.isComingFromSettingsTab = YES;
    
    UINavigationController *newNavController = [[UINavigationController alloc] initWithRootViewController:epvc];
    
    newNavController.navigationBarHidden = YES;
    [self.navigationController presentModalViewController:newNavController animated:YES];
}

- (IBAction)onSaveLastVisitedPageSwitchTap:(id)sender 
{
    NSLog(@"%s", __FUNCTION__);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    saveLastVisitedPage = !saveLastVisitedPage;
    
    if (saveLastVisitedPage)
    {
        [defaults setBool:YES forKey:@"SaveLastVisitedPage"];
        [defaults synchronize];
        
        [self.saveLastVisitedPageSwitch setImage:[UIImage imageNamed:@"button_switch_on"] forState:UIControlStateNormal];
    }
    else
    {
        [defaults setBool:NO forKey:@"SaveLastVisitedPage"];
        [defaults synchronize];
        
        [self.saveLastVisitedPageSwitch setImage:[UIImage imageNamed:@"button_switch_off"] forState:UIControlStateNormal];
    }
}

- (IBAction)onClearFinishedDownloadsSwitchTap:(id)sender 
{
    NSLog(@"%s", __FUNCTION__);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    clearFinishedDownloads = !clearFinishedDownloads;
    
    if (clearFinishedDownloads)
    {
        [defaults setBool:YES forKey:@"ClearFinishedDownloads"];
        [defaults synchronize];
        
        [self.clearFinishedDownloadsSwitch setImage:[UIImage imageNamed:@"button_switch_on"] forState:UIControlStateNormal];
    }
    else
    {
        [defaults setBool:NO forKey:@"ClearFinishedDownloads"];
        [defaults synchronize];
        
        [self.clearFinishedDownloadsSwitch setImage:[UIImage imageNamed:@"button_switch_off"] forState:UIControlStateNormal];
    }
}

- (IBAction)onClearCookiesButtonTap:(id)sender 
{
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!"
                                                    message:@"Do you really want me to delete my Browser's Cookies?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Sure", nil];
    alert.tag = 11;
    [alert show];
}

- (IBAction)onResetHomePageTap:(id)sender 
{
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey, BOSS!!!"
                                                    message:@"Do you really want me to reset my Browser's Home Page?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Sure", nil];
    alert.tag = 12;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11)
    {
        if (buttonIndex == 1)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShouldClearCookies"
                                                                object:nil
                                                              userInfo:nil];        
        }
    }
    else if (alertView.tag == 12)
    {
        if (buttonIndex == 1)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setBool:NO forKey:@"HomePageIsModified"];
            [defaults setObject:@"http://www.google.com/" forKey:@"HomePageName"];
            [defaults synchronize];
        }
    }
}

@end