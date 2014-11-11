//
//  AppDelegate.m
//  iDownloadAllPro
//
//  Created by Mac on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "BrowserViewController_iPhone.h"
#import "DownloadsViewController_iPhone.h"
#import "FilesViewController_iPhone.h"
#import "SettingsViewController_iPhone.h"

#import "BrowserViewController_iPad.h"
#import "DownloadsViewController_iPad.h"
#import "FilesViewController_iPad.h"
#import "SettingsViewController_iPad.h"

#import "CustomTabBarController.h"
#import "EnterPasscodeViewController_iPhone.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize customTabBarController = _customTabBarController;

- (NSString *)iDeviceType
{
    NSString *iDeviceType = @"iPhone";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_5)
        {
            iDeviceType = @"iPhone5";
        }
        else //if (IS_IPHONE)
        {
            iDeviceType = @"iPhone";
        }
    }
    else
    {
        iDeviceType = @"iPad";
    }
    
    return iDeviceType;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults integerForKey:@"SimultaneousDownloads"] == 0)
    {
        [defaults setInteger:5 forKey:@"SimultaneousDownloads"];
    }
    
    [defaults synchronize];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    UIViewController *browserViewController;
    UIViewController *downloadsViewController;
    UIViewController *filesViewController;
    UIViewController *settingsViewController;
    
//    NSString *iDeviceType = [self iDeviceType];
//    
//    browserViewController = [[BrowserViewController_iPhone alloc] initWithNibName:[NSString stringWithFormat:@"BrowserViewController_%@", iDeviceType] bundle:nil];
//    downloadsViewController = [[DownloadsViewController_iPhone alloc] initWithNibName:[NSString stringWithFormat:@"DownloadsViewController_%@", iDeviceType] bundle:nil];
//    filesViewController = [[FilesViewController_iPhone alloc] initWithNibName:[NSString stringWithFormat:@"FilesViewController_%@", iDeviceType] bundle:nil];
//    settingsViewController = [[SettingsViewController_iPhone alloc] initWithNibName:[NSString stringWithFormat:@"SettingsViewController_%@", iDeviceType] bundle:nil];
    
    
    NSLog(@"[[UIScreen mainScreen] bounds].size.height = %f", [[UIScreen mainScreen] bounds].size.height);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_5)
        {
            NSLog(@"IS_IPHONE_5");
            browserViewController = [[BrowserViewController_iPhone alloc] initWithNibName:@"BrowserViewController_iPhone5" bundle:nil];
            downloadsViewController = [[DownloadsViewController_iPhone alloc] initWithNibName:@"DownloadsViewController_iPhone5" bundle:nil];
            filesViewController = [[FilesViewController_iPhone alloc] initWithNibName:@"FilesViewController_iPhone5" bundle:nil];
            settingsViewController = [[SettingsViewController_iPhone alloc] initWithNibName:@"SettingsViewController_iPhone5" bundle:nil];
        }
        else
        {
            NSLog(@"IS_IPHONE");
            browserViewController = [[BrowserViewController_iPhone alloc] initWithNibName:@"BrowserViewController_iPhone" bundle:nil];
            downloadsViewController = [[DownloadsViewController_iPhone alloc] initWithNibName:@"DownloadsViewController_iPhone" bundle:nil];
            filesViewController = [[FilesViewController_iPhone alloc] initWithNibName:@"FilesViewController_iPhone" bundle:nil];
            settingsViewController = [[SettingsViewController_iPhone alloc] initWithNibName:@"SettingsViewController_iPhone" bundle:nil];
        }
    }
    else
    {
        browserViewController = [[BrowserViewController_iPad alloc] initWithNibName:@"BrowserViewController_iPad" bundle:nil];
        downloadsViewController = [[DownloadsViewController_iPad alloc] initWithNibName:@"DownloadsViewController_iPad" bundle:nil];
        filesViewController = [[FilesViewController_iPad alloc] initWithNibName:@"FilesViewController_iPad" bundle:nil];
        settingsViewController = [[SettingsViewController_iPad alloc] initWithNibName:@"SettingsViewController_iPad" bundle:nil]; 
    }
    
    // Add the navigation controller's view to the window and display.
    
    UINavigationController *browserNavigationController = [[UINavigationController alloc] initWithRootViewController:browserViewController];
    browserNavigationController.navigationBarHidden = YES;    

    UINavigationController *downloadsNavigationController = [[UINavigationController alloc] initWithRootViewController:downloadsViewController];
    downloadsNavigationController.navigationBarHidden = YES;    

    UINavigationController *filesNavigationController = [[UINavigationController alloc] initWithRootViewController:filesViewController];
    filesNavigationController.navigationBarHidden = YES;    

    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    settingsNavigationController.navigationBarHidden = YES;    

    self.customTabBarController = [[CustomTabBarController alloc] init];
    self.customTabBarController.viewControllers = [NSArray arrayWithObjects:browserNavigationController, downloadsNavigationController, filesNavigationController, settingsNavigationController, nil];
    
//    [self.customTabBarController setSelectedIndex:1];
//    [self.customTabBarController setSelectedIndex:0];

    self.window.rootViewController = self.customTabBarController;
    [self.window makeKeyAndVisible];
            
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenPasscodeViewIfNeeded"
                                                        object:nil
                                                      userInfo:nil];        
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenPasscodeViewIfNeeded"
                                                        object:nil
                                                      userInfo:nil];        
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end