//
//  FileViewerOrPlayerController_iPhone.h
//  iDownloadAllPro
//
//  Created by Mac on 8/15/12.
//
//

#import <UIKit/UIKit.h>

@interface FileViewerOrPlayerController_iPhone : UIViewController <UIWebViewDelegate>
{
    
}


@property (weak, nonatomic) IBOutlet UIWebView *fileLoadingWebView;

- (IBAction)onGoBackButtonTap;

@end
