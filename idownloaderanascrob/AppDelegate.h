//
//  AppDelegate.h
//  iDownloadAllPro
//
//  Created by Mac on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CustomTabBarController *customTabBarController;

- (NSString *)iDeviceType;

@end
