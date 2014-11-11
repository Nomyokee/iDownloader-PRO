//
//  FilesViewController_iPhone.h
//  iDownloadAllPro
//
//  Created by Mac on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilesViewController_iPhone : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    BOOL isEditing;
}

@property (weak, nonatomic) IBOutlet UITableView *filesTableView;

@property (nonatomic, strong) NSMutableArray *filesNamesArray;

@end
