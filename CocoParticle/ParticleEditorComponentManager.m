#import "cocos2d.h"

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
        m_createdDate = [[NSDate date] retain];
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
                [d setObject:[[value retain] autorelease] forKey:component.m_key];
            }
        }
    }
    [d setObject:m_createdDate forKey:@"createdDate"];
    
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyyMMdd-HHmmss"];
    NSString* dateString = [dateFormatter stringFromDate:m_createdDate];
    
    NSString* uniqueName = [NSString stringWithFormat:@"%@-%@", [d objectForKey:@"name"], dateString];
    [d setObject:uniqueName forKey:@"uniqueName"];
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
    [m_createdDate release];
    m_createdDate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ANY_VALUE_CHANGED object:nil];
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
    if ([dict objectForKey:@"createdDate"]) {
        [m_createdDate release];
        m_createdDate = [[dict objectForKey:@"createdDate"] retain];
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

-(void) randomize
{
    BOOL wasVisible = m_isVisible;
    [self setIsVisible:NO];
    for (ParticleEditorSection* section in m_sections) {
        for (ParticleEditorComponent* component in section.m_components) {
            [component randomize];
        }
    }
    [self setIsVisible:wasVisible];
    [self anyValueChanged];
}

@end