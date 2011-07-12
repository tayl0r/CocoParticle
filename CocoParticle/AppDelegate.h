//
//  AppDelegate.h
//  CocoParticle
//
//  Created by Taylor Steil on 7/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParticleList.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, UISplitViewControllerDelegate> {
	UIWindow* window;
    UISplitViewController* splitVC;
	RootViewController* mainVC;
    ParticleList* leftVC;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, readonly, assign) RootViewController* mainVC;

@end
