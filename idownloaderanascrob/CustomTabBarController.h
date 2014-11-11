//
//  CustomUITabBarController.h
//  FreeMusicDownloader
//
//  Created by Pavel Pavlusha on 2/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomTabBarController : UITabBarController 
{
    UIButton *buttonBrowser;
    UIButton *buttonDownloads;
    UIButton *buttonFiles;
    UIButton *buttonSettings;
}

@property (nonatomic, retain) UIImageView *tabbarBackgrowndImage;;

- (void)setHighlightedButtonImageAtIndex:(Byte)index;

@end
