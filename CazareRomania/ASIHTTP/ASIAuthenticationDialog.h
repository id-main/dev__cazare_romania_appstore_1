#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ASIHTTPRequest;

typedef enum _ASIAuthenticationType {
	ASIStandardAuthenticationType = 0,
    ASIProxyAuthenticationType = 1
} ASIAuthenticationType;

@interface ASIAutorotatingViewController : UIViewController
@end

@interface ASIAuthenticationDialog : ASIAutorotatingViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
	ASIHTTPRequest *request;
	ASIAuthenticationType type;
	UITableView *tableView;
	UIViewController *presentingController;
	BOOL didEnableRotationNotifications;
}
+ (void)presentAuthenticationDialogForRequest:(ASIHTTPRequest *)request;
+ (void)dismiss;

@property (retain) ASIHTTPRequest *request;
@property (assign) ASIAuthenticationType type;
@property (assign) BOOL didEnableRotationNotifications;
@property (retain, nonatomic) UIViewController *presentingController;
@end
