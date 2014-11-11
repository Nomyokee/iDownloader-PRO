//
//  BookmarksViewController_iPad.h
//  iDownloadAllPro
//
//  Created by Mac on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarksViewController_iPad : UIViewController
{
    BOOL isEditing;
    
    NSMutableArray *_bookmarkNames;
}

@property (nonatomic, retain) NSMutableArray *bookmarkNames;

@property (weak, nonatomic) IBOutlet UITableView *tableViewBookMarks;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;

- (IBAction)onButtonBackClick:(id)sender;
- (IBAction)onButtonEditClick:(id)sender;

@end
