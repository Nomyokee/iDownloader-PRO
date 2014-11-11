//
//  CustomUITabBarController.m
//  FreeMusicDownloader
//
//  Created by Pavel Pavlusha on 2/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBarController.h"


@interface CustomTabBarController()

- (void)hideTabBar;

- (void)menuButtonPressed:(id)sender;
- (void)initFramesForiPhoneScreen;
- (void)initFramesForiPhone5Screen;
- (void)initFramesForiPadScreen;

@end


@implementation CustomTabBarController

@synthesize tabbarBackgrowndImage = _tabbarBackgrowndImage;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
    self.tabbarBackgrowndImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"browser_selected"]];
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        self.tabbarBackgrowndImage.frame = CGRectMake(0, 975, 768, 49);
//    }
//    else
//    {
//        self.tabbarBackgrowndImage.frame = CGRectMake(0, 431, 320, 49);
//    }
    
    if (IS_IPAD)
    {
        self.tabbarBackgrowndImage.frame = CGRectMake(0, 975, 768, 49);
    }
    else if (IS_IPHONE_5)
    {
        self.tabbarBackgrowndImage.frame = CGRectMake(0, 519, 320, 49);
    }
    else
    {
        self.tabbarBackgrowndImage.frame = CGRectMake(0, 431, 320, 49);
    }
    
    buttonBrowser   = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonDownloads = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonFiles     = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSettings  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonBrowser addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    buttonBrowser.tag = 0;

    [buttonDownloads addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    buttonDownloads.tag = 1;
    
    [buttonFiles addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    buttonFiles.tag = 2;
    
    [buttonSettings addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];        
    buttonSettings.tag = 3;
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        [self initFramesForiPadScreen];
//    }
//    else
//    {
//        [self initFramesForiPhoneScreen];
//    }
    
    if (IS_IPAD)
    {
        [self initFramesForiPadScreen];
    }
    else if (IS_IPHONE_5)
    {
        [self initFramesForiPhone5Screen];
    }
    else
    {
        [self initFramesForiPhoneScreen];
    }

    [self.view addSubview:self.tabbarBackgrowndImage];
    
    [self.view addSubview:buttonBrowser];
    [self.view addSubview:buttonDownloads];
    [self.view addSubview:buttonFiles];
    [self.view addSubview:buttonSettings];
    
//    self.selectedIndex = 1;
}

- (void)hideTabBar
{
	for (UIView *view in self.view.subviews)
	{
		if ([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

- (void)menuButtonPressed:(id)sender 
{
	NSLog(@"%s", __FUNCTION__);
    
	Byte buttonTag = ((UIButton *)sender).tag;	
    
    [self setHighlightedButtonImageAtIndex:buttonTag];

    NSLog(@"buttonTag = %d", buttonTag);
}

- (void)initFramesForiPhoneScreen
{
    buttonBrowser.frame = CGRectMake(0, 431, 80, 49);
    buttonDownloads.frame = CGRectMake(80, 431, 80, 49);
    buttonFiles.frame = CGRectMake(160, 431, 80, 49);
    buttonSettings.frame = CGRectMake(240, 431, 80, 49);
}

- (void)initFramesForiPhone5Screen
{
    buttonBrowser.frame = CGRectMake(0, 519, 80, 49);
    buttonDownloads.frame = CGRectMake(80, 519, 80, 49);
    buttonFiles.frame = CGRectMake(160, 519, 80, 49);
    buttonSettings.frame = CGRectMake(240, 519, 80, 49);
}


- (void)initFramesForiPadScreen
{
    buttonBrowser.frame = CGRectMake(0, 975, 192, 49);
    buttonDownloads.frame = CGRectMake(192, 975, 192, 49);
    buttonFiles.frame = CGRectMake(384, 975, 192, 49);
    buttonSettings.frame = CGRectMake(576, 975, 192, 49); 
}

- (void)setHighlightedButtonImageAtIndex:(Byte)index 
{
    switch (index) 
    {
        case 0:      
            // onButtonBrowserClick
            self.tabbarBackgrowndImage.image = [UIImage imageNamed:@"browser_selected"];
            break;
            
        case 1:
            // onButtonDownloadsClick
            self.tabbarBackgrowndImage.image = [UIImage imageNamed:@"downloads_selected"];
            break;
            
        case 2:
            // onButtonFilesClick
            self.tabbarBackgrowndImage.image = [UIImage imageNamed:@"files_selected"];
            break;
            
        case 3:
            // onButtonSettingsClick
            self.tabbarBackgrowndImage.image = [UIImage imageNamed:@"settings_selected"];
            break;
            
        default:
            break;
    }
    
    self.selectedIndex = index;
}

- (void)dealloc
{
}

@end
