#import <Foundation/Foundation.h>
#import "DropboxSDK.h"

@interface DropBoxVC : UIViewController <DBLoginControllerDelegate, DBRestClientDelegate> {
    UIButton* linkButton;
    DBRestClient* m_dbRestClient;
}

-(void) updateButtons;
-(void) saveParticle:(NSNotification*)notif;

@end
