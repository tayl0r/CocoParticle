#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TSParticleSystemQuad : CCParticleSystemQuad {
    BOOL m_endColorEnabled;
    BOOL m_allParticlesSameColor;
    BOOL m_colorSet;
    ccColor4F m_particleColor;
    ccColor4F m_particleDeltaColor;
}

@end
