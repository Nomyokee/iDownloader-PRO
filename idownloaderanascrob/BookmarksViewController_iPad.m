//
//  BookmarksViewController_iPad.m
//  iDownloadAllPro
//
//  Created by Mac on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookmarksViewController_iPad.h"
#import "EnterPasscodeViewController_iPad.h"

@interface BookmarksViewController_iPad()

- (void)dismissModalViewController;

@end


@implementation BookmarksViewController_iPad

@synthesize tableViewBookMarks = _tableViewBookMarks;
@synthesize buttonEdit = _buttonEdit;

@synthesize bookmarkNames = _bookmarkNames;

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

- (void)dismissModalViewController 
{
    [self dismissModalViewControllerAnimated:NO];
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
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(openPasscodeViewIfNeeded) 
                                                 name:@"OpenPasscodeViewIfNeeded" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(openPasscodeViewIfNeeded) 
                                                 name:@"OpenPasscodeViewIfNeeded" 
                                               object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    
    self.bookmarkNames = [NSMutableArray arrayWithArray:[[defaults dictionaryForKey:@"BookmarkNames"] allKeys]];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setTableViewBookMarks:nil];
    [self setButtonEdit:nil];
    [self setBookmarkNames:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.bookmarkNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
    return 100.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
    static NSString *CellIdentifier = @"Cell";    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *backgroundImage = [UIImage imageNamed:@"cell_background"];    
        UIImage *starImage       = [UIImage imageNamed:@"star"];    
        UIImage *accessoryImage  = [UIImage imageNamed:@"arrow_open"];
        
        UIImageView *imageViewBackground  = [[UIImageView alloc] initWithImage:backgroundImage];    
        UIImageView *imageViewStar        = [[UIImageView alloc] initWithImage:starImage];
        UIImageView *imageViewBackgroundAccessory = [[UIImageView alloc] initWithImage:accessoryImage];    
        UILabel     *labelBookMark     = [[UILabel alloc] init];
        
        labelBookMark.backgroundColor  = [UIColor clearColor];
        labelBookMark.font = [UIFont systemFontOfSize:30.0f];
        labelBookMark.text             = [self.bookmarkNames objectAtIndex:indexPath.row];
        labelBookMark.tag = 1;
        imageViewStar.tag = 2;
        
        imageViewBackground.frame = CGRectMake(0, 0, 768, 100);
        imageViewStar.frame = CGRectMake(20, 20, 52, 50);
        imageViewBackgroundAccessory.frame = CGRectMake(720, 25, 34, 50);        
        
        [cell addSubview:imageViewBackground];
        [cell addSubview:imageViewStar];
        [cell addSubview:imageViewBackgroundAccessory];
        [cell addSubview:labelBookMark];     
    } 
    else 
    {
        ((UILabel *) [cell viewWithTag:1]).text = [self.bookmarkNames objectAtIndex:indexPath.row];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (isEditing) 
    {            
        [cell viewWithTag:1].frame = CGRectMake(100, 20, 600, 60);
        [cell viewWithTag:2].frame = CGRectMake(35, 20, 52, 50);            
    }
    else 
    {        
        [cell viewWithTag:1].frame = CGRectMake(80, 20, 620, 60);
        [cell viewWithTag:2].frame = CGRectMake(10, 20, 52, 50);            
    }
    
    [UIView commitAnimations];    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUserDefaults  *defaults  = [NSUserDefaults standardUserDefaults];    
    NSDictionary    *bookmarks = [defaults dictionaryForKey:@"BookmarkNames"];    
    NSString        *url       = [bookmarks objectForKey:[self.bookmarkNames objectAtIndex:indexPath.row]];
    
    [defaults setObject:url forKey:@"RequestedURL"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"URLWasRequested"
                                                        object:nil
                                                      userInfo:nil];        
    [self dismissModalViewControllerAnimated:YES];
}

- (void)    tableView:(UITableView *)tableView 
   commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
    forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        NSUserDefaults      *defaults         = [NSUserDefaults standardUserDefaults]; 
        NSMutableDictionary *newBookmarkNames = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:@"BookmarkNames"]];              
        
        [newBookmarkNames removeObjectForKey:[self.bookmarkNames objectAtIndex:indexPath.row]];
        
        [defaults setObject:newBookmarkNames forKey:@"BookmarkNames"];
        [defaults synchronize];
        
        self.bookmarkNames = [NSMutableArray arrayWithArray:[newBookmarkNames allKeys]];
        
        [self.tableViewBookMarks deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];        
    }
}

- (IBAction)onButtonBackClick:(id)sender 
{    
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)setEditing 
{
    if (isEditing) 
    {
        [self.tableViewBookMarks setEditing:YES animated:YES];
    }
    else 
    {
        [self.tableViewBookMarks setEditing:NO animated:YES];
    }
}

- (IBAction)onButtonEditClick:(id)sender 
{
    if (isEditing) 
    {
        [self.buttonEdit setImage:[UIImage imageNamed:@"button_edit.png"] forState:UIControlStateNormal];
        isEditing = NO;
    }
    else 
    {
        [self.buttonEdit setImage:[UIImage imageNamed:@"button_done.png"] forState:UIControlStateNormal];
        isEditing = YES;
    }
    
    [self.tableViewBookMarks reloadData];
    [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(setEditing) userInfo:nil repeats:NO];
}

@end