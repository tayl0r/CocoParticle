#import <Foundation/Foundation.h>
#import "ParticleEditorComponent.h"

@interface ParticleEditorSection : NSObject {
    id m_manager;
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