#import "TSParticleSystemQuad.h"


@implementation TSParticleSystemQuad

-(id) initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super initWithDictionary:dictionary])) {
        
        // fix the emission rate
        if ([dictionary objectForKey:@"emissionRate"]) {
            float value = [[dictionary objectForKey:@"emissionRate"] floatValue];
            if (value > 0.0) {
                emissionRate = value;
            }
        }
        
        // if end color is disabled, set it to the beginning color
        m_endColorEnabled = YES;
        if ([dictionary objectForKey:@"finishColorEnabled"]) {
            BOOL value = [[dictionary objectForKey:@"finishColorEnabled"] boolValue];
            m_endColorEnabled = value;
            if (value == NO) {
                endColor = startColor;
                endColorVar = startColorVar;
            }
        }
        
        // if all particles are the same color, just save the flag
        m_colorSet = NO;
        m_allParticlesSameColor = NO;
        if ([dictionary objectForKey:@"allParticlesSameColor"]) {
            BOOL value = [[dictionary objectForKey:@"allParticlesSameColor"] boolValue];
            m_allParticlesSameColor = value;
        }
    }
    return self;
}

-(void) initParticle:(tCCParticle *)particle
{
    [super initParticle:particle];
    if (m_endColorEnabled == NO) {
        particle->deltaColor.r = 0;
        particle->deltaColor.g = 0;
        particle->deltaColor.b = 0;
    }
    if (m_allParticlesSameColor) {
        if (m_colorSet) {
            particle->color = m_particleColor;
            particle->deltaColor = m_particleDeltaColor;
        }
        else {
            m_colorSet = YES;
            m_particleColor = particle->color;
            m_particleDeltaColor = particle->deltaColor;
        }
    }
}

@end
