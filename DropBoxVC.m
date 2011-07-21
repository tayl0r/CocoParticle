#import "cocos2d.h"
#import "DropBoxVC.h"
#import "ParticleConfig.h"

@implementation DropBoxVC

-(id) init
{
    if ((self = [super init])) {
        self.title = @"Dropbox Setup";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveParticle:) name:SAVE_PARTICLE_TO_CLOUD object:nil];
    }
    return self;
}

-(void) loadView
{
    self.view = [[[UIView alloc] init] autorelease];
    self.view.autoresizesSubviews = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    linkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [linkButton setFrame:CGRectMake(25, 25, 145, 37)];
    linkButton.center = self.view.center;
    linkButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    linkButton.userInteractionEnabled = YES;
    [linkButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
    [linkButton setTitleColor:[UIColor colorWithHue:.6 saturation:.63 brightness:.60 alpha:1] forState:UIControlStateNormal];
    [linkButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [linkButton addTarget:self action:@selector(didPressLink) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:linkButton];
    
}

- (void)didPressLink {
    if (![[DBSession sharedSession] isLinked]) {
        DBLoginController* controller = [[DBLoginController new] autorelease];
        controller.delegate = self;
        [controller presentFromController:self];
    } else {
        [[DBSession sharedSession] unlink];
        [[[[UIAlertView alloc] 
           initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked" 
           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
          autorelease]
         show];
        [self updateButtons];
    }
}

-(void) saveParticle:(NSNotification*)notif
{
    NSDictionary* pData = [notif userInfo];
    NSString* fileName = [pData objectForKey:@"uniqueName"];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileNameWithExtension = [NSString stringWithFormat:@"%@.plist", fileName];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:fileNameWithExtension];
    id plist = [NSPropertyListSerialization dataFromPropertyList:pData format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    if ([plist writeToFile:plistPath atomically:YES] == NO) {
        CCLOGERROR(@"could not write to %@", plistPath);
    }
    
    if (!m_dbRestClient) {
        m_dbRestClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        [m_dbRestClient setDelegate:self];
    }
    [m_dbRestClient uploadFile:fileNameWithExtension toPath:COCOS_PARTICLE_CLOUD_FOLDER fromPath:plistPath];
    CCLOG(@"saving file %@", fileNameWithExtension);
}
         
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateButtons];
    [[NSNotificationCenter defaultCenter] postNotificationName:SAVE_PARTICLES_TO_DISK object:nil];
}

- (void)dealloc {
    [linkButton release];
    linkButton = nil;
    if (m_dbRestClient) {
        [m_dbRestClient release];
        m_dbRestClient = nil;
    }
    [super dealloc];
}

// all view controllers that are part of the UISplitViewController must implement this
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark DBLoginControllerDelegate methods

- (void)loginControllerDidLogin:(DBLoginController*)controller {
    [self updateButtons];
}

- (void)loginControllerDidCancel:(DBLoginController*)controller {
    
}

#pragma mark DBRestClientDelegate methods

-(void) restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath
{
    CCLOG(@"UPLOAD DONE: %@", destPath);
}

-(void) restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
{
    CCLOG(@"UPLOAD ERROR: %@", [error localizedDescription]);
}

-(void) restClient:(DBRestClient *)client uploadProgress:(CGFloat)progress forFile:(NSString *)destPath from:(NSString *)srcPath
{
    CCLOG(@"UPLOAD PROGRESS: %f => %@", progress, destPath);
}

#pragma mark private methods

- (void)updateButtons {
    NSString* title = [[DBSession sharedSession] isLinked] ? @"Unlink Dropbox" : @"Link Dropbox";
    [linkButton setTitle:title forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem.enabled = [[DBSession sharedSession] isLinked];
}

@end
