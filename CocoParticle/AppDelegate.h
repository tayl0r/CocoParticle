#import <UIKit/UIKit.h>
#import "DropboxSDK.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, UISplitViewControllerDelegate, DBSessionDelegate> {
	UIWindow* window;
    UISplitViewController* splitVC;
	RootViewController* mainVC;
    UITabBarController* leftVC;
    DBRestClient* m_dbRestClient;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, readonly, assign) RootViewController* mainVC;

-(void) setupDropboxSession;

@end
