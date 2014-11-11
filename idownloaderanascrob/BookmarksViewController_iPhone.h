//
//  BookMarksViewController.h
//  FreeMusicDownloader
//
//  Created by Pavel Pavlusha on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarksViewController_iPhone : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
    BOOL isEditing;
    
    NSMutableArray *_bookmarkNames;
}

@property (nonatomic, retain) NSMutableArray *bookmarkNames;

@property (retain, nonatomic) IBOutlet UITableView *tableViewBookMarks;
@property (retain, nonatomic) IBOutlet UIButton *buttonEdit;

- (IBAction)onButtonBackClick:(id)sender;
- (IBAction)onButtonEditClick:(id)sender;

@end
