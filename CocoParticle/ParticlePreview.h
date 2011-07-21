#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TSParticleSystemQuad.h"

#import "ParticleList.h"

@interface CocosParticlePreview : CCLayer {
    //NSMutableArray* m_activeParticles;
    CCNode* m_activeParticle;
    NSDictionary* m_pdata;
}

+(CCScene*) scene;
-(void) createParticle:(NSNotification*)notif;
-(void) drawParticle;

@end
