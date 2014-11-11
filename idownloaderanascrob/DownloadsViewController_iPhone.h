//
//  DownloadsViewController_iPhone.h
//  iDownloadAllPro
//
//  Created by Mac on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadsViewController_iPhone : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    float downloadedSize;
    
    NSMutableArray *downloadsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *downloadsTableView;

- (IBAction)onButtonClearTap:(id)sender;


@end
