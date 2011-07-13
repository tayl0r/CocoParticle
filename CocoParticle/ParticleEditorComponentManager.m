#import "ParticleEditorComponentManager.h"

@implementation ParticleEditorComponent

@synthesize m_name, m_widget, m_height;

-(id) initWithName:(NSString*)name
{
    if ((self = [super init])) {
        m_name = [name retain];
    }
    return self;
}

-(void) setSliderWithMin:(CGFloat)min andMax:(CGFloat)max
{
    if (m_widget) {
        [m_widget release];
        m_widget = nil;
    }
    UISlider* slider = [[[UISlider alloc] init] autorelease];
    //slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    slider.minimumValue = min;
    slider.maximumValue = max;
    m_widget = [slider retain];
}

-(void) dealloc
{
    if (m_widget) {
        [m_widget release];
        m_widget = nil;
    }
    [m_name release];
    m_name = nil;
    [super dealloc];
}

@end


@implementation ParticleEditorSection

@synthesize m_name;

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

-(ParticleEditorComponent*) addComponentWithName:(NSString*)name
{
    ParticleEditorComponent* component = [[[ParticleEditorComponent alloc] initWithName:name] autorelease];
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


@implementation ParticleEditorComponentManager

-(id) init
{
    if ((self = [super init])) {
        m_sections = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSUInteger) getSectionCount
{
    return [m_sections count];
}

-(ParticleEditorSection*) getSection:(NSUInteger)idx
{
    return [m_sections objectAtIndex:idx];
}

-(ParticleEditorSection*) addSectionWithName:(NSString*)name
{
    ParticleEditorSection* section = [[[ParticleEditorSection alloc] initWithName:name] autorelease];
    [m_sections addObject:section];
    return section;
}

-(void) dealloc
{
    [m_sections release];
    m_sections = nil;
    [super dealloc];
}

@end