#import <Foundation/Foundation.h>

@interface ParticleEditorComponent : NSObject <UITextFieldDelegate> {
    NSString* m_name;
    UIView* m_widget;
    UITextField* m_widgetValue;
    CGFloat m_height;
    NSString* m_componentType;
    NSArray* m_segments;
}
@property (readonly) NSString* m_name;
@property (readonly) NSString* m_componentType;
@property (readonly) UIView* m_widget;
@property (readonly) UITextField* m_widgetValue;
@property (readwrite) CGFloat m_height;
-(id) initWithName:(NSString*)name;
-(void*) getValue;
-(void) releaseWidget;
-(void) setSliderWithMin:(CGFloat)min andMax:(CGFloat)max;
-(void) setWidgetValue:(CGFloat)value;
-(void) sliderChanged:(UISlider*)slider;
-(void) setTextInputWithDefault:(NSString*)text;
-(void) setSegmentedControlWithChoices:(NSArray*)choices;
@end


@interface ParticleEditorSection : NSObject {
    NSString* m_name;
    NSMutableArray* m_components;
}
@property (readonly) NSString* m_name;
-(id) initWithName:(NSString*)name;
-(NSUInteger) getComponentCount;
-(ParticleEditorComponent*) getComponent:(NSUInteger)idx;
-(ParticleEditorComponent*) addComponentWithName:(NSString*)name;
@end


@interface ParticleEditorComponentManager : NSObject {
    NSMutableArray* m_sections;
}
-(NSUInteger) getSectionCount;
-(ParticleEditorSection*) getSection:(NSUInteger)idx;
-(ParticleEditorSection*) addSectionWithName:(NSString*)name;
@end