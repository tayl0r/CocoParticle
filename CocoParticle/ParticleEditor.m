#import "cocos2d.h"

#import "ParticleEditor.h"

@implementation ParticleEditor

-(id) initWithParticle:(CocosParticle *)cp
{
    if ((self == [super initWithStyle:UITableViewStyleGrouped])) {
        m_cp = [cp retain];
        
        // add all the editable components
        m_componentManager = [[ParticleEditorComponentManager alloc] init];
        
        // base section
        ParticleEditorSection* base = [m_componentManager addSectionWithName:@"Base"];
        
        ParticleEditorComponent* name = [base addComponentWithName:@"Name"];
        [name setTextInputWithDefault:cp.m_name];
        
        ParticleEditorComponent* type = [base addComponentWithName:@"Particle Type"];
        [type setSegmentedControlWithChoices:[NSArray arrayWithObjects:@"Gravity", @"Radius", nil]];
        
        ParticleEditorComponent* life = [base addComponentWithName:@"Life"];
        [life setSliderWithMin:0 andMax:100];
        
        ParticleEditorComponent* lifev = [base addComponentWithName:@"Life Variance"];
        [lifev setSliderWithMin:0 andMax:100];
        
        
        // gravity mode
        ParticleEditorSection* gravity = [m_componentManager addSectionWithName:@"Gravity Mode"];
        [gravity addComponentWithName:@"Gravity"];
        [gravity addComponentWithName:@"Direction"];
        [gravity addComponentWithName:@"Speed"];
        [gravity addComponentWithName:@"Speed Variance"];
        [gravity addComponentWithName:@"Tangential Acceleration"];
        [gravity addComponentWithName:@"Tangential Acceleration Variance"];
        [gravity addComponentWithName:@"Radial Acceleration"];
        ParticleEditorComponent* radaccelv = [gravity addComponentWithName:@"Radial Acceleration Variance"];
        [radaccelv setSliderWithMin:0 andMax:100];
        
        ParticleEditorSection* radius = [m_componentManager addSectionWithName:@"Radius Mode"];
        [radius addComponentWithName:@"Start Radius"];
        [radius addComponentWithName:@"Start Radius Variance"];
        [radius addComponentWithName:@"End Radius"];
        [radius addComponentWithName:@"End Radius Variance"];
        [radius addComponentWithName:@"Rotation"];
        [radius addComponentWithName:@"Rotation Variance"];
        
        //ParticleEditorSection* spin = [m_componentManager addSectionWithName:@"Spin"];
        //ParticleEditorSection* size = [m_componentManager addSectionWithName:@"Size"];
        //ParticleEditorSection* color = [m_componentManager addSectionWithName:@"Color"];
        //ParticleEditorSection* blendFunc = [m_componentManager addSectionWithName:@"Blending Function"];
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //CGRect bounds = self.parentViewController.view.bounds;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    return [m_componentManager getSectionCount];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    ParticleEditorSection* pSection = [m_componentManager getSection:section];
    return [pSection getComponentCount];
}

-(NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    ParticleEditorSection* pSection = [m_componentManager getSection:section];
    return pSection.m_name;
}

#define MAINLABEL_TAG 1
#define MAINWIDGET_TAG 2
#define MAINVALUE_TAG 3

-(UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    ParticleEditorSection* section = [m_componentManager getSection:indexPath.section];
    ParticleEditorComponent* component = [section getComponent:indexPath.row];

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:component.m_componentType];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:component.m_componentType] autorelease];
        UIView* widget = component.m_widget;
        if (widget) {
            CGFloat sizeMod = 0;

            // textLabel
            UILabel* name = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5.0, cell.frame.size.width - 40, 25.0)] autorelease];
            name.tag = MAINLABEL_TAG;
            name.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            name.textColor = [UIColor blackColor];
            name.backgroundColor = [UIColor clearColor];
            name.font = [UIFont boldSystemFontOfSize:16.0];
            name.textAlignment = UITextAlignmentLeft;
            [cell.contentView addSubview:name];
            
            // main widget
            widget.tag = MAINWIDGET_TAG;
            widget.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            CGRect frame = cell.contentView.frame;
            frame.origin.x = 10;
            frame.size.width = frame.size.width - frame.origin.x*2 - 80;
            frame.size.height = 35;
            frame.origin.y = name.frame.size.height + name.frame.origin.y - 5;
            if ([widget isMemberOfClass:[UITextField class]]) {
                frame.origin.y += 7;
            }
            else if ([widget isMemberOfClass:[UISegmentedControl class]]) {
                frame.origin.y += 10;
                sizeMod += 15;
            }
            widget.frame = frame;
            [cell.contentView addSubview:widget];
            
            // slide value widget
            UITextField* widgetValue = component.m_widgetValue;
            widgetValue.tag = MAINVALUE_TAG;
            widgetValue.frame = CGRectMake(frame.size.width + frame.origin.x*1.5, widget.frame.origin.y + 7, 80, frame.size.height);
            widgetValue.keyboardType = UIKeyboardTypeDecimalPad;
            widgetValue.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            widgetValue.textAlignment = UITextAlignmentRight;
            widgetValue.textColor = [UIColor blackColor];
            widgetValue.backgroundColor = [UIColor clearColor];
            widgetValue.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:widgetValue];
            
            component.m_height = widget.frame.size.height + name.frame.size.height + sizeMod;
        }
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = component.m_name;
    UIView* widget = component.m_widget;
    if (widget) {
        // textLabel
        UILabel* name = (UILabel*)[cell.contentView viewWithTag:MAINLABEL_TAG];
        name.text = cell.textLabel.text;
        cell.textLabel.text = nil;

        // main widget
        void* value = [component getValue];
        if ([widget isMemberOfClass:[UISlider class]]) {
            [(UISlider*)widget setValue:[(NSString*)value floatValue] animated:NO];
            // slide value widget
            UITextField* widgetValue = (UITextField*)[cell.contentView viewWithTag:MAINVALUE_TAG];
            widgetValue.text = (NSString*)value;
        }
        else if ([widget isMemberOfClass:[UITextField class]]) {
            [(UITextField*)widget setText:(NSString*)value];
        }
        else if ([widget isMemberOfClass:[UISegmentedControl class]]) {
            NSNumber* row = [(NSArray*)value objectAtIndex:0];
            [(UISegmentedControl*)widget setEnabled:YES forSegmentAtIndex:[row integerValue]];
        }
    }
    else {
        component.m_height = cell.contentView.bounds.size.height;
    }
    return cell;
}

-(CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self tableView:tableView cellForRowAtIndexPath:indexPath];
    ParticleEditorSection* section = [m_componentManager getSection:indexPath.section];
    ParticleEditorComponent* component = [section getComponent:indexPath.row];
    return component.m_height;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(void) dealloc
{
    [m_cp release];
    m_cp = nil;
    [m_componentManager release];
    m_componentManager = nil;
    [super dealloc];
}

@end
