#import <Foundation/Foundation.h>

#import "CocosParticle.h"
#import "ParticleEditorComponentManager.h"

@interface ParticleEditor : UITableViewController {
    CocosParticle* m_cp;
    ParticleEditorComponentManager* m_componentManager;
}

-(id) initWithParticle:(CocosParticle*)cp;

@end
