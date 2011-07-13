#import "ParticlePreview.h"

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
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
