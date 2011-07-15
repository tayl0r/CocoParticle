#import "ParticleEditorComponent.h"

#define cpComponentTypeFloat 0
#define cpComponentTypeSegmentedInt 1
#define cpComponentTypeString 2

#define cpChoiceNames 0
#define cpChoiceValues 1

#define createParticleOnChange

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

-(void) anyValueChanged
{
#ifdef createParticleOnChange
    [[NSNotificationCenter defaultCenter] postNotificationName:ANY_VALUE_CHANGED object:self];
#endif
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

-(void) setValue:(NSObject*)obj
{
    if (m_widget) {
        if (m_type == cpComponentTypeString) {
            [(UITextField*)m_widget setText:(NSString*)obj];
        }
        else if (m_type == cpComponentTypeFloat) {
            [(UISlider*)m_widget setValue:[(NSNumber*)obj floatValue] animated:YES];
            [(UITextField*)m_widgetValue setText:[(NSNumber*)obj stringValue]];
        }
        else if (m_type == cpComponentTypeSegmentedInt) {
            NSInteger row = [(NSNumber*)obj integerValue];
            [(UISegmentedControl*)m_widget setSelectedSegmentIndex:row];
        }        
    }
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
    [self anyValueChanged];
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
    [self anyValueChanged];
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
    [seg addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    m_widget = [seg retain];
}

-(void) segmentedControlChanged:(UISegmentedControl *)seg
{
    [self anyValueChanged];
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