#import <Foundation/Foundation.h>

@interface ParticleList : UITableViewController {
    NSMutableArray* m_particles;
    UITabBarController* m_tabBar;
}

-(void) editRows;
-(void) addRowAtPath:(NSIndexPath*)path;
-(void) saveParticlesToDisk;

@end
