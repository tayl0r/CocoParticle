#import "CocosParticle.h"


@implementation CocosParticle

@synthesize m_name;

-(id) init
{
    if ((self = [super init])) {
        m_name = @"My New Particle";
    }
    return self;
}

@end
