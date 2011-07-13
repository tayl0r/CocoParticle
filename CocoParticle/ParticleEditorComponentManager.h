#import <Foundation/Foundation.h>

@interface ParticleEditorComponent : NSObject {
    NSString* m_name;
    UIView* m_widget;
    CGFloat m_height;
}
@property (readonly) NSString* m_name;
@property (readonly) UIView* m_widget;
@property (readwrite) CGFloat m_height;
-(id) initWithName:(NSString*)name;
-(void) setSliderWithMin:(CGFloat)min andMax:(CGFloat)max;
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