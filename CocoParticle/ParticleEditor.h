#import <Foundation/Foundation.h>

#import "ParticleEditorComponentManager.h"

@interface ParticleEditor : UITableViewController {
    ParticleEditorComponentManager* m_componentManager;
    ParticleEditorComponent* m_name;
}

-(void) loadEditor;
-(void) unloadEditor;
-(NSString*) getName;
-(NSDictionary*) toDict;
-(void) readValuesFromDict:(NSDictionary*)dict;

@end
