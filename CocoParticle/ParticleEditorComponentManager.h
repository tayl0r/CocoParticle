#import <Foundation/Foundation.h>

@interface ParticleEditorComponent : NSObject <UITextFieldDelegate> {
    NSString* m_name;
    NSString* m_key;
    NSInteger m_type;
    UIView* m_widget;
    UITextField* m_widgetValue;
    CGFloat m_height;
    NSArray* m_segments;
    UITableViewCell* m_cell;
}
@property (readonly) NSInteger m_type;
@property (readonly) NSString* m_name;
@property (readonly) NSString* m_key;
@property (readwrite, assign) UIView* m_widget;
@property (readwrite, assign) UITextField* m_widgetValue;
@property (readwrite) CGFloat m_height;
@property (readwrite, retain) UITableViewCell* m_cell;
-(id) initWithName:(NSString*)name key:(NSString*)key;
-(id) getValue;
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
@property (readonly) NSArray* m_components;
-(id) initWithName:(NSString*)name;
-(NSUInteger) getComponentCount;
-(ParticleEditorComponent*) getComponent:(NSUInteger)idx;
-(ParticleEditorComponent*) addComponentWithName:(NSString*)name key:(NSString*)key;
@end


@interface ParticleEditorComponentManager : NSObject {
    NSMutableArray* m_sections;
}
-(NSUInteger) getSectionCount;
-(ParticleEditorSection*) getSection:(NSUInteger)idx;
-(ParticleEditorSection*) addSectionWithName:(NSString*)name;
-(id) createPlist;
@end