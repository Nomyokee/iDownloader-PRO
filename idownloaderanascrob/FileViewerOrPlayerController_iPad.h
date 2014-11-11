//
//  FileViewerOrPlayerController_iPad.h
//  iDownloadAllPro
//
//  Created by Mac on 8/15/12.
//
//

#import <UIKit/UIKit.h>

@interface FileViewerOrPlayerController_iPad : UIViewController <UIWebViewDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIWebView *fileLoadingWebView;

- (IBAction)onBackButtonTap;

@end
