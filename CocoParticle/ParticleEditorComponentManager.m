#import "ParticleEditorComponentManager.h"

#define cpComponentTypeFloat 0
#define cpComponentTypeSegmentedInt 1
#define cpComponentTypeString 2

#define cpChoiceNames 0
#define cpChoiceValues 1

@implementation ParticleEditorComponent

@synthesize m_name, m_widget, m_height, m_widgetValue, m_cell, m_type, m_key;

-(id) initWithName:(NSString*)name key:(NSString*)key
{
    if ((self = [super init])) {
        m_name = [name retain];
        m_key = [key retain];
    }
    return self;
}

-(id) getValue
{
    if (m_widget) {
        if (m_type == cpComponentTypeString) {
            return [(UITextField*)m_widget text];
        }
        else if (m_type == cpComponentTypeFloat) {
            return [NSNumber numberWithFloat:[m_widgetValue.text floatValue]];
        }
        else if (m_type == cpComponentTypeSegmentedInt) {
            NSInteger row = [(UISegmentedControl*)m_widget selectedSegmentIndex];
            if (row == UISegmentedControlNoSegment) {
                return nil;
            }
            NSArray* choiceValues = [m_segments objectAtIndex:cpChoiceValues];
            return [choiceValues objectAtIndex:row];
        }
    }
    return nil;
}

-(void) setWidgetValue:(CGFloat)value
{
    if (m_widgetValue) {
        [m_widgetValue release];
        m_widgetValue = nil;
    }
    m_widgetValue = [[UITextField alloc] init];
    m_widgetValue.text = [NSString stringWithFormat:@"%.2f", value];
    [m_widgetValue setDelegate:self];
}

-(void) textFieldDidEndEditing:(UITextField*)textField
{
    if (textField == m_widgetValue) {
        // update the widget with the new float value
        CGFloat value = [textField.text floatValue];
        if ([m_widget isMemberOfClass:[UISlider class]]) {
            [(UISlider*)m_widget setValue:value animated:YES];
        }
    }
    else if (textField == m_widget) {
        // do nothing, we dont care if they edit this one
    }
}

-(void) setTextInputWithDefault:(NSString*)text
{
    [self releaseWidget];
    m_type = cpComponentTypeString;
    UITextField* tf = [[[UITextField alloc] init] autorelease];
    tf.text = text;
    [tf setDelegate:self];
    tf.textColor = [UIColor blackColor];
    tf.backgroundColor = [UIColor clearColor];
    tf.font = [UIFont systemFontOfSize:16.0];
    m_widget = [tf retain];
}

-(void) releaseWidget
{
    if (m_widget) {
        [m_widget release];
        m_widget = nil;
    }
}

-(void) setSliderWithMin:(CGFloat)min andMax:(CGFloat)max
{
    [self releaseWidget];
    m_type = cpComponentTypeFloat;
    UISlider* slider = [[[UISlider alloc] init] autorelease];
    slider.minimumValue = min;
    slider.maximumValue = max;
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    m_widget = [slider retain];
    
    [self setWidgetValue:0.0];
}

-(void) sliderChanged:(UISlider*)slider
{
    m_widgetValue.text = [NSString stringWithFormat:@"%.2f", slider.value];
}

-(void) setSegmentedControlWithChoices:(NSArray *)choices
{
    [self releaseWidget];
    if (m_segments) {
        [m_segments release];
    }
    m_segments = [choices retain];
    m_type = cpComponentTypeSegmentedInt;
    NSArray* choiceNames = [choices objectAtIndex:cpChoiceNames];
    UISegmentedControl* seg = [[[UISegmentedControl alloc] initWithItems:choiceNames] autorelease];
    [seg setSelectedSegmentIndex:0];
    m_widget = [seg retain];    
}

-(void) dealloc
{
    [self releaseWidget];
    if (m_widgetValue) {
        [m_widgetValue release];
        m_widgetValue = nil;
    }
    if (m_segments) {
        [m_segments release];
        m_segments = nil;
    }
    [m_name release];
    m_name = nil;
    [m_key release];
    m_key = nil;
    if (m_cell) {
        [m_cell release];
        m_cell = nil;
    }
    [super dealloc];
}

@end


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

-(id) createPlist
{
    NSMutableDictionary* d = [[[NSMutableDictionary alloc] init] autorelease];
    
    for (ParticleEditorSection* section in m_sections) {
        for (ParticleEditorComponent* component in section.m_components) {
            [d setObject:[component getValue] forKey:component.m_key];
        }
    }
    
    id plist = [NSPropertyListSerialization dataFromPropertyList:d format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    return plist;
}

-(void) dealloc
{
    [m_sections release];
    m_sections = nil;
    [super dealloc];
}

@end