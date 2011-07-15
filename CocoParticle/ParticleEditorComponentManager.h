#import <Foundation/Foundation.h>
#import "ParticleEditorSection.h"

@interface ParticleEditorComponentManager : NSObject {
    NSMutableArray* m_sections;
    BOOL m_isVisible;
}

-(void) setIsVisible:(BOOL)flag;
-(NSUInteger) getSectionCount;
-(ParticleEditorSection*) getSection:(NSUInteger)idx;
-(ParticleEditorSection*) addSectionWithName:(NSString*)name;
-(NSDictionary*) toDict;
-(id) toPropertyList;
-(void) anyValueChanged;
-(void) readValuesFromDict:(NSDictionary*)dict;

@end