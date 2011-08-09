#import "cocos2d.h"

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
        m_locked = NO;
    }
    return self;
}

-(void) anyValueChanged
{
#ifdef createParticleOnChange
    //CCLOG(@"anyValueChanged %@", m_name);
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
            return [NSNumber numberWithFloat:m_floatValue];
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

-(void) randomize
{
    //CCLOG(@"randomizing %@", m_name);
    if (m_locked) {
        return;
    }
    if (m_widget) {
        if (m_type == cpComponentTypeString) {
            
        }
        else if (m_type == cpComponentTypeFloat) {
            float val = CCRANDOM_0_1() * (m_maxFloat - m_minFloat) + m_minFloat;
            [self setValue:[NSNumber numberWithFloat:val]];
        }
        else if (m_type == cpComponentTypeSegmentedInt) {
            int val = arc4random() % [m_segments count];
            [self setValue:[NSNumber numberWithInt:val]];
        }
    }
}

-(void) setValue:(NSObject*)obj
{
    if (m_widget) {
        if (m_type == cpComponentTypeString) {
            [(UITextField*)m_widget setText:(NSString*)obj];
        }
        else if (m_type == cpComponentTypeFloat) {
            if (m_scaleFlag) {
                [(UISlider*)m_widget setValue:[(NSNumber*)obj floatValue] animated:YES];
            }
            [self updateSlider:[(NSNumber*)obj floatValue]];
            [self updateSliderDone:(UISlider*)m_widget];
            
            /*m_floatValue = [(NSNumber*)obj floatValue];
            m_lastSliderValue = m_floatValue;
            [(UITextField*)m_widgetValue setText:[(NSNumber*)obj stringValue]];*/
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
    m_floatValue = value;
    m_widgetValue = [[UITextField alloc] init];
    m_widgetValue.text = [NSString stringWithFormat:@"%.2f", value];
    [m_widgetValue setDelegate:self];
}

-(void) textFieldDidEndEditing:(UITextField*)textField
{
    if (textField == m_widgetValue) {
        // update the widget with the new float value
        m_floatValue = [textField.text floatValue];
        if ([m_widget isMemberOfClass:[UISlider class]]) {
            [(UISlider*)m_widget setValue:m_floatValue animated:YES];
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
    [self setSliderWithMin:min andMax:max andScaleFlag:NO];
}

-(void) setSliderWithMin:(CGFloat)min andMax:(CGFloat)max andScaleFlag:(BOOL)scaleFlag
{
    [self setSliderWithMin:min andMax:max andScaleFlag:scaleFlag andRespectMin:YES];
}

-(void) setSliderWithMin:(CGFloat)min andMax:(CGFloat)max andRespectMin:(BOOL)respectMinFlag
{
    [self setSliderWithMin:min andMax:max andScaleFlag:NO andRespectMin:respectMinFlag];
}

-(void) setSliderWithMin:(CGFloat)min andMax:(CGFloat)max andScaleFlag:(BOOL)scaleFlag andRespectMin:(BOOL)respectMinFlag
{
    [self releaseWidget];
    m_scaleFlag = scaleFlag;
    m_type = cpComponentTypeFloat;
    UISlider* slider = [[[UISlider alloc] init] autorelease];
    m_maxFloat = max;
    m_minFloat = min;
    m_respectMin = respectMinFlag;
    if (m_scaleFlag) {
        slider.minimumValue = min;
        slider.maximumValue = max;
        [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else {
        float minmax = (max - min) / 30;
        slider.minimumValue = -1 * minmax;
        slider.maximumValue = minmax;
        m_lastSliderValue = 0;
        [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(updateSliderDone:) forControlEvents:UIControlEventTouchUpInside];
        [slider addTarget:self action:@selector(updateSliderDone:) forControlEvents:UIControlEventTouchUpOutside];
        //[slider addTarget:self action:@selector(updateSliderStart:) forControlEvents:UIControlEventTouchDown];
    }
    m_widget = [slider retain];
    
    [self setWidgetValue:0.0];
}

-(void) sliderChanged:(UISlider*)slider
{
    if (m_scaleFlag) {
        [self updateSlider:slider.value];
    }
    else {
        float diff = slider.value - m_lastSliderValue;
        if (fabs(slider.value) > slider.maximumValue/2) {
            // if we're adjusted by more than half the max value, increase the diff
            float ratio = fabs(slider.value) / slider.maximumValue;
            float newSliderValue = slider.value*(ratio*5);
            diff = newSliderValue - m_lastSliderValue;
            m_lastSliderValue = newSliderValue;
        }
        else {
            m_lastSliderValue = slider.value;
        }
        [self updateSlider:m_floatValue + diff];
    }
}

-(void) updateSliderDone:(UISlider*)slider
{
    [self sliderChanged:slider];
    if (m_scaleFlag == NO) {
        [slider setValue:0 animated:YES];
        m_lastSliderValue = 0;
    }
}

-(void) updateSlider:(float)value
{
    //UISlider* slider = (UISlider*)m_widget;
    if (m_scaleFlag) {
        // slider is full scale flag so just set the text widget value to the slider value
        m_floatValue = value;
    }
    else {
        m_floatValue = value;
        if (m_respectMin) {
            if (m_floatValue < m_minFloat) {
                m_floatValue = m_minFloat;
            }
        }
    }
    m_widgetValue.text = [NSString stringWithFormat:@"%.2f", m_floatValue];
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