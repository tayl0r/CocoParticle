#import "ParticleConfig.h"
#import "ParticleEditorComponentManager.h"
#import "ParticleEditorComponent.h"

@implementation ParticleEditorComponentManager

-(id) init
{
    if ((self = [super init])) {
        m_sections = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(anyValueChanged) name:ANY_VALUE_CHANGED object:nil];
        m_isVisible = NO;
    }
    return self;
}

-(void) setIsVisible:(BOOL)flag
{
    m_isVisible = flag;
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

-(NSDictionary*) toDict
{
    NSMutableDictionary* d = [[[NSMutableDictionary alloc] init] autorelease];
    [d setObject:[NSNumber numberWithBool:NO] forKey:@"defaultParticle"];
    for (ParticleEditorSection* section in m_sections) {
        for (ParticleEditorComponent* component in section.m_components) {
            id value = [component getValue];
            if (value) {
                [d setObject:[component getValue] forKey:component.m_key];
            }
        }
    }
    return d;
}

-(id) toPropertyList
{    
    id plist = [NSPropertyListSerialization dataFromPropertyList:[self toDict] format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    return plist;
}

-(void) dealloc
{
    [m_sections release];
    m_sections = nil;
    [super dealloc];
}

-(void) readValuesFromDict:(NSDictionary*)dict
{
    for (ParticleEditorSection* section in m_sections) {
        for (ParticleEditorComponent* component in section.m_components) {
            NSString* componentKey = component.m_key;
            NSObject* dictValue = [dict objectForKey:componentKey];
            if (dictValue == nil) {
                continue;
            }
            [component setValue:dictValue];
        }
    }
    [self anyValueChanged];
}

-(void) anyValueChanged
{
    if (m_isVisible == NO) {
        return;
    }
    NSDictionary* pdata = [self toDict];
    [[NSNotificationCenter defaultCenter] postNotificationName:CREATE_PARTICLE_MESSAGE object:self userInfo:pdata];
}

@end