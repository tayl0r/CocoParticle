#import <Foundation/Foundation.h>
#import "ParticleEditorComponent.h"

#define CREATE_PARTICLE_MESSAGE @"create particle!"
#define ANY_VALUE_CHANGED @"any value changed"

@interface ParticleEditorComponent : NSObject <UITextFieldDelegate> {
    NSString* m_name;
    NSString* m_key;
    NSInteger m_type;
    UIView* m_widget;
    UITextField* m_widgetValue;
    CGFloat m_height;
    NSArray* m_segments;
    UITableViewCell* m_cell;
    BOOL m_scaleFlag;
    float m_floatValue;
    float m_maxFloat;
    float m_minFloat;
    BOOL m_respectMin;
    float m_lastSliderValue;
    BOOL m_locked;
}

@property (readonly) NSInteger m_type;
@property (readonly) NSString* m_name;
@property (readonly) NSString* m_key;
@property (readwrite, assign) UIView* m_widget;
@property (readwrite, assign) UITextField* m_widgetValue;
@property (readwrite) CGFloat m_height;
@property (readwrite, retain) UITableViewCell* m_cell;

-(id) initWithName:(NSString*)name key:(NSString*)key;
-(void) anyValueChanged;
-(id) getValue;
-(void) setValue:(NSObject*)obj;
-(void) releaseWidget;
-(void) setSliderWithMin:(CGFloat)min andMax:(CGFloat)max;
-(void) setSliderWithMin:(CGFloat)min andMax:(CGFloat)max andScaleFlag:(BOOL)scaleFlag;
-(void) setSliderWithMin:(CGFloat)min andMax:(CGFloat)max andRespectMin:(BOOL)respectMinFlag;
-(void) setSliderWithMin:(CGFloat)min andMax:(CGFloat)max andScaleFlag:(BOOL)scaleFlag andRespectMin:(BOOL)respectMinFlag;
-(void) setWidgetValue:(CGFloat)value;

-(void) sliderChanged:(UISlider*)slider;
-(void) updateSlider:(float)value;
-(void) updateSliderDone:(UISlider*)slider;

-(void) setTextInputWithDefault:(NSString*)text;
-(void) setSegmentedControlWithChoices:(NSArray*)choices;
-(void) segmentedControlChanged:(UISegmentedControl*)seg;

-(void) randomize;

@end