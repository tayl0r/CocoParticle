#import <Foundation/Foundation.h>


@interface ParticleList : UITableViewController {
    NSMutableArray* m_particles;
}

-(void) editRows;
-(void) addRowAtPath:(NSIndexPath*)path;

@end
