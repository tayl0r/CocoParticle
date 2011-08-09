#import "cocos2d.h"

#import "ParticleConfig.h"
#import "AppDelegate.h"
#import "GameConfig.h"
#import "ParticlePreview.h"
#import "RootViewController.h"
#import "DropBoxVC.h"
#import "ParticleList.h"

@implementation AppDelegate

@synthesize window, mainVC;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.autoresizesSubviews = YES;
    
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	mainVC = [[[RootViewController alloc] initWithNibName:nil bundle:nil] autorelease];
	//mainVC.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:window.bounds
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	// make the OpenGLView a child of the view controller
	[mainVC setView:glView];
    //mainVC.view.autoresizesSubviews = YES;
    //mainVC.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
	
    // left view controller is a tab bar controller
    leftVC = [[UITabBarController alloc] init];

    [self setupDropboxSession];
    DropBoxVC* dbvc = [[[DropBoxVC alloc] init] autorelease];
    [dbvc setTabBarItem:[[[UITabBarItem alloc] initWithTitle:@"Dropbox" image:[UIImage imageNamed:@"db.png"] tag:1] autorelease]];
    
    ParticleList* plvc = [[[ParticleList alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [plvc setTabBarItem:[[[UITabBarItem alloc] initWithTitle:@"Particle List" image:[UIImage imageNamed:@"applications_app.png"] tag:2] autorelease]];
    UINavigationController* plnav = [[[UINavigationController alloc] initWithRootViewController:plvc] autorelease];

    [leftVC setViewControllers:[NSArray arrayWithObjects:dbvc, plnav, nil] animated:YES];
    [leftVC setSelectedViewController:plnav];
    
    
    // setup the split view controller
    splitVC = [[UISplitViewController alloc] init];
    splitVC.viewControllers = [NSArray arrayWithObjects:leftVC, mainVC, nil];
    splitVC.delegate = self;
    
	// make the View Controller a child of the main window
	[window addSubview: splitVC.view];
	[window makeKeyAndVisible];
    
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [CocosParticlePreview scene]];
}

- (void) splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
}

- (void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    CCLOGERROR(@"MEMORY WARNING!! ################");
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:SAVE_PARTICLES_TO_DISK object:self];
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:SAVE_PARTICLES_TO_DISK object:self];
	CCDirector *director = [CCDirector sharedDirector];
	[[director openGLView] removeFromSuperview];
	[splitVC release];
	[window release];
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

-(void) setupDropboxSession
{
	// Set these variables before launching the app
    NSString* consumerKey = @"3psw00bshiv8qp4";
	NSString* consumerSecret = @"d2mxtbf35y3uzda";
	
	DBSession* session = [[DBSession alloc] initWithConsumerKey:consumerKey consumerSecret:consumerSecret];
	session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
	[DBSession setSharedSession:session];
    [session release];
    
    m_dbRestClient = [[DBRestClient alloc] initWithSession:session];
    [m_dbRestClient createFolder:COCOS_PARTICLE_CLOUD_FOLDER];
}

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session {
	DBLoginController* loginController = [[DBLoginController new] autorelease];
	[loginController presentFromController:splitVC];
}

- (void)dealloc {
    if (m_dbRestClient) {
        [m_dbRestClient release];
        m_dbRestClient = nil;
    }
	[super dealloc];
}

@end
