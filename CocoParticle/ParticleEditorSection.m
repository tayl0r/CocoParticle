#import "ParticleEditorSection.h"


@implementation ParticleEditorSection

@synthesize m_name, m_components;

-(id) initWithName:(NSString*)name
{
    if ((self = [super init])) {
        m_components = [[NSMutableArray alloc] init];
        m_name = [name retain];
    }
    return self;
}

-(NSUInteger) getComponentCount
{
    return [m_components count];
}

-(ParticleEditorComponent*) getComponent:(NSUInteger)idx
{
    return [m_components objectAtIndex:idx];
}

-(ParticleEditorComponent*) addComponentWithName:(NSString*)name key:(NSString *)key
{
    ParticleEditorComponent* component = [[[ParticleEditorComponent alloc] initWithName:name key:key] autorelease];
    [m_components addObject:component];
    return component;
}

-(void) dealloc
{
    [m_components release];
    m_components = nil;
    [m_name release];
    m_name = nil;
    [super dealloc];
}

@end