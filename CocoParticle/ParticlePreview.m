#import "ParticlePreview.h"
#import "ParticleEditorComponent.h"

@implementation CocosParticlePreview

+(CCScene*) scene
{
	CCScene *scene = [CCScene node];
	CocosParticlePreview *layer = [[[CocosParticlePreview alloc] init] autorelease];
	[scene addChild:layer];
	return scene;
}

-(id) init
{
	if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createParticle:) name:CREATE_PARTICLE_MESSAGE object:nil];
        //m_activeParticles = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) createParticle:(NSNotification*)notif
{
    /*for (CCParticleSystemQuad* p in m_activeParticles) {
        [p removeFromParentAndCleanup:YES];
    }*/
    if (m_activeParticle) {
        [m_activeParticle removeFromParentAndCleanup:YES];
    }
    [self unschedule:@selector(drawParticle)];
    
    if (m_pdata) {
        [m_pdata release];
        m_pdata = nil;
    }
    m_pdata = [[notif userInfo] retain];
    [self drawParticle];
    
    // schedule a new particle every <life>
    NSNumber* particleLife = [m_pdata objectForKey:@"particleLifespan"];
    NSNumber* systemDuration = [m_pdata objectForKey:@"duration"];
    [self schedule:@selector(drawParticle) interval:[particleLife floatValue] + [systemDuration floatValue]];
}

-(void) drawParticle
{
    TSParticleSystemQuad* p = [[[TSParticleSystemQuad alloc] initWithDictionary:m_pdata] autorelease];
    [self addChild:p];
    CGSize size = [[CCDirector sharedDirector] winSize];
    p.position = ccp(size.width/2, size.height/2);
    m_activeParticle = p;
    //[m_activeParticles addObject:p];
}

- (void) dealloc
{
    //[m_activeParticles release];
    //m_activeParticles = nil;
    if (m_pdata) {
        [m_pdata release];
        m_pdata = nil;
    }
	[super dealloc];
}

@end
